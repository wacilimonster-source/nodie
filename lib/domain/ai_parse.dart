import 'dart:convert';

import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/domain/nutrient_alias.dart';

enum ParseItemStatus { matched, needsConfirm, custom }

/// 解析出的一条成分
class ParsedIngredient {
  const ParsedIngredient({
    required this.rawName,
    required this.name,
    this.code,
    required this.amount,
    required this.unit,
    required this.status,
    this.note,
  });

  final String rawName; // AI 原始名称
  final String name; // 展示名（匹配到则用字典名）
  final String? code; // 匹配到的 nutrient code；custom 时为 null
  final double amount;
  final String unit;
  final ParseItemStatus status;
  final String? note;

  ParsedIngredient copyWith({double? amount, String? unit, String? code, String? name, ParseItemStatus? status}) =>
      ParsedIngredient(
        rawName: rawName,
        name: name ?? this.name,
        code: code ?? this.code,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
        status: status ?? this.status,
        note: note,
      );
}

class ParseOutcome {
  const ParseOutcome({
    this.productName,
    this.serving,
    this.items = const [],
    this.error,
    this.mergedCount = 0,
  });

  final String? productName;
  final String? serving;
  final List<ParsedIngredient> items;
  final String? error;
  final int mergedCount;

  bool get ok => error == null && items.isNotEmpty;
}

/// 解析「AI 按提示词返回的 JSON」→ 结构化成分（展示前需人工确认）
class AiLabelParser {
  AiLabelParser(this.nutrients);

  final List<NutrientRow> nutrients;
  late final Map<String, NutrientRow> _byCode = {for (final n in nutrients) n.code: n};

  ParseOutcome parse(String raw) {
    if (raw.trim().isEmpty) {
      return const ParseOutcome(error: '内容为空，请先粘贴 AI 返回的 JSON');
    }
    final jsonText = _extractJson(raw);
    if (jsonText == null) {
      return const ParseOutcome(error: '未找到 JSON，请确认粘贴的是 AI 返回的内容');
    }
    Map<String, dynamic> json;
    try {
      json = jsonDecode(jsonText) as Map<String, dynamic>;
    } catch (e) {
      return ParseOutcome(error: 'JSON 解析失败：$e');
    }
    final list = json['ingredients'];
    if (list is! List) {
      return const ParseOutcome(error: '缺少 ingredients 数组');
    }

    final items = <ParsedIngredient>[];
    final indexByCode = <String, int>{};
    var merged = 0;

    for (final e in list) {
      if (e is! Map) continue;
      final rawName = (e['name'] ?? '').toString().trim();
      if (rawName.isEmpty) continue;

      final valueNum = _toDouble(e['value']);
      var unit = (e['unit'] ?? '').toString().trim();
      var amount = valueNum ?? 0;
      String? note;
      if (valueNum == null) note = '含量未知（AI 未给出数值）';

      final code = NutrientAlias.lookup(rawName);
      final n = code == null ? null : _byCode[code];
      var status = ParseItemStatus.matched;

      if (code == null) {
        status = ParseItemStatus.custom;
        note = _join(note, '字典外成分（将新建自定义）');
      } else if (unit.isNotEmpty &&
          n!.altUnit != null &&
          unit.toUpperCase() == n.altUnit!.toUpperCase()) {
        // IU 等换算为规范单位
        amount = amount * (n.altFactor ?? 1);
        unit = n.unit;
        note = _join(note, '已按 1${n.altUnit}=${n.altFactor}${n.unit} 换算');
      } else if (unit.isNotEmpty && unit != n!.unit) {
        status = ParseItemStatus.needsConfirm;
        note = _join(note, '单位「$unit」与字典「${n.unit}」不一致，请确认');
      }

      final finalUnit = unit.isEmpty ? (n?.unit ?? 'mg') : unit;
      final displayName = n?.name ?? rawName;

      if (code != null && indexByCode.containsKey(code)) {
        final i = indexByCode[code]!;
        items[i] = items[i].copyWith(amount: items[i].amount + amount);
        merged++;
      } else {
        if (code != null) indexByCode[code] = items.length;
        items.add(ParsedIngredient(
          rawName: rawName,
          name: displayName,
          code: code,
          amount: amount,
          unit: finalUnit,
          status: status,
          note: note,
        ));
      }
    }

    return ParseOutcome(
      productName: (json['product_name'] as String?)?.trim(),
      serving: (json['serving'] as String?)?.trim(),
      items: items,
      mergedCount: merged,
    );
  }

  String? _extractJson(String raw) {
    final start = raw.indexOf('{');
    final end = raw.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    return raw.substring(start, end + 1);
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(s);
  }

  static String? _join(String? a, String b) => a == null ? b : '$a；$b';
}
