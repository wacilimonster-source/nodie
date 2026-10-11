import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/repositories/medication_repository.dart';
import 'package:cyjl/domain/plan_slot.dart';
import 'package:cyjl/domain/services.dart';

Future<String> makeMed(
  AppDao dao, {
  required FreqType freq,
  List<int> weekdays = const [],
  int intervalDays = 2,
  int cycleOn = 5,
  int cycleOff = 2,
  List<PlanSlot>? slots,
  List<IngredientDraft> ingredients = const [],
  bool stockEnabled = false,
  double? stock,
  int lowStockDays = 7,
  DateTime? start,
}) {
  return MedicationRepository(dao).create(MedDraft(
    name: '测试保健品',
    type: MedType.supplement,
    form: '片剂',
    color: '#5F8D4E',
    emoji: '🌿',
    stockEnabled: stockEnabled,
    stock: stock,
    lowStockDays: lowStockDays,
    freq: freq,
    weekdays: weekdays,
    intervalDays: intervalDays,
    cycleOn: cycleOn,
    cycleOff: cycleOff,
    slots: slots ?? const [PlanSlot(time: '08:00', dose: 1, unit: '片')],
    unit: '片',
    startDate: start ?? DateTime(2026, 1, 1),
    ingredients: ingredients,
  ));
}

void main() {
  late AppDatabase db;
  late AppDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = AppDao(db);
  });

  tearDown(() async => db.close());

  group('EventGenerator', () {
    final now = DateTime(2030, 1, 1, 6, 0); // 2030-01-01 周二 06:00

    test('daily 生成 7 天事件且幂等', () async {
      await makeMed(dao, freq: FreqType.daily);
      final gen = EventGenerator(dao);
      expect(await gen.run(daysAhead: 7, now: now), 7);
      expect(await gen.run(daysAhead: 7, now: now), 0); // 幂等
    });

    test('asNeeded 不生成事件', () async {
      await makeMed(dao, freq: FreqType.asNeeded);
      expect(await EventGenerator(dao).run(daysAhead: 7, now: now), 0);
    });

    test('weekly 仅命中指定星期', () async {
      await makeMed(dao, freq: FreqType.weekly, weekdays: [1, 3, 5]); // 一/三/五
      final n = await EventGenerator(dao).run(daysAhead: 7, now: now);
      final events = await dao.eventsInRange('2030-01-01', '2030-01-07');
      expect(n, 3); // 01-02 周三, 01-04 周五, 01-07 周一
      expect(events.length, 3);
      for (final e in events) {
        final wd = DateTime.parse(e.planDate).weekday;
        expect([1, 3, 5].contains(wd), isTrue);
      }
    });

    test('every_n_days 间隔命中', () async {
      await makeMed(
        dao,
        freq: FreqType.everyNDays,
        intervalDays: 2,
        start: DateTime(2030, 1, 1),
      );
      expect(await EventGenerator(dao).run(daysAhead: 7, now: now), 4); // 0,2,4,6
    });

    test('cycle 吃5停2', () async {
      await makeMed(
        dao,
        freq: FreqType.cycle,
        cycleOn: 5,
        cycleOff: 2,
        start: DateTime(2030, 1, 1),
      );
      expect(await EventGenerator(dao).run(daysAhead: 7, now: now), 5); // 前5天
    });

    test('多时间点生成多事件', () async {
      await makeMed(dao, freq: FreqType.daily, slots: const [
        PlanSlot(time: '08:00', dose: 1, unit: '片'),
        PlanSlot(time: '20:00', dose: 2, unit: '片'),
      ]);
      expect(await EventGenerator(dao).run(daysAhead: 3, now: now), 6); // 3天×2
    });
  });

  group('MissedMarker', () {
    test('超过确认窗口的 pending 判为漏服', () async {
      final medId = await makeMed(dao, freq: FreqType.daily);
      final yday = DateTime.now().subtract(const Duration(days: 1));
      final dateKey =
          '${yday.year.toString().padLeft(4, '0')}-${yday.month.toString().padLeft(2, '0')}-${yday.day.toString().padLeft(2, '0')}';
      await dao.insertEvents([
        IntakeEventsCompanion.insert(
          id: 'e-missed',
          medicationId: medId,
          scheduleId: 's1',
          planDate: dateKey,
          planTime: '08:00',
          planDose: 1,
          status: EventStatus.pending.code,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ]);
      final count = await MissedMarker(dao).run(confirmWindowHours: 4);
      expect(count, 1);
      final e = await dao.eventById('e-missed');
      expect(e!.status, EventStatus.missed.code);
    });

    test('未到窗口不判漏服', () async {
      final medId = await makeMed(dao, freq: FreqType.daily);
      final now = DateTime(2030, 1, 2, 12, 0);
      await dao.insertEvents([
        IntakeEventsCompanion.insert(
          id: 'e-ok',
          medicationId: medId,
          scheduleId: 's1',
          planDate: '2030-01-02',
          planTime: '09:00', // now-3h，未超 4h
          planDose: 1,
          status: EventStatus.pending.code,
          createdAt: now,
          updatedAt: now,
        ),
      ]);
      expect(await MissedMarker(dao).run(confirmWindowHours: 4, now: now), 0);
    });
  });

  group('StockService', () {
    test('扣减 / 回补 / 低库存', () async {
      final medId = await makeMed(
        dao,
        freq: FreqType.daily,
        stockEnabled: true,
        stock: 10,
        lowStockDays: 7,
      );
      final stock = StockService(dao);
      var med = (await dao.getMed(medId))!;
      await stock.deductOnTaken(med, 2);
      med = (await dao.getMed(medId))!;
      expect(med.stockRemaining, 8);
      await stock.restoreOnUndo(med, 2);
      med = (await dao.getMed(medId))!;
      expect(med.stockRemaining, 10);
      expect(stock.isLow(med, 5), isTrue); // 10/5=2 天 ≤ 7
    });
  });

  group('PlantService', () {
    test('连续全确认天数累计', () async {
      final medId = await makeMed(dao, freq: FreqType.daily);
      final today = DateTime(2030, 1, 3);
      for (var i = 1; i <= 3; i++) {
        final d = DateTime(2030, 1, i);
        final key =
            '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        await dao.insertEvents([
          IntakeEventsCompanion.insert(
            id: 'e$i',
            medicationId: medId,
            scheduleId: 's$i',
            planDate: key,
            planTime: '08:00',
            planDose: 1,
            status: EventStatus.taken.code,
            createdAt: d,
            updatedAt: d,
          ),
        ]);
      }
      expect(await PlantService(dao).currentStreak(today: today), 3);
    });
  });
}
