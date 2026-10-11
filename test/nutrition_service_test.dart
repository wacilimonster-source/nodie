import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/repositories/event_repository.dart';
import 'package:cyjl/data/repositories/medication_repository.dart';
import 'package:cyjl/domain/plan_slot.dart';
import 'package:cyjl/domain/services.dart';

void main() {
  late AppDatabase db;
  late AppDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = AppDao(db);
  });
  tearDown(() async => db.close());

  Future<String> makeSupplement(List<IngredientDraft> ings) =>
      MedicationRepository(dao).create(MedDraft(
        name: '复合维生素',
        type: MedType.supplement,
        form: '片剂',
        color: '#7BA96A',
        emoji: '🧬',
        freq: FreqType.daily,
        slots: const [PlanSlot(time: '08:00', dose: 1, unit: '片')],
        unit: '片',
        startDate: DateTime(2026, 1, 1),
        ingredients: ings,
      ));

  String todayKey() {
    final d = DateTime.now();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  group('NutritionService', () {
    test('汇总多成分摄入', () async {
      final medId = await makeSupplement(const [
        IngredientDraft(nutrientCode: 'vd', amountPerUnit: 25),
        IngredientDraft(nutrientCode: 'vc', amountPerUnit: 60),
      ]);
      final events = EventRepository(dao, StockService(dao));
      await events.logAsNeeded(medId: medId, dose: 1);

      final service = NutritionService(dao);
      final result = await service.summarizeDay(todayKey(), femaleProfile: false);
      final vd = result.firstWhere((i) => i.nutrient.code == 'vd');
      final vc = result.firstWhere((i) => i.nutrient.code == 'vc');
      expect(vd.amount, 25);
      expect(vc.amount, 60);
      expect(vc.reached(false), isFalse); // 60 < 100
      expect(vd.reached(false), isTrue); // 25 ≥ 10
      expect(vd.sources.single.name, '复合维生素');
    });

    test('多剂量叠加', () async {
      final medId = await makeSupplement(const [
        IngredientDraft(nutrientCode: 'omg', amountPerUnit: 300),
      ]);
      final events = EventRepository(dao, StockService(dao));
      await events.logAsNeeded(medId: medId, dose: 2);
      await events.logAsNeeded(medId: medId, dose: 2);

      final result = await NutritionService(dao).summarizeDay(todayKey(), femaleProfile: false);
      final omg = result.firstWhere((i) => i.nutrient.code == 'omg');
      expect(omg.amount, 1200);
    });

    test('UL 超限识别', () async {
      final medId = await makeSupplement(const [
        IngredientDraft(nutrientCode: 'vd', amountPerUnit: 60), // > UL 50
      ]);
      await EventRepository(dao, StockService(dao)).logAsNeeded(medId: medId, dose: 1);
      final result = await NutritionService(dao).summarizeDay(todayKey(), femaleProfile: false);
      final vd = result.firstWhere((i) => i.nutrient.code == 'vd');
      expect(vd.overUl, isTrue);
    });

    test('人群档案影响铁 RNI（男12 / 女20）', () async {
      final medId = await makeSupplement(const [
        IngredientDraft(nutrientCode: 'fe', amountPerUnit: 15),
      ]);
      await EventRepository(dao, StockService(dao)).logAsNeeded(medId: medId, dose: 1);
      final result = await NutritionService(dao).summarizeDay(todayKey(), femaleProfile: false);
      final fe = result.firstWhere((i) => i.nutrient.code == 'fe');
      expect(fe.goal(false), 12); // 男性
      expect(fe.goal(true), 20); // 女性
      expect(fe.reached(false), isTrue); // 15 ≥ 12
      expect(fe.reached(true), isFalse); // 15 < 20
    });
  });
}
