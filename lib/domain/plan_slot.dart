import 'dart:convert';
import 'package:cyjl/core/date_utils.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/core/format.dart';
import 'package:cyjl/data/database/app_database.dart';

/// 计划时间点（早晚不同剂量由多个 slot 表达）
class PlanSlot {
  const PlanSlot({required this.time, required this.dose, required this.unit});

  final String time; // HH:mm
  final double dose;
  final String unit;

  static PlanSlot fromJson(Map<String, dynamic> j) => PlanSlot(
        time: j['time'] as String,
        dose: (j['dose'] as num).toDouble(),
        unit: (j['unit'] as String?) ?? '片',
      );

  Map<String, dynamic> toJson() => {'time': time, 'dose': dose, 'unit': unit};

  PlanSlot copyWith({String? time, double? dose, String? unit}) => PlanSlot(
        time: time ?? this.time,
        dose: dose ?? this.dose,
        unit: unit ?? this.unit,
      );
}

String encodeSlots(List<PlanSlot> slots) =>
    jsonEncode(slots.map((s) => s.toJson()).toList());

List<PlanSlot> decodeSlots(String json) {
  final list = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
  return list.map(PlanSlot.fromJson).toList();
}

/// 营养成分输入
class IngredientDraft {
  const IngredientDraft({required this.nutrientCode, required this.amountPerUnit});

  final String nutrientCode;
  final double amountPerUnit;
}

/// 营养素摄入项（当日汇总 vs DRIs）
class NutrientIntake {
  const NutrientIntake({
    required this.nutrient,
    required this.amount,
    required this.sources,
  });

  final NutrientRow nutrient;
  final double amount;
  final List<NutrientSource> sources;

  /// 是否有参考值（RNI/AI/SPL）；false = 仅记录、不做达标/上限对比
  bool get hasReference => (nutrient.refLabel ?? '').isNotEmpty && nutrient.rniMale > 0;

  /// 参考摄入量：优先人群 RNI，无则 AI
  double goal(bool femaleProfile) =>
      (femaleProfile && nutrient.rniFemale != null) ? nutrient.rniFemale! : nutrient.rniMale;

  bool get hasAI => nutrient.aiValue != null && nutrient.aiValue! > 0;
  double? get ul => nutrient.ulValue;
  bool get hasUl => nutrient.ulValue != null && nutrient.ulValue! > 0;

  bool reached(bool femaleProfile) => hasReference && amount >= goal(femaleProfile);
  bool get overUl => hasReference && hasUl && amount > nutrient.ulValue!;
  bool nearUl(bool femaleProfile) {
    if (!hasReference || overUl || !hasUl) return false;
    return amount >= nutrient.ulValue! * 0.8 && amount > goal(femaleProfile);
  }
}

class NutrientSource {
  const NutrientSource({required this.name, required this.emoji, required this.amount});

  final String name;
  final String emoji;
  final double amount;
}

/// 计划的人类可读摘要，如「每天 · 08:00 / 20:00 · 1片/2片」
String describeSchedule(ScheduleRow s) {
  final freq = FreqType.fromCode(s.freqType);
  final String base;
  switch (freq) {
    case FreqType.daily:
      base = '每天';
      break;
    case FreqType.weekly:
      final days = parseWeekdays(s.weekdays);
      base = '每周 ${days.map((d) => '一二三四五六日'[d - 1]).join('/')}';
      break;
    case FreqType.everyNDays:
      base = '每隔 ${s.intervalDays ?? 2} 天';
      break;
    case FreqType.cycle:
      base = '吃 ${s.cycleOn ?? 5} 天停 ${s.cycleOff ?? 2} 天';
      break;
    case FreqType.asNeeded:
      return '按需服用 · 不提醒';
  }
  final slots = decodeSlots(s.times);
  if (slots.isEmpty) return base;
  final times = slots.map((x) => x.time).join(' / ');
  final doses = slots.map((x) => '${fmtNum(x.dose)}${x.unit}').toSet().join('/');
  return '$base · $times · $doses';
}
