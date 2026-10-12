import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:cyjl/data/database/tables.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/database/nutrient_seed.dart';
import 'package:cyjl/data/database/preset_seed.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Medications,
    Schedules,
    IntakeEvents,
    ProductIngredients,
    Nutrients,
    ProductPresets,
    ProductPresetIngredients,
  ],
  daos: [AppDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// 应用运行时构造（drift_flutter 自动管理路径与 sqlite 原生库）
  AppDatabase.connect() : super(_openConnection());

  static QueryExecutor _openConnection() => driftDatabase(name: 'cyjl.db');

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(nutrients, nutrients.refLabel);
            await m.addColumn(nutrients, nutrients.altUnit);
            await m.addColumn(nutrients, nutrients.altFactor);
            await m.addColumn(nutrients, nutrients.note);
          }
          if (from < 3) {
            await m.createTable(productPresets);
            await m.createTable(productPresetIngredients);
            await m.addColumn(nutrients, nutrients.isBuiltin);
          }
        },
        beforeOpen: (details) async {
          // WAL + busy_timeout：允许「前台 UI」与「通知后台 isolate」并发读写
          await customStatement('PRAGMA journal_mode = WAL;');
          await customStatement('PRAGMA busy_timeout = 5000;');
          await _seedNutrients();
          await _seedPresets();
        },
      );

  /// 增量播种：按 code upsert。新增营养素随 App 升级自动补齐，不丢用户数据。
  Future<void> _seedNutrients() async {
    await batch((b) {
      b.insertAll(nutrients, NutrientSeed.all, mode: InsertMode.insertOrReplace);
    });
  }

  /// 增量播种内置配方模板（不动用户自建模板）
  Future<void> _seedPresets() async {
    await batch((b) {
      b.insertAll(productPresets, PresetSeed.presets, mode: InsertMode.insertOrReplace);
      b.insertAll(productPresetIngredients, PresetSeed.ingredients, mode: InsertMode.insertOrReplace);
    });
  }
}
