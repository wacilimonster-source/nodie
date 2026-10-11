import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:cyjl/data/database/tables.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/data/database/nutrient_seed.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Medications, Schedules, IntakeEvents, ProductIngredients, Nutrients],
  daos: [AppDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// 应用运行时构造（drift_flutter 自动管理路径与 sqlite 原生库）
  AppDatabase.connect() : super(_openConnection());

  static QueryExecutor _openConnection() => driftDatabase(name: 'cyjl.db');

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          // WAL + busy_timeout：允许「前台 UI」与「通知后台 isolate」并发读写
          await customStatement('PRAGMA journal_mode = WAL;');
          await customStatement('PRAGMA busy_timeout = 5000;');
          await _seedNutrients();
        },
      );

  /// 幂等种子：DRIs 2023 字典（随 App 版本更新，不逐版本迁移）
  Future<void> _seedNutrients() async {
    final existing = await select(nutrients).get();
    if (existing.isEmpty) {
      await batch((b) {
        b.insertAll(nutrients, NutrientSeed.all);
      });
    }
  }
}
