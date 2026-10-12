import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/database/nutrient_seed.dart';
import 'package:cyjl/data/database/preset_seed.dart';

void main() {
  test('内置 35 个配方且 id 唯一', () {
    expect(PresetSeed.presets.length, 35);
    final ids = PresetSeed.presets.map((p) => p.id).toList();
    expect(ids.toSet().length, ids.length);
    for (final p in PresetSeed.presets) {
      expect(p.isBuiltin, isTrue);
    }
  });

  test('配方成分引用的 nutrient code 都存在', () {
    final codes = NutrientSeed.all.map((n) => n.code).toSet();
    for (final i in PresetSeed.ingredients) {
      expect(codes.contains(i.nutrientCode), isTrue,
          reason: '配方 ${i.presetId} 引用了未知成分 ${i.nutrientCode}');
    }
  });

  test('DB 播种内置配方', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final dao = AppDao(db);
    final presets = await dao.watchPresets().first;
    expect(presets.length, PresetSeed.presets.length);
    final ings = await dao.presetIngredients('pre_multi_men');
    expect(ings, isNotEmpty);
    await db.close();
  });
}
