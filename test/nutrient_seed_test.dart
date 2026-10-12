import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/database/nutrient_seed.dart';

void main() {
  final all = NutrientSeed.all;

  test('包含鱼油 EPA/DHA 与关键新增营养素', () {
    final codes = all.map((n) => n.code).toSet();
    for (final c in [
      'vd', 'va', 've', 'vk', 'b1', 'b2', 'b3', 'b5', 'b6', 'b7', 'b9', 'b12', 'vc', 'choline',
      'ca', 'p', 'k', 'na', 'mg', 'fe', 'zn', 'i', 'se', 'cu', 'mn', 'mo', 'cr', 'f',
      'omg', 'epa', 'dha', 'ala',
      'lutein', 'zeaxanthin', 'lycopene', 'proantho', 'isoflavone', 'curcumin', 'resveratrol',
      'phytosterol', 'coq10', 'gaba', 'carnitine', 'glucosamine',
      'melatonin', 'collagen', 'chondroitin', 'probiotics', 'creatine', 'hyaluronic', 'nmn',
    ]) {
      expect(codes.contains(c), isTrue, reason: '缺少营养素 $c');
    }
  });

  test('维生素 D/A/E 提供 IU 换算', () {
    final vd = all.firstWhere((n) => n.code == 'vd');
    expect(vd.altUnit, 'IU');
    expect(vd.altFactor, 0.025); // 1 IU = 0.025 μg
    expect(all.firstWhere((n) => n.code == 'va').altFactor, 0.3);
    expect(all.firstWhere((n) => n.code == 've').altFactor, 0.67);
  });

  test('有 DRIs 的带参考文案；植物化学物/其他为仅记录', () {
    expect(all.firstWhere((n) => n.code == 'vd').refLabel, isNotNull);
    expect(all.firstWhere((n) => n.code == 'vk').refLabel, isNotNull);
    expect(all.firstWhere((n) => n.code == 'omg').refLabel, isNotNull);
    expect(all.firstWhere((n) => n.code == 'coq10').refLabel, isNull);
    expect(all.firstWhere((n) => n.code == 'melatonin').refLabel, isNull);
    expect(all.firstWhere((n) => n.code == 'epa').rniMale, 0); // 仅记录
  });

  test('无重复 code', () {
    final codes = all.map((n) => n.code).toList();
    expect(codes.toSet().length, codes.length);
  });

  test('DB 播种：字典行数与种子一致', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final dao = AppDao(db);
    final rows = await dao.allNutrients();
    expect(rows.length, all.length);
    await db.close();
  });
}
