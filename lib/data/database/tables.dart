import 'package:drift/drift.dart';

/// ============ 药品 / 保健品主表 ============
@DataClassName('MedicationRow')
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // medicine | supplement
  TextColumn get form => text().withDefault(const Constant('片剂'))();
  TextColumn get color => text().withDefault(const Constant('#5F8D4E'))();
  TextColumn get emoji => text().withDefault(const Constant('💊'))();
  TextColumn get instruction => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get stockEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get stockRemaining => real().nullable()();
  IntColumn get lowStockDays => integer().withDefault(const Constant(7))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ============ 服用计划表（与药分离，支持早晚不同剂量） ============
@DataClassName('ScheduleRow')
class Schedules extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text()();
  TextColumn get freqType => text()(); // daily/weekly/every_n_days/cycle/as_needed
  TextColumn get weekdays => text().nullable()(); // [1,3,5]
  IntColumn get intervalDays => integer().nullable()();
  IntColumn get cycleOn => integer().nullable()();
  IntColumn get cycleOff => integer().nullable()();
  TextColumn get times => text()(); // [{"time":"08:00","dose":1.0,"unit":"片"}]
  TextColumn get unit => text().withDefault(const Constant('片'))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ============ 服用事件表（每次该吃一条，四终态） ============
@DataClassName('IntakeEventRow')
class IntakeEvents extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text()();
  TextColumn get scheduleId => text()();
  TextColumn get planDate => text()(); // yyyy-MM-dd
  TextColumn get planTime => text()(); // HH:mm
  RealColumn get planDose => real()();
  TextColumn get status => text()(); // pending/taken/skipped/missed
  IntColumn get actualAt => integer().nullable()(); // epoch millis
  RealColumn get actualDose => real().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ============ 产品成分表（保健品，每单位含量） ============
@DataClassName('ProductIngredientRow')
class ProductIngredients extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text()();
  TextColumn get nutrientCode => text()(); // → Nutrients.code
  RealColumn get amountPerUnit => real()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ============ 营养素字典表（内置只读，DRIs 2023） ============
@DataClassName('NutrientRow')
class Nutrients extends Table {
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  TextColumn get category => text()(); // vitamin/mineral/fatty_acid/phyto/other
  RealColumn get rniMale => real()(); // 目标值（RNI 或 AI 或 SPL）；0 = 无参考（仅记录）
  RealColumn get rniFemale => real().nullable()();
  RealColumn get aiValue => real().nullable()(); // 适宜摄入量（无 RNI 时）
  RealColumn get ulValue => real().nullable()(); // 可耐受最高摄入量
  TextColumn get emoji => text().withDefault(const Constant('🟡'))();
  TextColumn get refLabel => text().nullable()(); // 参考类型说明：RNI推荐量/AI适宜量/SPL建议值；null=仅记录
  TextColumn get altUnit => text().nullable()(); // 可选输入单位（如 IU）
  RealColumn get altFactor => real().nullable()(); // 1 altUnit = altFactor × unit（内部统一为 unit）
  TextColumn get note => text().nullable()();
  BoolColumn get isBuiltin => boolean().withDefault(const Constant(true))(); // false = 用户自定义成分

  @override
  Set<Column<Object>> get primaryKey => {code};
}

/// ============ 保健品配方模板表（内置通用配方 + 用户自建） ============
@DataClassName('ProductPresetRow')
class ProductPresets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('basic'))(); // basic/bone/cardio/...
  TextColumn get form => text().withDefault(const Constant('片剂'))();
  TextColumn get emoji => text().withDefault(const Constant('💊'))();
  TextColumn get color => text().withDefault(const Constant('#7BA96A'))();
  TextColumn get unit => text().withDefault(const Constant('粒'))();
  TextColumn get serving => text().nullable()(); // 建议用法
  TextColumn get source => text().nullable()(); // 数据来源说明
  TextColumn get sourceDate => text().nullable()();
  BoolColumn get isBuiltin => boolean().withDefault(const Constant(true))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get sort => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ============ 配方成分表（每份含量） ============
@DataClassName('ProductPresetIngredientRow')
class ProductPresetIngredients extends Table {
  TextColumn get id => text()();
  TextColumn get presetId => text()();
  TextColumn get nutrientCode => text()();
  RealColumn get amountPerServing => real()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
