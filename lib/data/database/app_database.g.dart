// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, MedicationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
      'form', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('片剂'));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#5F8D4E'));
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('💊'));
  static const VerificationMeta _instructionMeta =
      const VerificationMeta('instruction');
  @override
  late final GeneratedColumn<String> instruction = GeneratedColumn<String>(
      'instruction', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stockEnabledMeta =
      const VerificationMeta('stockEnabled');
  @override
  late final GeneratedColumn<bool> stockEnabled = GeneratedColumn<bool>(
      'stock_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("stock_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _stockRemainingMeta =
      const VerificationMeta('stockRemaining');
  @override
  late final GeneratedColumn<double> stockRemaining = GeneratedColumn<double>(
      'stock_remaining', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lowStockDaysMeta =
      const VerificationMeta('lowStockDays');
  @override
  late final GeneratedColumn<int> lowStockDays = GeneratedColumn<int>(
      'low_stock_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(7));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        form,
        color,
        emoji,
        instruction,
        note,
        stockEnabled,
        stockRemaining,
        lowStockDays,
        isActive,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(Insertable<MedicationRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('form')) {
      context.handle(
          _formMeta, form.isAcceptableOrUnknown(data['form']!, _formMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    if (data.containsKey('instruction')) {
      context.handle(
          _instructionMeta,
          instruction.isAcceptableOrUnknown(
              data['instruction']!, _instructionMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('stock_enabled')) {
      context.handle(
          _stockEnabledMeta,
          stockEnabled.isAcceptableOrUnknown(
              data['stock_enabled']!, _stockEnabledMeta));
    }
    if (data.containsKey('stock_remaining')) {
      context.handle(
          _stockRemainingMeta,
          stockRemaining.isAcceptableOrUnknown(
              data['stock_remaining']!, _stockRemainingMeta));
    }
    if (data.containsKey('low_stock_days')) {
      context.handle(
          _lowStockDaysMeta,
          lowStockDays.isAcceptableOrUnknown(
              data['low_stock_days']!, _lowStockDaysMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      form: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      instruction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instruction']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      stockEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}stock_enabled'])!,
      stockRemaining: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_remaining']),
      lowStockDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}low_stock_days'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class MedicationRow extends DataClass implements Insertable<MedicationRow> {
  final String id;
  final String name;
  final String type;
  final String form;
  final String color;
  final String emoji;
  final String? instruction;
  final String? note;
  final bool stockEnabled;
  final double? stockRemaining;
  final int lowStockDays;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicationRow(
      {required this.id,
      required this.name,
      required this.type,
      required this.form,
      required this.color,
      required this.emoji,
      this.instruction,
      this.note,
      required this.stockEnabled,
      this.stockRemaining,
      required this.lowStockDays,
      required this.isActive,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['form'] = Variable<String>(form);
    map['color'] = Variable<String>(color);
    map['emoji'] = Variable<String>(emoji);
    if (!nullToAbsent || instruction != null) {
      map['instruction'] = Variable<String>(instruction);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['stock_enabled'] = Variable<bool>(stockEnabled);
    if (!nullToAbsent || stockRemaining != null) {
      map['stock_remaining'] = Variable<double>(stockRemaining);
    }
    map['low_stock_days'] = Variable<int>(lowStockDays);
    map['is_active'] = Variable<bool>(isActive);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      form: Value(form),
      color: Value(color),
      emoji: Value(emoji),
      instruction: instruction == null && nullToAbsent
          ? const Value.absent()
          : Value(instruction),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      stockEnabled: Value(stockEnabled),
      stockRemaining: stockRemaining == null && nullToAbsent
          ? const Value.absent()
          : Value(stockRemaining),
      lowStockDays: Value(lowStockDays),
      isActive: Value(isActive),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicationRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      form: serializer.fromJson<String>(json['form']),
      color: serializer.fromJson<String>(json['color']),
      emoji: serializer.fromJson<String>(json['emoji']),
      instruction: serializer.fromJson<String?>(json['instruction']),
      note: serializer.fromJson<String?>(json['note']),
      stockEnabled: serializer.fromJson<bool>(json['stockEnabled']),
      stockRemaining: serializer.fromJson<double?>(json['stockRemaining']),
      lowStockDays: serializer.fromJson<int>(json['lowStockDays']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'form': serializer.toJson<String>(form),
      'color': serializer.toJson<String>(color),
      'emoji': serializer.toJson<String>(emoji),
      'instruction': serializer.toJson<String?>(instruction),
      'note': serializer.toJson<String?>(note),
      'stockEnabled': serializer.toJson<bool>(stockEnabled),
      'stockRemaining': serializer.toJson<double?>(stockRemaining),
      'lowStockDays': serializer.toJson<int>(lowStockDays),
      'isActive': serializer.toJson<bool>(isActive),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicationRow copyWith(
          {String? id,
          String? name,
          String? type,
          String? form,
          String? color,
          String? emoji,
          Value<String?> instruction = const Value.absent(),
          Value<String?> note = const Value.absent(),
          bool? stockEnabled,
          Value<double?> stockRemaining = const Value.absent(),
          int? lowStockDays,
          bool? isActive,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MedicationRow(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        form: form ?? this.form,
        color: color ?? this.color,
        emoji: emoji ?? this.emoji,
        instruction: instruction.present ? instruction.value : this.instruction,
        note: note.present ? note.value : this.note,
        stockEnabled: stockEnabled ?? this.stockEnabled,
        stockRemaining:
            stockRemaining.present ? stockRemaining.value : this.stockRemaining,
        lowStockDays: lowStockDays ?? this.lowStockDays,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MedicationRow copyWithCompanion(MedicationsCompanion data) {
    return MedicationRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      form: data.form.present ? data.form.value : this.form,
      color: data.color.present ? data.color.value : this.color,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      instruction:
          data.instruction.present ? data.instruction.value : this.instruction,
      note: data.note.present ? data.note.value : this.note,
      stockEnabled: data.stockEnabled.present
          ? data.stockEnabled.value
          : this.stockEnabled,
      stockRemaining: data.stockRemaining.present
          ? data.stockRemaining.value
          : this.stockRemaining,
      lowStockDays: data.lowStockDays.present
          ? data.lowStockDays.value
          : this.lowStockDays,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('form: $form, ')
          ..write('color: $color, ')
          ..write('emoji: $emoji, ')
          ..write('instruction: $instruction, ')
          ..write('note: $note, ')
          ..write('stockEnabled: $stockEnabled, ')
          ..write('stockRemaining: $stockRemaining, ')
          ..write('lowStockDays: $lowStockDays, ')
          ..write('isActive: $isActive, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      type,
      form,
      color,
      emoji,
      instruction,
      note,
      stockEnabled,
      stockRemaining,
      lowStockDays,
      isActive,
      isDeleted,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.form == this.form &&
          other.color == this.color &&
          other.emoji == this.emoji &&
          other.instruction == this.instruction &&
          other.note == this.note &&
          other.stockEnabled == this.stockEnabled &&
          other.stockRemaining == this.stockRemaining &&
          other.lowStockDays == this.lowStockDays &&
          other.isActive == this.isActive &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicationsCompanion extends UpdateCompanion<MedicationRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> form;
  final Value<String> color;
  final Value<String> emoji;
  final Value<String?> instruction;
  final Value<String?> note;
  final Value<bool> stockEnabled;
  final Value<double?> stockRemaining;
  final Value<int> lowStockDays;
  final Value<bool> isActive;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.form = const Value.absent(),
    this.color = const Value.absent(),
    this.emoji = const Value.absent(),
    this.instruction = const Value.absent(),
    this.note = const Value.absent(),
    this.stockEnabled = const Value.absent(),
    this.stockRemaining = const Value.absent(),
    this.lowStockDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.form = const Value.absent(),
    this.color = const Value.absent(),
    this.emoji = const Value.absent(),
    this.instruction = const Value.absent(),
    this.note = const Value.absent(),
    this.stockEnabled = const Value.absent(),
    this.stockRemaining = const Value.absent(),
    this.lowStockDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MedicationRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? form,
    Expression<String>? color,
    Expression<String>? emoji,
    Expression<String>? instruction,
    Expression<String>? note,
    Expression<bool>? stockEnabled,
    Expression<double>? stockRemaining,
    Expression<int>? lowStockDays,
    Expression<bool>? isActive,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (form != null) 'form': form,
      if (color != null) 'color': color,
      if (emoji != null) 'emoji': emoji,
      if (instruction != null) 'instruction': instruction,
      if (note != null) 'note': note,
      if (stockEnabled != null) 'stock_enabled': stockEnabled,
      if (stockRemaining != null) 'stock_remaining': stockRemaining,
      if (lowStockDays != null) 'low_stock_days': lowStockDays,
      if (isActive != null) 'is_active': isActive,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? form,
      Value<String>? color,
      Value<String>? emoji,
      Value<String?>? instruction,
      Value<String?>? note,
      Value<bool>? stockEnabled,
      Value<double?>? stockRemaining,
      Value<int>? lowStockDays,
      Value<bool>? isActive,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      form: form ?? this.form,
      color: color ?? this.color,
      emoji: emoji ?? this.emoji,
      instruction: instruction ?? this.instruction,
      note: note ?? this.note,
      stockEnabled: stockEnabled ?? this.stockEnabled,
      stockRemaining: stockRemaining ?? this.stockRemaining,
      lowStockDays: lowStockDays ?? this.lowStockDays,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (instruction.present) {
      map['instruction'] = Variable<String>(instruction.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (stockEnabled.present) {
      map['stock_enabled'] = Variable<bool>(stockEnabled.value);
    }
    if (stockRemaining.present) {
      map['stock_remaining'] = Variable<double>(stockRemaining.value);
    }
    if (lowStockDays.present) {
      map['low_stock_days'] = Variable<int>(lowStockDays.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('form: $form, ')
          ..write('color: $color, ')
          ..write('emoji: $emoji, ')
          ..write('instruction: $instruction, ')
          ..write('note: $note, ')
          ..write('stockEnabled: $stockEnabled, ')
          ..write('stockRemaining: $stockRemaining, ')
          ..write('lowStockDays: $lowStockDays, ')
          ..write('isActive: $isActive, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchedulesTable extends Schedules
    with TableInfo<$SchedulesTable, ScheduleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _freqTypeMeta =
      const VerificationMeta('freqType');
  @override
  late final GeneratedColumn<String> freqType = GeneratedColumn<String>(
      'freq_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekdaysMeta =
      const VerificationMeta('weekdays');
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
      'weekdays', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cycleOnMeta =
      const VerificationMeta('cycleOn');
  @override
  late final GeneratedColumn<int> cycleOn = GeneratedColumn<int>(
      'cycle_on', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cycleOffMeta =
      const VerificationMeta('cycleOff');
  @override
  late final GeneratedColumn<int> cycleOff = GeneratedColumn<int>(
      'cycle_off', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timesMeta = const VerificationMeta('times');
  @override
  late final GeneratedColumn<String> times = GeneratedColumn<String>(
      'times', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('片'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicationId,
        freqType,
        weekdays,
        intervalDays,
        cycleOn,
        cycleOff,
        times,
        unit,
        startDate,
        endDate,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('freq_type')) {
      context.handle(_freqTypeMeta,
          freqType.isAcceptableOrUnknown(data['freq_type']!, _freqTypeMeta));
    } else if (isInserting) {
      context.missing(_freqTypeMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(_weekdaysMeta,
          weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('cycle_on')) {
      context.handle(_cycleOnMeta,
          cycleOn.isAcceptableOrUnknown(data['cycle_on']!, _cycleOnMeta));
    }
    if (data.containsKey('cycle_off')) {
      context.handle(_cycleOffMeta,
          cycleOff.isAcceptableOrUnknown(data['cycle_off']!, _cycleOffMeta));
    }
    if (data.containsKey('times')) {
      context.handle(
          _timesMeta, times.isAcceptableOrUnknown(data['times']!, _timesMeta));
    } else if (isInserting) {
      context.missing(_timesMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      freqType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}freq_type'])!,
      weekdays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekdays']),
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days']),
      cycleOn: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cycle_on']),
      cycleOff: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cycle_off']),
      times: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}times'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SchedulesTable createAlias(String alias) {
    return $SchedulesTable(attachedDatabase, alias);
  }
}

class ScheduleRow extends DataClass implements Insertable<ScheduleRow> {
  final String id;
  final String medicationId;
  final String freqType;
  final String? weekdays;
  final int? intervalDays;
  final int? cycleOn;
  final int? cycleOff;
  final String times;
  final String unit;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ScheduleRow(
      {required this.id,
      required this.medicationId,
      required this.freqType,
      this.weekdays,
      this.intervalDays,
      this.cycleOn,
      this.cycleOff,
      required this.times,
      required this.unit,
      required this.startDate,
      this.endDate,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['freq_type'] = Variable<String>(freqType);
    if (!nullToAbsent || weekdays != null) {
      map['weekdays'] = Variable<String>(weekdays);
    }
    if (!nullToAbsent || intervalDays != null) {
      map['interval_days'] = Variable<int>(intervalDays);
    }
    if (!nullToAbsent || cycleOn != null) {
      map['cycle_on'] = Variable<int>(cycleOn);
    }
    if (!nullToAbsent || cycleOff != null) {
      map['cycle_off'] = Variable<int>(cycleOff);
    }
    map['times'] = Variable<String>(times);
    map['unit'] = Variable<String>(unit);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      freqType: Value(freqType),
      weekdays: weekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdays),
      intervalDays: intervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalDays),
      cycleOn: cycleOn == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleOn),
      cycleOff: cycleOff == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleOff),
      times: Value(times),
      unit: Value(unit),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ScheduleRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      freqType: serializer.fromJson<String>(json['freqType']),
      weekdays: serializer.fromJson<String?>(json['weekdays']),
      intervalDays: serializer.fromJson<int?>(json['intervalDays']),
      cycleOn: serializer.fromJson<int?>(json['cycleOn']),
      cycleOff: serializer.fromJson<int?>(json['cycleOff']),
      times: serializer.fromJson<String>(json['times']),
      unit: serializer.fromJson<String>(json['unit']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'freqType': serializer.toJson<String>(freqType),
      'weekdays': serializer.toJson<String?>(weekdays),
      'intervalDays': serializer.toJson<int?>(intervalDays),
      'cycleOn': serializer.toJson<int?>(cycleOn),
      'cycleOff': serializer.toJson<int?>(cycleOff),
      'times': serializer.toJson<String>(times),
      'unit': serializer.toJson<String>(unit),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ScheduleRow copyWith(
          {String? id,
          String? medicationId,
          String? freqType,
          Value<String?> weekdays = const Value.absent(),
          Value<int?> intervalDays = const Value.absent(),
          Value<int?> cycleOn = const Value.absent(),
          Value<int?> cycleOff = const Value.absent(),
          String? times,
          String? unit,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ScheduleRow(
        id: id ?? this.id,
        medicationId: medicationId ?? this.medicationId,
        freqType: freqType ?? this.freqType,
        weekdays: weekdays.present ? weekdays.value : this.weekdays,
        intervalDays:
            intervalDays.present ? intervalDays.value : this.intervalDays,
        cycleOn: cycleOn.present ? cycleOn.value : this.cycleOn,
        cycleOff: cycleOff.present ? cycleOff.value : this.cycleOff,
        times: times ?? this.times,
        unit: unit ?? this.unit,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ScheduleRow copyWithCompanion(SchedulesCompanion data) {
    return ScheduleRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      freqType: data.freqType.present ? data.freqType.value : this.freqType,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      cycleOn: data.cycleOn.present ? data.cycleOn.value : this.cycleOn,
      cycleOff: data.cycleOff.present ? data.cycleOff.value : this.cycleOff,
      times: data.times.present ? data.times.value : this.times,
      unit: data.unit.present ? data.unit.value : this.unit,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('freqType: $freqType, ')
          ..write('weekdays: $weekdays, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('cycleOn: $cycleOn, ')
          ..write('cycleOff: $cycleOff, ')
          ..write('times: $times, ')
          ..write('unit: $unit, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      medicationId,
      freqType,
      weekdays,
      intervalDays,
      cycleOn,
      cycleOff,
      times,
      unit,
      startDate,
      endDate,
      isActive,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.freqType == this.freqType &&
          other.weekdays == this.weekdays &&
          other.intervalDays == this.intervalDays &&
          other.cycleOn == this.cycleOn &&
          other.cycleOff == this.cycleOff &&
          other.times == this.times &&
          other.unit == this.unit &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SchedulesCompanion extends UpdateCompanion<ScheduleRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> freqType;
  final Value<String?> weekdays;
  final Value<int?> intervalDays;
  final Value<int?> cycleOn;
  final Value<int?> cycleOff;
  final Value<String> times;
  final Value<String> unit;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SchedulesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.freqType = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.cycleOn = const Value.absent(),
    this.cycleOff = const Value.absent(),
    this.times = const Value.absent(),
    this.unit = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchedulesCompanion.insert({
    required String id,
    required String medicationId,
    required String freqType,
    this.weekdays = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.cycleOn = const Value.absent(),
    this.cycleOff = const Value.absent(),
    required String times,
    this.unit = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicationId = Value(medicationId),
        freqType = Value(freqType),
        times = Value(times),
        startDate = Value(startDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ScheduleRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? freqType,
    Expression<String>? weekdays,
    Expression<int>? intervalDays,
    Expression<int>? cycleOn,
    Expression<int>? cycleOff,
    Expression<String>? times,
    Expression<String>? unit,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (freqType != null) 'freq_type': freqType,
      if (weekdays != null) 'weekdays': weekdays,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (cycleOn != null) 'cycle_on': cycleOn,
      if (cycleOff != null) 'cycle_off': cycleOff,
      if (times != null) 'times': times,
      if (unit != null) 'unit': unit,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchedulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? medicationId,
      Value<String>? freqType,
      Value<String?>? weekdays,
      Value<int?>? intervalDays,
      Value<int?>? cycleOn,
      Value<int?>? cycleOff,
      Value<String>? times,
      Value<String>? unit,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SchedulesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      freqType: freqType ?? this.freqType,
      weekdays: weekdays ?? this.weekdays,
      intervalDays: intervalDays ?? this.intervalDays,
      cycleOn: cycleOn ?? this.cycleOn,
      cycleOff: cycleOff ?? this.cycleOff,
      times: times ?? this.times,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (freqType.present) {
      map['freq_type'] = Variable<String>(freqType.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (cycleOn.present) {
      map['cycle_on'] = Variable<int>(cycleOn.value);
    }
    if (cycleOff.present) {
      map['cycle_off'] = Variable<int>(cycleOff.value);
    }
    if (times.present) {
      map['times'] = Variable<String>(times.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('freqType: $freqType, ')
          ..write('weekdays: $weekdays, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('cycleOn: $cycleOn, ')
          ..write('cycleOff: $cycleOff, ')
          ..write('times: $times, ')
          ..write('unit: $unit, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntakeEventsTable extends IntakeEvents
    with TableInfo<$IntakeEventsTable, IntakeEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntakeEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
      'schedule_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planDateMeta =
      const VerificationMeta('planDate');
  @override
  late final GeneratedColumn<String> planDate = GeneratedColumn<String>(
      'plan_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planTimeMeta =
      const VerificationMeta('planTime');
  @override
  late final GeneratedColumn<String> planTime = GeneratedColumn<String>(
      'plan_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planDoseMeta =
      const VerificationMeta('planDose');
  @override
  late final GeneratedColumn<double> planDose = GeneratedColumn<double>(
      'plan_dose', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actualAtMeta =
      const VerificationMeta('actualAt');
  @override
  late final GeneratedColumn<int> actualAt = GeneratedColumn<int>(
      'actual_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _actualDoseMeta =
      const VerificationMeta('actualDose');
  @override
  late final GeneratedColumn<double> actualDose = GeneratedColumn<double>(
      'actual_dose', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicationId,
        scheduleId,
        planDate,
        planTime,
        planDose,
        status,
        actualAt,
        actualDose,
        note,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intake_events';
  @override
  VerificationContext validateIntegrity(Insertable<IntakeEventRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['schedule_id']!, _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('plan_date')) {
      context.handle(_planDateMeta,
          planDate.isAcceptableOrUnknown(data['plan_date']!, _planDateMeta));
    } else if (isInserting) {
      context.missing(_planDateMeta);
    }
    if (data.containsKey('plan_time')) {
      context.handle(_planTimeMeta,
          planTime.isAcceptableOrUnknown(data['plan_time']!, _planTimeMeta));
    } else if (isInserting) {
      context.missing(_planTimeMeta);
    }
    if (data.containsKey('plan_dose')) {
      context.handle(_planDoseMeta,
          planDose.isAcceptableOrUnknown(data['plan_dose']!, _planDoseMeta));
    } else if (isInserting) {
      context.missing(_planDoseMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('actual_at')) {
      context.handle(_actualAtMeta,
          actualAt.isAcceptableOrUnknown(data['actual_at']!, _actualAtMeta));
    }
    if (data.containsKey('actual_dose')) {
      context.handle(
          _actualDoseMeta,
          actualDose.isAcceptableOrUnknown(
              data['actual_dose']!, _actualDoseMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntakeEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntakeEventRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_id'])!,
      planDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_date'])!,
      planTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_time'])!,
      planDose: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}plan_dose'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      actualAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actual_at']),
      actualDose: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}actual_dose']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $IntakeEventsTable createAlias(String alias) {
    return $IntakeEventsTable(attachedDatabase, alias);
  }
}

class IntakeEventRow extends DataClass implements Insertable<IntakeEventRow> {
  final String id;
  final String medicationId;
  final String scheduleId;
  final String planDate;
  final String planTime;
  final double planDose;
  final String status;
  final int? actualAt;
  final double? actualDose;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IntakeEventRow(
      {required this.id,
      required this.medicationId,
      required this.scheduleId,
      required this.planDate,
      required this.planTime,
      required this.planDose,
      required this.status,
      this.actualAt,
      this.actualDose,
      this.note,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['plan_date'] = Variable<String>(planDate);
    map['plan_time'] = Variable<String>(planTime);
    map['plan_dose'] = Variable<double>(planDose);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || actualAt != null) {
      map['actual_at'] = Variable<int>(actualAt);
    }
    if (!nullToAbsent || actualDose != null) {
      map['actual_dose'] = Variable<double>(actualDose);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IntakeEventsCompanion toCompanion(bool nullToAbsent) {
    return IntakeEventsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      scheduleId: Value(scheduleId),
      planDate: Value(planDate),
      planTime: Value(planTime),
      planDose: Value(planDose),
      status: Value(status),
      actualAt: actualAt == null && nullToAbsent
          ? const Value.absent()
          : Value(actualAt),
      actualDose: actualDose == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDose),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IntakeEventRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntakeEventRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      planDate: serializer.fromJson<String>(json['planDate']),
      planTime: serializer.fromJson<String>(json['planTime']),
      planDose: serializer.fromJson<double>(json['planDose']),
      status: serializer.fromJson<String>(json['status']),
      actualAt: serializer.fromJson<int?>(json['actualAt']),
      actualDose: serializer.fromJson<double?>(json['actualDose']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'planDate': serializer.toJson<String>(planDate),
      'planTime': serializer.toJson<String>(planTime),
      'planDose': serializer.toJson<double>(planDose),
      'status': serializer.toJson<String>(status),
      'actualAt': serializer.toJson<int?>(actualAt),
      'actualDose': serializer.toJson<double?>(actualDose),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IntakeEventRow copyWith(
          {String? id,
          String? medicationId,
          String? scheduleId,
          String? planDate,
          String? planTime,
          double? planDose,
          String? status,
          Value<int?> actualAt = const Value.absent(),
          Value<double?> actualDose = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      IntakeEventRow(
        id: id ?? this.id,
        medicationId: medicationId ?? this.medicationId,
        scheduleId: scheduleId ?? this.scheduleId,
        planDate: planDate ?? this.planDate,
        planTime: planTime ?? this.planTime,
        planDose: planDose ?? this.planDose,
        status: status ?? this.status,
        actualAt: actualAt.present ? actualAt.value : this.actualAt,
        actualDose: actualDose.present ? actualDose.value : this.actualDose,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  IntakeEventRow copyWithCompanion(IntakeEventsCompanion data) {
    return IntakeEventRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
      planDate: data.planDate.present ? data.planDate.value : this.planDate,
      planTime: data.planTime.present ? data.planTime.value : this.planTime,
      planDose: data.planDose.present ? data.planDose.value : this.planDose,
      status: data.status.present ? data.status.value : this.status,
      actualAt: data.actualAt.present ? data.actualAt.value : this.actualAt,
      actualDose:
          data.actualDose.present ? data.actualDose.value : this.actualDose,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntakeEventRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('planDate: $planDate, ')
          ..write('planTime: $planTime, ')
          ..write('planDose: $planDose, ')
          ..write('status: $status, ')
          ..write('actualAt: $actualAt, ')
          ..write('actualDose: $actualDose, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      medicationId,
      scheduleId,
      planDate,
      planTime,
      planDose,
      status,
      actualAt,
      actualDose,
      note,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntakeEventRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.scheduleId == this.scheduleId &&
          other.planDate == this.planDate &&
          other.planTime == this.planTime &&
          other.planDose == this.planDose &&
          other.status == this.status &&
          other.actualAt == this.actualAt &&
          other.actualDose == this.actualDose &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IntakeEventsCompanion extends UpdateCompanion<IntakeEventRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> scheduleId;
  final Value<String> planDate;
  final Value<String> planTime;
  final Value<double> planDose;
  final Value<String> status;
  final Value<int?> actualAt;
  final Value<double?> actualDose;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const IntakeEventsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.planDate = const Value.absent(),
    this.planTime = const Value.absent(),
    this.planDose = const Value.absent(),
    this.status = const Value.absent(),
    this.actualAt = const Value.absent(),
    this.actualDose = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntakeEventsCompanion.insert({
    required String id,
    required String medicationId,
    required String scheduleId,
    required String planDate,
    required String planTime,
    required double planDose,
    required String status,
    this.actualAt = const Value.absent(),
    this.actualDose = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicationId = Value(medicationId),
        scheduleId = Value(scheduleId),
        planDate = Value(planDate),
        planTime = Value(planTime),
        planDose = Value(planDose),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<IntakeEventRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? scheduleId,
    Expression<String>? planDate,
    Expression<String>? planTime,
    Expression<double>? planDose,
    Expression<String>? status,
    Expression<int>? actualAt,
    Expression<double>? actualDose,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (planDate != null) 'plan_date': planDate,
      if (planTime != null) 'plan_time': planTime,
      if (planDose != null) 'plan_dose': planDose,
      if (status != null) 'status': status,
      if (actualAt != null) 'actual_at': actualAt,
      if (actualDose != null) 'actual_dose': actualDose,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntakeEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? medicationId,
      Value<String>? scheduleId,
      Value<String>? planDate,
      Value<String>? planTime,
      Value<double>? planDose,
      Value<String>? status,
      Value<int?>? actualAt,
      Value<double?>? actualDose,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return IntakeEventsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduleId: scheduleId ?? this.scheduleId,
      planDate: planDate ?? this.planDate,
      planTime: planTime ?? this.planTime,
      planDose: planDose ?? this.planDose,
      status: status ?? this.status,
      actualAt: actualAt ?? this.actualAt,
      actualDose: actualDose ?? this.actualDose,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (planDate.present) {
      map['plan_date'] = Variable<String>(planDate.value);
    }
    if (planTime.present) {
      map['plan_time'] = Variable<String>(planTime.value);
    }
    if (planDose.present) {
      map['plan_dose'] = Variable<double>(planDose.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (actualAt.present) {
      map['actual_at'] = Variable<int>(actualAt.value);
    }
    if (actualDose.present) {
      map['actual_dose'] = Variable<double>(actualDose.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntakeEventsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('planDate: $planDate, ')
          ..write('planTime: $planTime, ')
          ..write('planDose: $planDose, ')
          ..write('status: $status, ')
          ..write('actualAt: $actualAt, ')
          ..write('actualDose: $actualDose, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductIngredientsTable extends ProductIngredients
    with TableInfo<$ProductIngredientsTable, ProductIngredientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nutrientCodeMeta =
      const VerificationMeta('nutrientCode');
  @override
  late final GeneratedColumn<String> nutrientCode = GeneratedColumn<String>(
      'nutrient_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPerUnitMeta =
      const VerificationMeta('amountPerUnit');
  @override
  late final GeneratedColumn<double> amountPerUnit = GeneratedColumn<double>(
      'amount_per_unit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, medicationId, nutrientCode, amountPerUnit, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_ingredients';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductIngredientRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('nutrient_code')) {
      context.handle(
          _nutrientCodeMeta,
          nutrientCode.isAcceptableOrUnknown(
              data['nutrient_code']!, _nutrientCodeMeta));
    } else if (isInserting) {
      context.missing(_nutrientCodeMeta);
    }
    if (data.containsKey('amount_per_unit')) {
      context.handle(
          _amountPerUnitMeta,
          amountPerUnit.isAcceptableOrUnknown(
              data['amount_per_unit']!, _amountPerUnitMeta));
    } else if (isInserting) {
      context.missing(_amountPerUnitMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductIngredientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductIngredientRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      nutrientCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nutrient_code'])!,
      amountPerUnit: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}amount_per_unit'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProductIngredientsTable createAlias(String alias) {
    return $ProductIngredientsTable(attachedDatabase, alias);
  }
}

class ProductIngredientRow extends DataClass
    implements Insertable<ProductIngredientRow> {
  final String id;
  final String medicationId;
  final String nutrientCode;
  final double amountPerUnit;
  final DateTime createdAt;
  const ProductIngredientRow(
      {required this.id,
      required this.medicationId,
      required this.nutrientCode,
      required this.amountPerUnit,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['nutrient_code'] = Variable<String>(nutrientCode);
    map['amount_per_unit'] = Variable<double>(amountPerUnit);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductIngredientsCompanion toCompanion(bool nullToAbsent) {
    return ProductIngredientsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      nutrientCode: Value(nutrientCode),
      amountPerUnit: Value(amountPerUnit),
      createdAt: Value(createdAt),
    );
  }

  factory ProductIngredientRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductIngredientRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      nutrientCode: serializer.fromJson<String>(json['nutrientCode']),
      amountPerUnit: serializer.fromJson<double>(json['amountPerUnit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'nutrientCode': serializer.toJson<String>(nutrientCode),
      'amountPerUnit': serializer.toJson<double>(amountPerUnit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductIngredientRow copyWith(
          {String? id,
          String? medicationId,
          String? nutrientCode,
          double? amountPerUnit,
          DateTime? createdAt}) =>
      ProductIngredientRow(
        id: id ?? this.id,
        medicationId: medicationId ?? this.medicationId,
        nutrientCode: nutrientCode ?? this.nutrientCode,
        amountPerUnit: amountPerUnit ?? this.amountPerUnit,
        createdAt: createdAt ?? this.createdAt,
      );
  ProductIngredientRow copyWithCompanion(ProductIngredientsCompanion data) {
    return ProductIngredientRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      nutrientCode: data.nutrientCode.present
          ? data.nutrientCode.value
          : this.nutrientCode,
      amountPerUnit: data.amountPerUnit.present
          ? data.amountPerUnit.value
          : this.amountPerUnit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductIngredientRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('nutrientCode: $nutrientCode, ')
          ..write('amountPerUnit: $amountPerUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medicationId, nutrientCode, amountPerUnit, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductIngredientRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.nutrientCode == this.nutrientCode &&
          other.amountPerUnit == this.amountPerUnit &&
          other.createdAt == this.createdAt);
}

class ProductIngredientsCompanion
    extends UpdateCompanion<ProductIngredientRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> nutrientCode;
  final Value<double> amountPerUnit;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProductIngredientsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.nutrientCode = const Value.absent(),
    this.amountPerUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductIngredientsCompanion.insert({
    required String id,
    required String medicationId,
    required String nutrientCode,
    required double amountPerUnit,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicationId = Value(medicationId),
        nutrientCode = Value(nutrientCode),
        amountPerUnit = Value(amountPerUnit),
        createdAt = Value(createdAt);
  static Insertable<ProductIngredientRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? nutrientCode,
    Expression<double>? amountPerUnit,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (nutrientCode != null) 'nutrient_code': nutrientCode,
      if (amountPerUnit != null) 'amount_per_unit': amountPerUnit,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductIngredientsCompanion copyWith(
      {Value<String>? id,
      Value<String>? medicationId,
      Value<String>? nutrientCode,
      Value<double>? amountPerUnit,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ProductIngredientsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      nutrientCode: nutrientCode ?? this.nutrientCode,
      amountPerUnit: amountPerUnit ?? this.amountPerUnit,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (nutrientCode.present) {
      map['nutrient_code'] = Variable<String>(nutrientCode.value);
    }
    if (amountPerUnit.present) {
      map['amount_per_unit'] = Variable<double>(amountPerUnit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('nutrientCode: $nutrientCode, ')
          ..write('amountPerUnit: $amountPerUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutrientsTable extends Nutrients
    with TableInfo<$NutrientsTable, NutrientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutrientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rniMaleMeta =
      const VerificationMeta('rniMale');
  @override
  late final GeneratedColumn<double> rniMale = GeneratedColumn<double>(
      'rni_male', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _rniFemaleMeta =
      const VerificationMeta('rniFemale');
  @override
  late final GeneratedColumn<double> rniFemale = GeneratedColumn<double>(
      'rni_female', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _aiValueMeta =
      const VerificationMeta('aiValue');
  @override
  late final GeneratedColumn<double> aiValue = GeneratedColumn<double>(
      'ai_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ulValueMeta =
      const VerificationMeta('ulValue');
  @override
  late final GeneratedColumn<double> ulValue = GeneratedColumn<double>(
      'ul_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('🟡'));
  static const VerificationMeta _refLabelMeta =
      const VerificationMeta('refLabel');
  @override
  late final GeneratedColumn<String> refLabel = GeneratedColumn<String>(
      'ref_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _altUnitMeta =
      const VerificationMeta('altUnit');
  @override
  late final GeneratedColumn<String> altUnit = GeneratedColumn<String>(
      'alt_unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _altFactorMeta =
      const VerificationMeta('altFactor');
  @override
  late final GeneratedColumn<double> altFactor = GeneratedColumn<double>(
      'alt_factor', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isBuiltinMeta =
      const VerificationMeta('isBuiltin');
  @override
  late final GeneratedColumn<bool> isBuiltin = GeneratedColumn<bool>(
      'is_builtin', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_builtin" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        code,
        name,
        unit,
        category,
        rniMale,
        rniFemale,
        aiValue,
        ulValue,
        emoji,
        refLabel,
        altUnit,
        altFactor,
        note,
        isBuiltin
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrients';
  @override
  VerificationContext validateIntegrity(Insertable<NutrientRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('rni_male')) {
      context.handle(_rniMaleMeta,
          rniMale.isAcceptableOrUnknown(data['rni_male']!, _rniMaleMeta));
    } else if (isInserting) {
      context.missing(_rniMaleMeta);
    }
    if (data.containsKey('rni_female')) {
      context.handle(_rniFemaleMeta,
          rniFemale.isAcceptableOrUnknown(data['rni_female']!, _rniFemaleMeta));
    }
    if (data.containsKey('ai_value')) {
      context.handle(_aiValueMeta,
          aiValue.isAcceptableOrUnknown(data['ai_value']!, _aiValueMeta));
    }
    if (data.containsKey('ul_value')) {
      context.handle(_ulValueMeta,
          ulValue.isAcceptableOrUnknown(data['ul_value']!, _ulValueMeta));
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    if (data.containsKey('ref_label')) {
      context.handle(_refLabelMeta,
          refLabel.isAcceptableOrUnknown(data['ref_label']!, _refLabelMeta));
    }
    if (data.containsKey('alt_unit')) {
      context.handle(_altUnitMeta,
          altUnit.isAcceptableOrUnknown(data['alt_unit']!, _altUnitMeta));
    }
    if (data.containsKey('alt_factor')) {
      context.handle(_altFactorMeta,
          altFactor.isAcceptableOrUnknown(data['alt_factor']!, _altFactorMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_builtin')) {
      context.handle(_isBuiltinMeta,
          isBuiltin.isAcceptableOrUnknown(data['is_builtin']!, _isBuiltinMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  NutrientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutrientRow(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      rniMale: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rni_male'])!,
      rniFemale: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rni_female']),
      aiValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ai_value']),
      ulValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ul_value']),
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      refLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_label']),
      altUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alt_unit']),
      altFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}alt_factor']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      isBuiltin: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_builtin'])!,
    );
  }

  @override
  $NutrientsTable createAlias(String alias) {
    return $NutrientsTable(attachedDatabase, alias);
  }
}

class NutrientRow extends DataClass implements Insertable<NutrientRow> {
  final String code;
  final String name;
  final String unit;
  final String category;
  final double rniMale;
  final double? rniFemale;
  final double? aiValue;
  final double? ulValue;
  final String emoji;
  final String? refLabel;
  final String? altUnit;
  final double? altFactor;
  final String? note;
  final bool isBuiltin;
  const NutrientRow(
      {required this.code,
      required this.name,
      required this.unit,
      required this.category,
      required this.rniMale,
      this.rniFemale,
      this.aiValue,
      this.ulValue,
      required this.emoji,
      this.refLabel,
      this.altUnit,
      this.altFactor,
      this.note,
      required this.isBuiltin});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['category'] = Variable<String>(category);
    map['rni_male'] = Variable<double>(rniMale);
    if (!nullToAbsent || rniFemale != null) {
      map['rni_female'] = Variable<double>(rniFemale);
    }
    if (!nullToAbsent || aiValue != null) {
      map['ai_value'] = Variable<double>(aiValue);
    }
    if (!nullToAbsent || ulValue != null) {
      map['ul_value'] = Variable<double>(ulValue);
    }
    map['emoji'] = Variable<String>(emoji);
    if (!nullToAbsent || refLabel != null) {
      map['ref_label'] = Variable<String>(refLabel);
    }
    if (!nullToAbsent || altUnit != null) {
      map['alt_unit'] = Variable<String>(altUnit);
    }
    if (!nullToAbsent || altFactor != null) {
      map['alt_factor'] = Variable<double>(altFactor);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_builtin'] = Variable<bool>(isBuiltin);
    return map;
  }

  NutrientsCompanion toCompanion(bool nullToAbsent) {
    return NutrientsCompanion(
      code: Value(code),
      name: Value(name),
      unit: Value(unit),
      category: Value(category),
      rniMale: Value(rniMale),
      rniFemale: rniFemale == null && nullToAbsent
          ? const Value.absent()
          : Value(rniFemale),
      aiValue: aiValue == null && nullToAbsent
          ? const Value.absent()
          : Value(aiValue),
      ulValue: ulValue == null && nullToAbsent
          ? const Value.absent()
          : Value(ulValue),
      emoji: Value(emoji),
      refLabel: refLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(refLabel),
      altUnit: altUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(altUnit),
      altFactor: altFactor == null && nullToAbsent
          ? const Value.absent()
          : Value(altFactor),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isBuiltin: Value(isBuiltin),
    );
  }

  factory NutrientRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutrientRow(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String>(json['category']),
      rniMale: serializer.fromJson<double>(json['rniMale']),
      rniFemale: serializer.fromJson<double?>(json['rniFemale']),
      aiValue: serializer.fromJson<double?>(json['aiValue']),
      ulValue: serializer.fromJson<double?>(json['ulValue']),
      emoji: serializer.fromJson<String>(json['emoji']),
      refLabel: serializer.fromJson<String?>(json['refLabel']),
      altUnit: serializer.fromJson<String?>(json['altUnit']),
      altFactor: serializer.fromJson<double?>(json['altFactor']),
      note: serializer.fromJson<String?>(json['note']),
      isBuiltin: serializer.fromJson<bool>(json['isBuiltin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String>(category),
      'rniMale': serializer.toJson<double>(rniMale),
      'rniFemale': serializer.toJson<double?>(rniFemale),
      'aiValue': serializer.toJson<double?>(aiValue),
      'ulValue': serializer.toJson<double?>(ulValue),
      'emoji': serializer.toJson<String>(emoji),
      'refLabel': serializer.toJson<String?>(refLabel),
      'altUnit': serializer.toJson<String?>(altUnit),
      'altFactor': serializer.toJson<double?>(altFactor),
      'note': serializer.toJson<String?>(note),
      'isBuiltin': serializer.toJson<bool>(isBuiltin),
    };
  }

  NutrientRow copyWith(
          {String? code,
          String? name,
          String? unit,
          String? category,
          double? rniMale,
          Value<double?> rniFemale = const Value.absent(),
          Value<double?> aiValue = const Value.absent(),
          Value<double?> ulValue = const Value.absent(),
          String? emoji,
          Value<String?> refLabel = const Value.absent(),
          Value<String?> altUnit = const Value.absent(),
          Value<double?> altFactor = const Value.absent(),
          Value<String?> note = const Value.absent(),
          bool? isBuiltin}) =>
      NutrientRow(
        code: code ?? this.code,
        name: name ?? this.name,
        unit: unit ?? this.unit,
        category: category ?? this.category,
        rniMale: rniMale ?? this.rniMale,
        rniFemale: rniFemale.present ? rniFemale.value : this.rniFemale,
        aiValue: aiValue.present ? aiValue.value : this.aiValue,
        ulValue: ulValue.present ? ulValue.value : this.ulValue,
        emoji: emoji ?? this.emoji,
        refLabel: refLabel.present ? refLabel.value : this.refLabel,
        altUnit: altUnit.present ? altUnit.value : this.altUnit,
        altFactor: altFactor.present ? altFactor.value : this.altFactor,
        note: note.present ? note.value : this.note,
        isBuiltin: isBuiltin ?? this.isBuiltin,
      );
  NutrientRow copyWithCompanion(NutrientsCompanion data) {
    return NutrientRow(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      category: data.category.present ? data.category.value : this.category,
      rniMale: data.rniMale.present ? data.rniMale.value : this.rniMale,
      rniFemale: data.rniFemale.present ? data.rniFemale.value : this.rniFemale,
      aiValue: data.aiValue.present ? data.aiValue.value : this.aiValue,
      ulValue: data.ulValue.present ? data.ulValue.value : this.ulValue,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      refLabel: data.refLabel.present ? data.refLabel.value : this.refLabel,
      altUnit: data.altUnit.present ? data.altUnit.value : this.altUnit,
      altFactor: data.altFactor.present ? data.altFactor.value : this.altFactor,
      note: data.note.present ? data.note.value : this.note,
      isBuiltin: data.isBuiltin.present ? data.isBuiltin.value : this.isBuiltin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutrientRow(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('rniMale: $rniMale, ')
          ..write('rniFemale: $rniFemale, ')
          ..write('aiValue: $aiValue, ')
          ..write('ulValue: $ulValue, ')
          ..write('emoji: $emoji, ')
          ..write('refLabel: $refLabel, ')
          ..write('altUnit: $altUnit, ')
          ..write('altFactor: $altFactor, ')
          ..write('note: $note, ')
          ..write('isBuiltin: $isBuiltin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      code,
      name,
      unit,
      category,
      rniMale,
      rniFemale,
      aiValue,
      ulValue,
      emoji,
      refLabel,
      altUnit,
      altFactor,
      note,
      isBuiltin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutrientRow &&
          other.code == this.code &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.category == this.category &&
          other.rniMale == this.rniMale &&
          other.rniFemale == this.rniFemale &&
          other.aiValue == this.aiValue &&
          other.ulValue == this.ulValue &&
          other.emoji == this.emoji &&
          other.refLabel == this.refLabel &&
          other.altUnit == this.altUnit &&
          other.altFactor == this.altFactor &&
          other.note == this.note &&
          other.isBuiltin == this.isBuiltin);
}

class NutrientsCompanion extends UpdateCompanion<NutrientRow> {
  final Value<String> code;
  final Value<String> name;
  final Value<String> unit;
  final Value<String> category;
  final Value<double> rniMale;
  final Value<double?> rniFemale;
  final Value<double?> aiValue;
  final Value<double?> ulValue;
  final Value<String> emoji;
  final Value<String?> refLabel;
  final Value<String?> altUnit;
  final Value<double?> altFactor;
  final Value<String?> note;
  final Value<bool> isBuiltin;
  final Value<int> rowid;
  const NutrientsCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
    this.rniMale = const Value.absent(),
    this.rniFemale = const Value.absent(),
    this.aiValue = const Value.absent(),
    this.ulValue = const Value.absent(),
    this.emoji = const Value.absent(),
    this.refLabel = const Value.absent(),
    this.altUnit = const Value.absent(),
    this.altFactor = const Value.absent(),
    this.note = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutrientsCompanion.insert({
    required String code,
    required String name,
    required String unit,
    required String category,
    required double rniMale,
    this.rniFemale = const Value.absent(),
    this.aiValue = const Value.absent(),
    this.ulValue = const Value.absent(),
    this.emoji = const Value.absent(),
    this.refLabel = const Value.absent(),
    this.altUnit = const Value.absent(),
    this.altFactor = const Value.absent(),
    this.note = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        unit = Value(unit),
        category = Value(category),
        rniMale = Value(rniMale);
  static Insertable<NutrientRow> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<String>? category,
    Expression<double>? rniMale,
    Expression<double>? rniFemale,
    Expression<double>? aiValue,
    Expression<double>? ulValue,
    Expression<String>? emoji,
    Expression<String>? refLabel,
    Expression<String>? altUnit,
    Expression<double>? altFactor,
    Expression<String>? note,
    Expression<bool>? isBuiltin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (rniMale != null) 'rni_male': rniMale,
      if (rniFemale != null) 'rni_female': rniFemale,
      if (aiValue != null) 'ai_value': aiValue,
      if (ulValue != null) 'ul_value': ulValue,
      if (emoji != null) 'emoji': emoji,
      if (refLabel != null) 'ref_label': refLabel,
      if (altUnit != null) 'alt_unit': altUnit,
      if (altFactor != null) 'alt_factor': altFactor,
      if (note != null) 'note': note,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutrientsCompanion copyWith(
      {Value<String>? code,
      Value<String>? name,
      Value<String>? unit,
      Value<String>? category,
      Value<double>? rniMale,
      Value<double?>? rniFemale,
      Value<double?>? aiValue,
      Value<double?>? ulValue,
      Value<String>? emoji,
      Value<String?>? refLabel,
      Value<String?>? altUnit,
      Value<double?>? altFactor,
      Value<String?>? note,
      Value<bool>? isBuiltin,
      Value<int>? rowid}) {
    return NutrientsCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      rniMale: rniMale ?? this.rniMale,
      rniFemale: rniFemale ?? this.rniFemale,
      aiValue: aiValue ?? this.aiValue,
      ulValue: ulValue ?? this.ulValue,
      emoji: emoji ?? this.emoji,
      refLabel: refLabel ?? this.refLabel,
      altUnit: altUnit ?? this.altUnit,
      altFactor: altFactor ?? this.altFactor,
      note: note ?? this.note,
      isBuiltin: isBuiltin ?? this.isBuiltin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (rniMale.present) {
      map['rni_male'] = Variable<double>(rniMale.value);
    }
    if (rniFemale.present) {
      map['rni_female'] = Variable<double>(rniFemale.value);
    }
    if (aiValue.present) {
      map['ai_value'] = Variable<double>(aiValue.value);
    }
    if (ulValue.present) {
      map['ul_value'] = Variable<double>(ulValue.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (refLabel.present) {
      map['ref_label'] = Variable<String>(refLabel.value);
    }
    if (altUnit.present) {
      map['alt_unit'] = Variable<String>(altUnit.value);
    }
    if (altFactor.present) {
      map['alt_factor'] = Variable<double>(altFactor.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isBuiltin.present) {
      map['is_builtin'] = Variable<bool>(isBuiltin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutrientsCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('rniMale: $rniMale, ')
          ..write('rniFemale: $rniFemale, ')
          ..write('aiValue: $aiValue, ')
          ..write('ulValue: $ulValue, ')
          ..write('emoji: $emoji, ')
          ..write('refLabel: $refLabel, ')
          ..write('altUnit: $altUnit, ')
          ..write('altFactor: $altFactor, ')
          ..write('note: $note, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductPresetsTable extends ProductPresets
    with TableInfo<$ProductPresetsTable, ProductPresetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('basic'));
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
      'form', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('片剂'));
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('💊'));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#7BA96A'));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('粒'));
  static const VerificationMeta _servingMeta =
      const VerificationMeta('serving');
  @override
  late final GeneratedColumn<String> serving = GeneratedColumn<String>(
      'serving', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceDateMeta =
      const VerificationMeta('sourceDate');
  @override
  late final GeneratedColumn<String> sourceDate = GeneratedColumn<String>(
      'source_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isBuiltinMeta =
      const VerificationMeta('isBuiltin');
  @override
  late final GeneratedColumn<bool> isBuiltin = GeneratedColumn<bool>(
      'is_builtin', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_builtin" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<int> sort = GeneratedColumn<int>(
      'sort', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        brand,
        category,
        form,
        emoji,
        color,
        unit,
        serving,
        source,
        sourceDate,
        isBuiltin,
        isFavorite,
        sort,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_presets';
  @override
  VerificationContext validateIntegrity(Insertable<ProductPresetRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('form')) {
      context.handle(
          _formMeta, form.isAcceptableOrUnknown(data['form']!, _formMeta));
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('serving')) {
      context.handle(_servingMeta,
          serving.isAcceptableOrUnknown(data['serving']!, _servingMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('source_date')) {
      context.handle(
          _sourceDateMeta,
          sourceDate.isAcceptableOrUnknown(
              data['source_date']!, _sourceDateMeta));
    }
    if (data.containsKey('is_builtin')) {
      context.handle(_isBuiltinMeta,
          isBuiltin.isAcceptableOrUnknown(data['is_builtin']!, _isBuiltinMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('sort')) {
      context.handle(
          _sortMeta, sort.isAcceptableOrUnknown(data['sort']!, _sortMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductPresetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductPresetRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      form: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      serving: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serving']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      sourceDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_date']),
      isBuiltin: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_builtin'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      sort: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProductPresetsTable createAlias(String alias) {
    return $ProductPresetsTable(attachedDatabase, alias);
  }
}

class ProductPresetRow extends DataClass
    implements Insertable<ProductPresetRow> {
  final String id;
  final String name;
  final String? brand;
  final String category;
  final String form;
  final String emoji;
  final String color;
  final String unit;
  final String? serving;
  final String? source;
  final String? sourceDate;
  final bool isBuiltin;
  final bool isFavorite;
  final int sort;
  final DateTime updatedAt;
  const ProductPresetRow(
      {required this.id,
      required this.name,
      this.brand,
      required this.category,
      required this.form,
      required this.emoji,
      required this.color,
      required this.unit,
      this.serving,
      this.source,
      this.sourceDate,
      required this.isBuiltin,
      required this.isFavorite,
      required this.sort,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['category'] = Variable<String>(category);
    map['form'] = Variable<String>(form);
    map['emoji'] = Variable<String>(emoji);
    map['color'] = Variable<String>(color);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || serving != null) {
      map['serving'] = Variable<String>(serving);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || sourceDate != null) {
      map['source_date'] = Variable<String>(sourceDate);
    }
    map['is_builtin'] = Variable<bool>(isBuiltin);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['sort'] = Variable<int>(sort);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductPresetsCompanion toCompanion(bool nullToAbsent) {
    return ProductPresetsCompanion(
      id: Value(id),
      name: Value(name),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      category: Value(category),
      form: Value(form),
      emoji: Value(emoji),
      color: Value(color),
      unit: Value(unit),
      serving: serving == null && nullToAbsent
          ? const Value.absent()
          : Value(serving),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      sourceDate: sourceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDate),
      isBuiltin: Value(isBuiltin),
      isFavorite: Value(isFavorite),
      sort: Value(sort),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductPresetRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPresetRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      category: serializer.fromJson<String>(json['category']),
      form: serializer.fromJson<String>(json['form']),
      emoji: serializer.fromJson<String>(json['emoji']),
      color: serializer.fromJson<String>(json['color']),
      unit: serializer.fromJson<String>(json['unit']),
      serving: serializer.fromJson<String?>(json['serving']),
      source: serializer.fromJson<String?>(json['source']),
      sourceDate: serializer.fromJson<String?>(json['sourceDate']),
      isBuiltin: serializer.fromJson<bool>(json['isBuiltin']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      sort: serializer.fromJson<int>(json['sort']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'category': serializer.toJson<String>(category),
      'form': serializer.toJson<String>(form),
      'emoji': serializer.toJson<String>(emoji),
      'color': serializer.toJson<String>(color),
      'unit': serializer.toJson<String>(unit),
      'serving': serializer.toJson<String?>(serving),
      'source': serializer.toJson<String?>(source),
      'sourceDate': serializer.toJson<String?>(sourceDate),
      'isBuiltin': serializer.toJson<bool>(isBuiltin),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'sort': serializer.toJson<int>(sort),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductPresetRow copyWith(
          {String? id,
          String? name,
          Value<String?> brand = const Value.absent(),
          String? category,
          String? form,
          String? emoji,
          String? color,
          String? unit,
          Value<String?> serving = const Value.absent(),
          Value<String?> source = const Value.absent(),
          Value<String?> sourceDate = const Value.absent(),
          bool? isBuiltin,
          bool? isFavorite,
          int? sort,
          DateTime? updatedAt}) =>
      ProductPresetRow(
        id: id ?? this.id,
        name: name ?? this.name,
        brand: brand.present ? brand.value : this.brand,
        category: category ?? this.category,
        form: form ?? this.form,
        emoji: emoji ?? this.emoji,
        color: color ?? this.color,
        unit: unit ?? this.unit,
        serving: serving.present ? serving.value : this.serving,
        source: source.present ? source.value : this.source,
        sourceDate: sourceDate.present ? sourceDate.value : this.sourceDate,
        isBuiltin: isBuiltin ?? this.isBuiltin,
        isFavorite: isFavorite ?? this.isFavorite,
        sort: sort ?? this.sort,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProductPresetRow copyWithCompanion(ProductPresetsCompanion data) {
    return ProductPresetRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      category: data.category.present ? data.category.value : this.category,
      form: data.form.present ? data.form.value : this.form,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      color: data.color.present ? data.color.value : this.color,
      unit: data.unit.present ? data.unit.value : this.unit,
      serving: data.serving.present ? data.serving.value : this.serving,
      source: data.source.present ? data.source.value : this.source,
      sourceDate:
          data.sourceDate.present ? data.sourceDate.value : this.sourceDate,
      isBuiltin: data.isBuiltin.present ? data.isBuiltin.value : this.isBuiltin,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      sort: data.sort.present ? data.sort.value : this.sort,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductPresetRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('form: $form, ')
          ..write('emoji: $emoji, ')
          ..write('color: $color, ')
          ..write('unit: $unit, ')
          ..write('serving: $serving, ')
          ..write('source: $source, ')
          ..write('sourceDate: $sourceDate, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('sort: $sort, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      brand,
      category,
      form,
      emoji,
      color,
      unit,
      serving,
      source,
      sourceDate,
      isBuiltin,
      isFavorite,
      sort,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPresetRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.category == this.category &&
          other.form == this.form &&
          other.emoji == this.emoji &&
          other.color == this.color &&
          other.unit == this.unit &&
          other.serving == this.serving &&
          other.source == this.source &&
          other.sourceDate == this.sourceDate &&
          other.isBuiltin == this.isBuiltin &&
          other.isFavorite == this.isFavorite &&
          other.sort == this.sort &&
          other.updatedAt == this.updatedAt);
}

class ProductPresetsCompanion extends UpdateCompanion<ProductPresetRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String> category;
  final Value<String> form;
  final Value<String> emoji;
  final Value<String> color;
  final Value<String> unit;
  final Value<String?> serving;
  final Value<String?> source;
  final Value<String?> sourceDate;
  final Value<bool> isBuiltin;
  final Value<bool> isFavorite;
  final Value<int> sort;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductPresetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.form = const Value.absent(),
    this.emoji = const Value.absent(),
    this.color = const Value.absent(),
    this.unit = const Value.absent(),
    this.serving = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceDate = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.sort = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductPresetsCompanion.insert({
    required String id,
    required String name,
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.form = const Value.absent(),
    this.emoji = const Value.absent(),
    this.color = const Value.absent(),
    this.unit = const Value.absent(),
    this.serving = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceDate = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.sort = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        updatedAt = Value(updatedAt);
  static Insertable<ProductPresetRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<String>? form,
    Expression<String>? emoji,
    Expression<String>? color,
    Expression<String>? unit,
    Expression<String>? serving,
    Expression<String>? source,
    Expression<String>? sourceDate,
    Expression<bool>? isBuiltin,
    Expression<bool>? isFavorite,
    Expression<int>? sort,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (form != null) 'form': form,
      if (emoji != null) 'emoji': emoji,
      if (color != null) 'color': color,
      if (unit != null) 'unit': unit,
      if (serving != null) 'serving': serving,
      if (source != null) 'source': source,
      if (sourceDate != null) 'source_date': sourceDate,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (sort != null) 'sort': sort,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductPresetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? brand,
      Value<String>? category,
      Value<String>? form,
      Value<String>? emoji,
      Value<String>? color,
      Value<String>? unit,
      Value<String?>? serving,
      Value<String?>? source,
      Value<String?>? sourceDate,
      Value<bool>? isBuiltin,
      Value<bool>? isFavorite,
      Value<int>? sort,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ProductPresetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      form: form ?? this.form,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      unit: unit ?? this.unit,
      serving: serving ?? this.serving,
      source: source ?? this.source,
      sourceDate: sourceDate ?? this.sourceDate,
      isBuiltin: isBuiltin ?? this.isBuiltin,
      isFavorite: isFavorite ?? this.isFavorite,
      sort: sort ?? this.sort,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (serving.present) {
      map['serving'] = Variable<String>(serving.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceDate.present) {
      map['source_date'] = Variable<String>(sourceDate.value);
    }
    if (isBuiltin.present) {
      map['is_builtin'] = Variable<bool>(isBuiltin.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (sort.present) {
      map['sort'] = Variable<int>(sort.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPresetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('form: $form, ')
          ..write('emoji: $emoji, ')
          ..write('color: $color, ')
          ..write('unit: $unit, ')
          ..write('serving: $serving, ')
          ..write('source: $source, ')
          ..write('sourceDate: $sourceDate, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('sort: $sort, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductPresetIngredientsTable extends ProductPresetIngredients
    with TableInfo<$ProductPresetIngredientsTable, ProductPresetIngredientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPresetIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _presetIdMeta =
      const VerificationMeta('presetId');
  @override
  late final GeneratedColumn<String> presetId = GeneratedColumn<String>(
      'preset_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nutrientCodeMeta =
      const VerificationMeta('nutrientCode');
  @override
  late final GeneratedColumn<String> nutrientCode = GeneratedColumn<String>(
      'nutrient_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPerServingMeta =
      const VerificationMeta('amountPerServing');
  @override
  late final GeneratedColumn<double> amountPerServing = GeneratedColumn<double>(
      'amount_per_serving', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, presetId, nutrientCode, amountPerServing];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_preset_ingredients';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductPresetIngredientRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('preset_id')) {
      context.handle(_presetIdMeta,
          presetId.isAcceptableOrUnknown(data['preset_id']!, _presetIdMeta));
    } else if (isInserting) {
      context.missing(_presetIdMeta);
    }
    if (data.containsKey('nutrient_code')) {
      context.handle(
          _nutrientCodeMeta,
          nutrientCode.isAcceptableOrUnknown(
              data['nutrient_code']!, _nutrientCodeMeta));
    } else if (isInserting) {
      context.missing(_nutrientCodeMeta);
    }
    if (data.containsKey('amount_per_serving')) {
      context.handle(
          _amountPerServingMeta,
          amountPerServing.isAcceptableOrUnknown(
              data['amount_per_serving']!, _amountPerServingMeta));
    } else if (isInserting) {
      context.missing(_amountPerServingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductPresetIngredientRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductPresetIngredientRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      presetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preset_id'])!,
      nutrientCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nutrient_code'])!,
      amountPerServing: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}amount_per_serving'])!,
    );
  }

  @override
  $ProductPresetIngredientsTable createAlias(String alias) {
    return $ProductPresetIngredientsTable(attachedDatabase, alias);
  }
}

class ProductPresetIngredientRow extends DataClass
    implements Insertable<ProductPresetIngredientRow> {
  final String id;
  final String presetId;
  final String nutrientCode;
  final double amountPerServing;
  const ProductPresetIngredientRow(
      {required this.id,
      required this.presetId,
      required this.nutrientCode,
      required this.amountPerServing});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['preset_id'] = Variable<String>(presetId);
    map['nutrient_code'] = Variable<String>(nutrientCode);
    map['amount_per_serving'] = Variable<double>(amountPerServing);
    return map;
  }

  ProductPresetIngredientsCompanion toCompanion(bool nullToAbsent) {
    return ProductPresetIngredientsCompanion(
      id: Value(id),
      presetId: Value(presetId),
      nutrientCode: Value(nutrientCode),
      amountPerServing: Value(amountPerServing),
    );
  }

  factory ProductPresetIngredientRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPresetIngredientRow(
      id: serializer.fromJson<String>(json['id']),
      presetId: serializer.fromJson<String>(json['presetId']),
      nutrientCode: serializer.fromJson<String>(json['nutrientCode']),
      amountPerServing: serializer.fromJson<double>(json['amountPerServing']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'presetId': serializer.toJson<String>(presetId),
      'nutrientCode': serializer.toJson<String>(nutrientCode),
      'amountPerServing': serializer.toJson<double>(amountPerServing),
    };
  }

  ProductPresetIngredientRow copyWith(
          {String? id,
          String? presetId,
          String? nutrientCode,
          double? amountPerServing}) =>
      ProductPresetIngredientRow(
        id: id ?? this.id,
        presetId: presetId ?? this.presetId,
        nutrientCode: nutrientCode ?? this.nutrientCode,
        amountPerServing: amountPerServing ?? this.amountPerServing,
      );
  ProductPresetIngredientRow copyWithCompanion(
      ProductPresetIngredientsCompanion data) {
    return ProductPresetIngredientRow(
      id: data.id.present ? data.id.value : this.id,
      presetId: data.presetId.present ? data.presetId.value : this.presetId,
      nutrientCode: data.nutrientCode.present
          ? data.nutrientCode.value
          : this.nutrientCode,
      amountPerServing: data.amountPerServing.present
          ? data.amountPerServing.value
          : this.amountPerServing,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductPresetIngredientRow(')
          ..write('id: $id, ')
          ..write('presetId: $presetId, ')
          ..write('nutrientCode: $nutrientCode, ')
          ..write('amountPerServing: $amountPerServing')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, presetId, nutrientCode, amountPerServing);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPresetIngredientRow &&
          other.id == this.id &&
          other.presetId == this.presetId &&
          other.nutrientCode == this.nutrientCode &&
          other.amountPerServing == this.amountPerServing);
}

class ProductPresetIngredientsCompanion
    extends UpdateCompanion<ProductPresetIngredientRow> {
  final Value<String> id;
  final Value<String> presetId;
  final Value<String> nutrientCode;
  final Value<double> amountPerServing;
  final Value<int> rowid;
  const ProductPresetIngredientsCompanion({
    this.id = const Value.absent(),
    this.presetId = const Value.absent(),
    this.nutrientCode = const Value.absent(),
    this.amountPerServing = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductPresetIngredientsCompanion.insert({
    required String id,
    required String presetId,
    required String nutrientCode,
    required double amountPerServing,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        presetId = Value(presetId),
        nutrientCode = Value(nutrientCode),
        amountPerServing = Value(amountPerServing);
  static Insertable<ProductPresetIngredientRow> custom({
    Expression<String>? id,
    Expression<String>? presetId,
    Expression<String>? nutrientCode,
    Expression<double>? amountPerServing,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (presetId != null) 'preset_id': presetId,
      if (nutrientCode != null) 'nutrient_code': nutrientCode,
      if (amountPerServing != null) 'amount_per_serving': amountPerServing,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductPresetIngredientsCompanion copyWith(
      {Value<String>? id,
      Value<String>? presetId,
      Value<String>? nutrientCode,
      Value<double>? amountPerServing,
      Value<int>? rowid}) {
    return ProductPresetIngredientsCompanion(
      id: id ?? this.id,
      presetId: presetId ?? this.presetId,
      nutrientCode: nutrientCode ?? this.nutrientCode,
      amountPerServing: amountPerServing ?? this.amountPerServing,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (presetId.present) {
      map['preset_id'] = Variable<String>(presetId.value);
    }
    if (nutrientCode.present) {
      map['nutrient_code'] = Variable<String>(nutrientCode.value);
    }
    if (amountPerServing.present) {
      map['amount_per_serving'] = Variable<double>(amountPerServing.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPresetIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('presetId: $presetId, ')
          ..write('nutrientCode: $nutrientCode, ')
          ..write('amountPerServing: $amountPerServing, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $SchedulesTable schedules = $SchedulesTable(this);
  late final $IntakeEventsTable intakeEvents = $IntakeEventsTable(this);
  late final $ProductIngredientsTable productIngredients =
      $ProductIngredientsTable(this);
  late final $NutrientsTable nutrients = $NutrientsTable(this);
  late final $ProductPresetsTable productPresets = $ProductPresetsTable(this);
  late final $ProductPresetIngredientsTable productPresetIngredients =
      $ProductPresetIngredientsTable(this);
  late final AppDao appDao = AppDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        medications,
        schedules,
        intakeEvents,
        productIngredients,
        nutrients,
        productPresets,
        productPresetIngredients
      ];
}

typedef $$MedicationsTableCreateCompanionBuilder = MedicationsCompanion
    Function({
  required String id,
  required String name,
  required String type,
  Value<String> form,
  Value<String> color,
  Value<String> emoji,
  Value<String?> instruction,
  Value<String?> note,
  Value<bool> stockEnabled,
  Value<double?> stockRemaining,
  Value<int> lowStockDays,
  Value<bool> isActive,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MedicationsTableUpdateCompanionBuilder = MedicationsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> form,
  Value<String> color,
  Value<String> emoji,
  Value<String?> instruction,
  Value<String?> note,
  Value<bool> stockEnabled,
  Value<double?> stockRemaining,
  Value<int> lowStockDays,
  Value<bool> isActive,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MedicationsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get form => $state.composableBuilder(
      column: $state.table.form,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get emoji => $state.composableBuilder(
      column: $state.table.emoji,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get instruction => $state.composableBuilder(
      column: $state.table.instruction,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get stockEnabled => $state.composableBuilder(
      column: $state.table.stockEnabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stockRemaining => $state.composableBuilder(
      column: $state.table.stockRemaining,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lowStockDays => $state.composableBuilder(
      column: $state.table.lowStockDays,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$MedicationsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get form => $state.composableBuilder(
      column: $state.table.form,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get emoji => $state.composableBuilder(
      column: $state.table.emoji,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get instruction => $state.composableBuilder(
      column: $state.table.instruction,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get stockEnabled => $state.composableBuilder(
      column: $state.table.stockEnabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stockRemaining => $state.composableBuilder(
      column: $state.table.stockRemaining,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lowStockDays => $state.composableBuilder(
      column: $state.table.lowStockDays,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$MedicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationsTable,
    MedicationRow,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (
      MedicationRow,
      BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRow>
    ),
    MedicationRow,
    PrefetchHooks Function()> {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MedicationsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MedicationsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> form = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String?> instruction = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> stockEnabled = const Value.absent(),
            Value<double?> stockRemaining = const Value.absent(),
            Value<int> lowStockDays = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion(
            id: id,
            name: name,
            type: type,
            form: form,
            color: color,
            emoji: emoji,
            instruction: instruction,
            note: note,
            stockEnabled: stockEnabled,
            stockRemaining: stockRemaining,
            lowStockDays: lowStockDays,
            isActive: isActive,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            Value<String> form = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String?> instruction = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> stockEnabled = const Value.absent(),
            Value<double?> stockRemaining = const Value.absent(),
            Value<int> lowStockDays = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion.insert(
            id: id,
            name: name,
            type: type,
            form: form,
            color: color,
            emoji: emoji,
            instruction: instruction,
            note: note,
            stockEnabled: stockEnabled,
            stockRemaining: stockRemaining,
            lowStockDays: lowStockDays,
            isActive: isActive,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationsTable,
    MedicationRow,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (
      MedicationRow,
      BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRow>
    ),
    MedicationRow,
    PrefetchHooks Function()>;
typedef $$SchedulesTableCreateCompanionBuilder = SchedulesCompanion Function({
  required String id,
  required String medicationId,
  required String freqType,
  Value<String?> weekdays,
  Value<int?> intervalDays,
  Value<int?> cycleOn,
  Value<int?> cycleOff,
  required String times,
  Value<String> unit,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SchedulesTableUpdateCompanionBuilder = SchedulesCompanion Function({
  Value<String> id,
  Value<String> medicationId,
  Value<String> freqType,
  Value<String?> weekdays,
  Value<int?> intervalDays,
  Value<int?> cycleOn,
  Value<int?> cycleOff,
  Value<String> times,
  Value<String> unit,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SchedulesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get medicationId => $state.composableBuilder(
      column: $state.table.medicationId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get freqType => $state.composableBuilder(
      column: $state.table.freqType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get weekdays => $state.composableBuilder(
      column: $state.table.weekdays,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get intervalDays => $state.composableBuilder(
      column: $state.table.intervalDays,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get cycleOn => $state.composableBuilder(
      column: $state.table.cycleOn,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get cycleOff => $state.composableBuilder(
      column: $state.table.cycleOff,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get times => $state.composableBuilder(
      column: $state.table.times,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startDate => $state.composableBuilder(
      column: $state.table.startDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get endDate => $state.composableBuilder(
      column: $state.table.endDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SchedulesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get medicationId => $state.composableBuilder(
      column: $state.table.medicationId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get freqType => $state.composableBuilder(
      column: $state.table.freqType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get weekdays => $state.composableBuilder(
      column: $state.table.weekdays,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get intervalDays => $state.composableBuilder(
      column: $state.table.intervalDays,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get cycleOn => $state.composableBuilder(
      column: $state.table.cycleOn,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get cycleOff => $state.composableBuilder(
      column: $state.table.cycleOff,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get times => $state.composableBuilder(
      column: $state.table.times,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startDate => $state.composableBuilder(
      column: $state.table.startDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get endDate => $state.composableBuilder(
      column: $state.table.endDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$SchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SchedulesTable,
    ScheduleRow,
    $$SchedulesTableFilterComposer,
    $$SchedulesTableOrderingComposer,
    $$SchedulesTableCreateCompanionBuilder,
    $$SchedulesTableUpdateCompanionBuilder,
    (ScheduleRow, BaseReferences<_$AppDatabase, $SchedulesTable, ScheduleRow>),
    ScheduleRow,
    PrefetchHooks Function()> {
  $$SchedulesTableTableManager(_$AppDatabase db, $SchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SchedulesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SchedulesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<String> freqType = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<int?> intervalDays = const Value.absent(),
            Value<int?> cycleOn = const Value.absent(),
            Value<int?> cycleOff = const Value.absent(),
            Value<String> times = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SchedulesCompanion(
            id: id,
            medicationId: medicationId,
            freqType: freqType,
            weekdays: weekdays,
            intervalDays: intervalDays,
            cycleOn: cycleOn,
            cycleOff: cycleOff,
            times: times,
            unit: unit,
            startDate: startDate,
            endDate: endDate,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String medicationId,
            required String freqType,
            Value<String?> weekdays = const Value.absent(),
            Value<int?> intervalDays = const Value.absent(),
            Value<int?> cycleOn = const Value.absent(),
            Value<int?> cycleOff = const Value.absent(),
            required String times,
            Value<String> unit = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SchedulesCompanion.insert(
            id: id,
            medicationId: medicationId,
            freqType: freqType,
            weekdays: weekdays,
            intervalDays: intervalDays,
            cycleOn: cycleOn,
            cycleOff: cycleOff,
            times: times,
            unit: unit,
            startDate: startDate,
            endDate: endDate,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SchedulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SchedulesTable,
    ScheduleRow,
    $$SchedulesTableFilterComposer,
    $$SchedulesTableOrderingComposer,
    $$SchedulesTableCreateCompanionBuilder,
    $$SchedulesTableUpdateCompanionBuilder,
    (ScheduleRow, BaseReferences<_$AppDatabase, $SchedulesTable, ScheduleRow>),
    ScheduleRow,
    PrefetchHooks Function()>;
typedef $$IntakeEventsTableCreateCompanionBuilder = IntakeEventsCompanion
    Function({
  required String id,
  required String medicationId,
  required String scheduleId,
  required String planDate,
  required String planTime,
  required double planDose,
  required String status,
  Value<int?> actualAt,
  Value<double?> actualDose,
  Value<String?> note,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$IntakeEventsTableUpdateCompanionBuilder = IntakeEventsCompanion
    Function({
  Value<String> id,
  Value<String> medicationId,
  Value<String> scheduleId,
  Value<String> planDate,
  Value<String> planTime,
  Value<double> planDose,
  Value<String> status,
  Value<int?> actualAt,
  Value<double?> actualDose,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$IntakeEventsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $IntakeEventsTable> {
  $$IntakeEventsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get medicationId => $state.composableBuilder(
      column: $state.table.medicationId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get scheduleId => $state.composableBuilder(
      column: $state.table.scheduleId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get planDate => $state.composableBuilder(
      column: $state.table.planDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get planTime => $state.composableBuilder(
      column: $state.table.planTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get planDose => $state.composableBuilder(
      column: $state.table.planDose,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get actualAt => $state.composableBuilder(
      column: $state.table.actualAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get actualDose => $state.composableBuilder(
      column: $state.table.actualDose,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$IntakeEventsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $IntakeEventsTable> {
  $$IntakeEventsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get medicationId => $state.composableBuilder(
      column: $state.table.medicationId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get scheduleId => $state.composableBuilder(
      column: $state.table.scheduleId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get planDate => $state.composableBuilder(
      column: $state.table.planDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get planTime => $state.composableBuilder(
      column: $state.table.planTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get planDose => $state.composableBuilder(
      column: $state.table.planDose,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get actualAt => $state.composableBuilder(
      column: $state.table.actualAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get actualDose => $state.composableBuilder(
      column: $state.table.actualDose,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$IntakeEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IntakeEventsTable,
    IntakeEventRow,
    $$IntakeEventsTableFilterComposer,
    $$IntakeEventsTableOrderingComposer,
    $$IntakeEventsTableCreateCompanionBuilder,
    $$IntakeEventsTableUpdateCompanionBuilder,
    (
      IntakeEventRow,
      BaseReferences<_$AppDatabase, $IntakeEventsTable, IntakeEventRow>
    ),
    IntakeEventRow,
    PrefetchHooks Function()> {
  $$IntakeEventsTableTableManager(_$AppDatabase db, $IntakeEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$IntakeEventsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$IntakeEventsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<String> scheduleId = const Value.absent(),
            Value<String> planDate = const Value.absent(),
            Value<String> planTime = const Value.absent(),
            Value<double> planDose = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> actualAt = const Value.absent(),
            Value<double?> actualDose = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IntakeEventsCompanion(
            id: id,
            medicationId: medicationId,
            scheduleId: scheduleId,
            planDate: planDate,
            planTime: planTime,
            planDose: planDose,
            status: status,
            actualAt: actualAt,
            actualDose: actualDose,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String medicationId,
            required String scheduleId,
            required String planDate,
            required String planTime,
            required double planDose,
            required String status,
            Value<int?> actualAt = const Value.absent(),
            Value<double?> actualDose = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              IntakeEventsCompanion.insert(
            id: id,
            medicationId: medicationId,
            scheduleId: scheduleId,
            planDate: planDate,
            planTime: planTime,
            planDose: planDose,
            status: status,
            actualAt: actualAt,
            actualDose: actualDose,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IntakeEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IntakeEventsTable,
    IntakeEventRow,
    $$IntakeEventsTableFilterComposer,
    $$IntakeEventsTableOrderingComposer,
    $$IntakeEventsTableCreateCompanionBuilder,
    $$IntakeEventsTableUpdateCompanionBuilder,
    (
      IntakeEventRow,
      BaseReferences<_$AppDatabase, $IntakeEventsTable, IntakeEventRow>
    ),
    IntakeEventRow,
    PrefetchHooks Function()>;
typedef $$ProductIngredientsTableCreateCompanionBuilder
    = ProductIngredientsCompanion Function({
  required String id,
  required String medicationId,
  required String nutrientCode,
  required double amountPerUnit,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ProductIngredientsTableUpdateCompanionBuilder
    = ProductIngredientsCompanion Function({
  Value<String> id,
  Value<String> medicationId,
  Value<String> nutrientCode,
  Value<double> amountPerUnit,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ProductIngredientsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductIngredientsTable> {
  $$ProductIngredientsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get medicationId => $state.composableBuilder(
      column: $state.table.medicationId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nutrientCode => $state.composableBuilder(
      column: $state.table.nutrientCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amountPerUnit => $state.composableBuilder(
      column: $state.table.amountPerUnit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ProductIngredientsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductIngredientsTable> {
  $$ProductIngredientsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get medicationId => $state.composableBuilder(
      column: $state.table.medicationId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nutrientCode => $state.composableBuilder(
      column: $state.table.nutrientCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amountPerUnit => $state.composableBuilder(
      column: $state.table.amountPerUnit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$ProductIngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductIngredientsTable,
    ProductIngredientRow,
    $$ProductIngredientsTableFilterComposer,
    $$ProductIngredientsTableOrderingComposer,
    $$ProductIngredientsTableCreateCompanionBuilder,
    $$ProductIngredientsTableUpdateCompanionBuilder,
    (
      ProductIngredientRow,
      BaseReferences<_$AppDatabase, $ProductIngredientsTable,
          ProductIngredientRow>
    ),
    ProductIngredientRow,
    PrefetchHooks Function()> {
  $$ProductIngredientsTableTableManager(
      _$AppDatabase db, $ProductIngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductIngredientsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$ProductIngredientsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<String> nutrientCode = const Value.absent(),
            Value<double> amountPerUnit = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductIngredientsCompanion(
            id: id,
            medicationId: medicationId,
            nutrientCode: nutrientCode,
            amountPerUnit: amountPerUnit,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String medicationId,
            required String nutrientCode,
            required double amountPerUnit,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductIngredientsCompanion.insert(
            id: id,
            medicationId: medicationId,
            nutrientCode: nutrientCode,
            amountPerUnit: amountPerUnit,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductIngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductIngredientsTable,
    ProductIngredientRow,
    $$ProductIngredientsTableFilterComposer,
    $$ProductIngredientsTableOrderingComposer,
    $$ProductIngredientsTableCreateCompanionBuilder,
    $$ProductIngredientsTableUpdateCompanionBuilder,
    (
      ProductIngredientRow,
      BaseReferences<_$AppDatabase, $ProductIngredientsTable,
          ProductIngredientRow>
    ),
    ProductIngredientRow,
    PrefetchHooks Function()>;
typedef $$NutrientsTableCreateCompanionBuilder = NutrientsCompanion Function({
  required String code,
  required String name,
  required String unit,
  required String category,
  required double rniMale,
  Value<double?> rniFemale,
  Value<double?> aiValue,
  Value<double?> ulValue,
  Value<String> emoji,
  Value<String?> refLabel,
  Value<String?> altUnit,
  Value<double?> altFactor,
  Value<String?> note,
  Value<bool> isBuiltin,
  Value<int> rowid,
});
typedef $$NutrientsTableUpdateCompanionBuilder = NutrientsCompanion Function({
  Value<String> code,
  Value<String> name,
  Value<String> unit,
  Value<String> category,
  Value<double> rniMale,
  Value<double?> rniFemale,
  Value<double?> aiValue,
  Value<double?> ulValue,
  Value<String> emoji,
  Value<String?> refLabel,
  Value<String?> altUnit,
  Value<double?> altFactor,
  Value<String?> note,
  Value<bool> isBuiltin,
  Value<int> rowid,
});

class $$NutrientsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableFilterComposer(super.$state);
  ColumnFilters<String> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get rniMale => $state.composableBuilder(
      column: $state.table.rniMale,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get rniFemale => $state.composableBuilder(
      column: $state.table.rniFemale,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get aiValue => $state.composableBuilder(
      column: $state.table.aiValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get ulValue => $state.composableBuilder(
      column: $state.table.ulValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get emoji => $state.composableBuilder(
      column: $state.table.emoji,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get refLabel => $state.composableBuilder(
      column: $state.table.refLabel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get altUnit => $state.composableBuilder(
      column: $state.table.altUnit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get altFactor => $state.composableBuilder(
      column: $state.table.altFactor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isBuiltin => $state.composableBuilder(
      column: $state.table.isBuiltin,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$NutrientsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get rniMale => $state.composableBuilder(
      column: $state.table.rniMale,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get rniFemale => $state.composableBuilder(
      column: $state.table.rniFemale,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get aiValue => $state.composableBuilder(
      column: $state.table.aiValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get ulValue => $state.composableBuilder(
      column: $state.table.ulValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get emoji => $state.composableBuilder(
      column: $state.table.emoji,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get refLabel => $state.composableBuilder(
      column: $state.table.refLabel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get altUnit => $state.composableBuilder(
      column: $state.table.altUnit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get altFactor => $state.composableBuilder(
      column: $state.table.altFactor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isBuiltin => $state.composableBuilder(
      column: $state.table.isBuiltin,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$NutrientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NutrientsTable,
    NutrientRow,
    $$NutrientsTableFilterComposer,
    $$NutrientsTableOrderingComposer,
    $$NutrientsTableCreateCompanionBuilder,
    $$NutrientsTableUpdateCompanionBuilder,
    (NutrientRow, BaseReferences<_$AppDatabase, $NutrientsTable, NutrientRow>),
    NutrientRow,
    PrefetchHooks Function()> {
  $$NutrientsTableTableManager(_$AppDatabase db, $NutrientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$NutrientsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$NutrientsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> rniMale = const Value.absent(),
            Value<double?> rniFemale = const Value.absent(),
            Value<double?> aiValue = const Value.absent(),
            Value<double?> ulValue = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String?> refLabel = const Value.absent(),
            Value<String?> altUnit = const Value.absent(),
            Value<double?> altFactor = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isBuiltin = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NutrientsCompanion(
            code: code,
            name: name,
            unit: unit,
            category: category,
            rniMale: rniMale,
            rniFemale: rniFemale,
            aiValue: aiValue,
            ulValue: ulValue,
            emoji: emoji,
            refLabel: refLabel,
            altUnit: altUnit,
            altFactor: altFactor,
            note: note,
            isBuiltin: isBuiltin,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String name,
            required String unit,
            required String category,
            required double rniMale,
            Value<double?> rniFemale = const Value.absent(),
            Value<double?> aiValue = const Value.absent(),
            Value<double?> ulValue = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String?> refLabel = const Value.absent(),
            Value<String?> altUnit = const Value.absent(),
            Value<double?> altFactor = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isBuiltin = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NutrientsCompanion.insert(
            code: code,
            name: name,
            unit: unit,
            category: category,
            rniMale: rniMale,
            rniFemale: rniFemale,
            aiValue: aiValue,
            ulValue: ulValue,
            emoji: emoji,
            refLabel: refLabel,
            altUnit: altUnit,
            altFactor: altFactor,
            note: note,
            isBuiltin: isBuiltin,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NutrientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NutrientsTable,
    NutrientRow,
    $$NutrientsTableFilterComposer,
    $$NutrientsTableOrderingComposer,
    $$NutrientsTableCreateCompanionBuilder,
    $$NutrientsTableUpdateCompanionBuilder,
    (NutrientRow, BaseReferences<_$AppDatabase, $NutrientsTable, NutrientRow>),
    NutrientRow,
    PrefetchHooks Function()>;
typedef $$ProductPresetsTableCreateCompanionBuilder = ProductPresetsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> brand,
  Value<String> category,
  Value<String> form,
  Value<String> emoji,
  Value<String> color,
  Value<String> unit,
  Value<String?> serving,
  Value<String?> source,
  Value<String?> sourceDate,
  Value<bool> isBuiltin,
  Value<bool> isFavorite,
  Value<int> sort,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ProductPresetsTableUpdateCompanionBuilder = ProductPresetsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> brand,
  Value<String> category,
  Value<String> form,
  Value<String> emoji,
  Value<String> color,
  Value<String> unit,
  Value<String?> serving,
  Value<String?> source,
  Value<String?> sourceDate,
  Value<bool> isBuiltin,
  Value<bool> isFavorite,
  Value<int> sort,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ProductPresetsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductPresetsTable> {
  $$ProductPresetsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get brand => $state.composableBuilder(
      column: $state.table.brand,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get form => $state.composableBuilder(
      column: $state.table.form,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get emoji => $state.composableBuilder(
      column: $state.table.emoji,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get serving => $state.composableBuilder(
      column: $state.table.serving,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sourceDate => $state.composableBuilder(
      column: $state.table.sourceDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isBuiltin => $state.composableBuilder(
      column: $state.table.isBuiltin,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sort => $state.composableBuilder(
      column: $state.table.sort,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ProductPresetsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductPresetsTable> {
  $$ProductPresetsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get brand => $state.composableBuilder(
      column: $state.table.brand,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get form => $state.composableBuilder(
      column: $state.table.form,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get emoji => $state.composableBuilder(
      column: $state.table.emoji,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get serving => $state.composableBuilder(
      column: $state.table.serving,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sourceDate => $state.composableBuilder(
      column: $state.table.sourceDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isBuiltin => $state.composableBuilder(
      column: $state.table.isBuiltin,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sort => $state.composableBuilder(
      column: $state.table.sort,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$ProductPresetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductPresetsTable,
    ProductPresetRow,
    $$ProductPresetsTableFilterComposer,
    $$ProductPresetsTableOrderingComposer,
    $$ProductPresetsTableCreateCompanionBuilder,
    $$ProductPresetsTableUpdateCompanionBuilder,
    (
      ProductPresetRow,
      BaseReferences<_$AppDatabase, $ProductPresetsTable, ProductPresetRow>
    ),
    ProductPresetRow,
    PrefetchHooks Function()> {
  $$ProductPresetsTableTableManager(
      _$AppDatabase db, $ProductPresetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductPresetsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProductPresetsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> form = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> serving = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> sourceDate = const Value.absent(),
            Value<bool> isBuiltin = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> sort = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductPresetsCompanion(
            id: id,
            name: name,
            brand: brand,
            category: category,
            form: form,
            emoji: emoji,
            color: color,
            unit: unit,
            serving: serving,
            source: source,
            sourceDate: sourceDate,
            isBuiltin: isBuiltin,
            isFavorite: isFavorite,
            sort: sort,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> brand = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> form = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> serving = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> sourceDate = const Value.absent(),
            Value<bool> isBuiltin = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> sort = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductPresetsCompanion.insert(
            id: id,
            name: name,
            brand: brand,
            category: category,
            form: form,
            emoji: emoji,
            color: color,
            unit: unit,
            serving: serving,
            source: source,
            sourceDate: sourceDate,
            isBuiltin: isBuiltin,
            isFavorite: isFavorite,
            sort: sort,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductPresetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductPresetsTable,
    ProductPresetRow,
    $$ProductPresetsTableFilterComposer,
    $$ProductPresetsTableOrderingComposer,
    $$ProductPresetsTableCreateCompanionBuilder,
    $$ProductPresetsTableUpdateCompanionBuilder,
    (
      ProductPresetRow,
      BaseReferences<_$AppDatabase, $ProductPresetsTable, ProductPresetRow>
    ),
    ProductPresetRow,
    PrefetchHooks Function()>;
typedef $$ProductPresetIngredientsTableCreateCompanionBuilder
    = ProductPresetIngredientsCompanion Function({
  required String id,
  required String presetId,
  required String nutrientCode,
  required double amountPerServing,
  Value<int> rowid,
});
typedef $$ProductPresetIngredientsTableUpdateCompanionBuilder
    = ProductPresetIngredientsCompanion Function({
  Value<String> id,
  Value<String> presetId,
  Value<String> nutrientCode,
  Value<double> amountPerServing,
  Value<int> rowid,
});

class $$ProductPresetIngredientsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductPresetIngredientsTable> {
  $$ProductPresetIngredientsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get presetId => $state.composableBuilder(
      column: $state.table.presetId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nutrientCode => $state.composableBuilder(
      column: $state.table.nutrientCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amountPerServing => $state.composableBuilder(
      column: $state.table.amountPerServing,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ProductPresetIngredientsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductPresetIngredientsTable> {
  $$ProductPresetIngredientsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get presetId => $state.composableBuilder(
      column: $state.table.presetId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nutrientCode => $state.composableBuilder(
      column: $state.table.nutrientCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amountPerServing => $state.composableBuilder(
      column: $state.table.amountPerServing,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$ProductPresetIngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductPresetIngredientsTable,
    ProductPresetIngredientRow,
    $$ProductPresetIngredientsTableFilterComposer,
    $$ProductPresetIngredientsTableOrderingComposer,
    $$ProductPresetIngredientsTableCreateCompanionBuilder,
    $$ProductPresetIngredientsTableUpdateCompanionBuilder,
    (
      ProductPresetIngredientRow,
      BaseReferences<_$AppDatabase, $ProductPresetIngredientsTable,
          ProductPresetIngredientRow>
    ),
    ProductPresetIngredientRow,
    PrefetchHooks Function()> {
  $$ProductPresetIngredientsTableTableManager(
      _$AppDatabase db, $ProductPresetIngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ProductPresetIngredientsTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$ProductPresetIngredientsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> presetId = const Value.absent(),
            Value<String> nutrientCode = const Value.absent(),
            Value<double> amountPerServing = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductPresetIngredientsCompanion(
            id: id,
            presetId: presetId,
            nutrientCode: nutrientCode,
            amountPerServing: amountPerServing,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String presetId,
            required String nutrientCode,
            required double amountPerServing,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductPresetIngredientsCompanion.insert(
            id: id,
            presetId: presetId,
            nutrientCode: nutrientCode,
            amountPerServing: amountPerServing,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductPresetIngredientsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ProductPresetIngredientsTable,
        ProductPresetIngredientRow,
        $$ProductPresetIngredientsTableFilterComposer,
        $$ProductPresetIngredientsTableOrderingComposer,
        $$ProductPresetIngredientsTableCreateCompanionBuilder,
        $$ProductPresetIngredientsTableUpdateCompanionBuilder,
        (
          ProductPresetIngredientRow,
          BaseReferences<_$AppDatabase, $ProductPresetIngredientsTable,
              ProductPresetIngredientRow>
        ),
        ProductPresetIngredientRow,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$SchedulesTableTableManager get schedules =>
      $$SchedulesTableTableManager(_db, _db.schedules);
  $$IntakeEventsTableTableManager get intakeEvents =>
      $$IntakeEventsTableTableManager(_db, _db.intakeEvents);
  $$ProductIngredientsTableTableManager get productIngredients =>
      $$ProductIngredientsTableTableManager(_db, _db.productIngredients);
  $$NutrientsTableTableManager get nutrients =>
      $$NutrientsTableTableManager(_db, _db.nutrients);
  $$ProductPresetsTableTableManager get productPresets =>
      $$ProductPresetsTableTableManager(_db, _db.productPresets);
  $$ProductPresetIngredientsTableTableManager get productPresetIngredients =>
      $$ProductPresetIngredientsTableTableManager(
          _db, _db.productPresetIngredients);
}
