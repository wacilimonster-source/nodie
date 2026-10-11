import 'package:cyjl/data/database/app_database.dart';

/// DRIs 2023 营养素字典种子数据（中国营养学会《中国居民膳食营养素参考摄入量 2023》）
/// rniMale/rniFemale：成人推荐摄入量；aiValue：适宜摄入量；ulValue：可耐受最高摄入量（null=未设定）
abstract final class NutrientSeed {
  static final List<NutrientRow> all = [
    _n('vd', '维生素D', 'μg', 'vitamin', 10, 10, null, 50, '☀️'),
    _n('vc', '维生素C', 'mg', 'vitamin', 100, 100, null, 2000, '🍊'),
    _n('va', '维生素A', 'μgRAE', 'vitamin', 800, 700, null, 3000, '🥕'),
    _n('b12', '维生素B12', 'μg', 'vitamin', 2.4, 2.4, null, null, '🥩'),
    _n('ca', '钙', 'mg', 'mineral', 800, 800, null, 2000, '🦴'),
    _n('fe', '铁', 'mg', 'mineral', 12, 20, null, 42, '🩸'),
    _n('zn', '锌', 'mg', 'mineral', 12.5, 7.5, null, 40, '🛡️'),
    _n('mg', '镁', 'mg', 'mineral', 330, 330, null, null, '🌿'),
    _n('omg', 'Omega-3 (EPA+DHA)', 'mg', 'fatty_acid', 250, 250, 250, null, '🐟'),
  ];

  static NutrientRow _n(
    String code,
    String name,
    String unit,
    String category,
    double rniMale,
    double rniFemale,
    double? ai,
    double? ul,
    String emoji,
  ) =>
      NutrientRow(
        code: code,
        name: name,
        unit: unit,
        category: category,
        rniMale: rniMale,
        rniFemale: rniFemale,
        aiValue: ai,
        ulValue: ul,
        emoji: emoji,
      );
}
