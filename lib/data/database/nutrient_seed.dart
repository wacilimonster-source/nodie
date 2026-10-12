import 'package:cyjl/data/database/app_database.dart';

/// DRIs 2023 内置字典（中国营养学会《中国居民膳食营养素参考摄入量 2023 版》）
///
/// - rniMale/rniFemale：目标值（RNI 推荐量 / AI 适宜量），0 表示无参考（仅记录）
/// - aiValue：适宜摄入量（用于展示参考类型）
/// - ulValue：可耐受最高摄入量（null = 未设定）
/// - refLabel：参考类型文案；null = 仅记录、不做达标/上限对比
/// - altUnit/altFactor：可选输入单位换算（如 1 IU = altFactor × unit）
///
/// 注：第 15 章「其他膳食成分」的 SPL 特定建议值暂未核对到公开数值，
/// 故 phyto 类别统一为「仅记录」，待核对官方表格后再开启参考值。
abstract final class NutrientSeed {
  static final List<NutrientRow> all = [
    // ============ 维生素 ============
    _n('vd', '维生素D', 'μg', 'vitamin', 10, 10, null, 50, '☀️', altUnit: 'IU', altFactor: 0.025),
    _n('va', '维生素A', 'μgRAE', 'vitamin', 800, 700, null, 3000, '🥕', altUnit: 'IU', altFactor: 0.3),
    _n('ve', '维生素E', 'mgα-TE', 'vitamin', 14, 14, 14, 700, '🌰', altUnit: 'IU', altFactor: 0.67),
    _n('vk', '维生素K', 'μg', 'vitamin', 80, 80, 80, null, '🥬'),
    _n('b1', '维生素B1', 'mg', 'vitamin', 1.4, 1.2, null, null, '🌾'),
    _n('b2', '维生素B2', 'mg', 'vitamin', 1.4, 1.2, null, null, '🥛'),
    _n('b3', '烟酸（B3）', 'mgNE', 'vitamin', 15, 12, null, 35, '🔆'),
    _n('b5', '泛酸（B5）', 'mg', 'vitamin', 5, 5, 5, null, '🫘'),
    _n('b6', '维生素B6', 'mg', 'vitamin', 1.4, 1.2, null, 60, '🍌'),
    _n('b7', '生物素（B7）', 'μg', 'vitamin', 40, 40, 40, null, '🥚'),
    _n('b9', '叶酸（B9）', 'μgDFE', 'vitamin', 400, 400, null, 1000, '🥬'),
    _n('b12', '维生素B12', 'μg', 'vitamin', 2.4, 2.4, null, null, '🥩'),
    _n('vc', '维生素C', 'mg', 'vitamin', 100, 100, null, 2000, '🍊'),
    _n('choline', '胆碱', 'mg', 'vitamin', 500, 400, 500, 3000, '🧠'),

    // ============ 矿物质 ============
    _n('ca', '钙', 'mg', 'mineral', 800, 800, null, 2000, '🦴'),
    _n('p', '磷', 'mg', 'mineral', 720, 720, null, 3500, '🦴'),
    _n('k', '钾', 'mg', 'mineral', 2000, 2000, 2000, null, '🍌'),
    _n('na', '钠', 'mg', 'mineral', 1500, 1500, 1500, null, '🧂'),
    _n('mg', '镁', 'mg', 'mineral', 330, 330, null, null, '🌿'),
    _n('fe', '铁', 'mg', 'mineral', 12, 20, null, 42, '🩸'),
    _n('zn', '锌', 'mg', 'mineral', 12.5, 7.5, null, 40, '🛡️'),
    _n('i', '碘', 'μg', 'mineral', 120, 120, null, 600, '🧂'),
    _n('se', '硒', 'μg', 'mineral', 60, 60, null, 400, '🥜'),
    _n('cu', '铜', 'mg', 'mineral', 0.8, 0.8, null, 8, '🔶'),
    _n('mn', '锰', 'mg', 'mineral', 4.5, 4.5, 4.5, 11, '⚙️'),
    _n('mo', '钼', 'μg', 'mineral', 100, 100, null, 600, '🔩'),
    _n('cr', '铬', 'μg', 'mineral', 30, 30, 30, null, '✨'),
    _n('f', '氟', 'mg', 'mineral', 1.5, 1.5, 1.5, 3.5, '🦷'),

    // ============ 脂肪酸（含鱼油） ============
    _n('omg', 'Omega-3 (EPA+DHA)', 'mg', 'fatty_acid', 250, 250, 250, null, '🐟',
        note: 'EPA+DHA 合计建议 ≥250mg'),
    _n('epa', 'EPA（鱼油）', 'mg', 'fatty_acid', 0, 0, null, null, '🐟',
        note: '鱼油主要成分；与 DHA 合计建议 ≥250mg'),
    _n('dha', 'DHA（鱼油）', 'mg', 'fatty_acid', 0, 0, null, null, '🐟',
        note: '鱼油主要成分；与 EPA 合计建议 ≥250mg'),
    _n('ala', 'α-亚麻酸', 'mg', 'fatty_acid', 0, 0, null, null, '🌱'),

    // ============ 其他膳食成分（植物化学物 / 氨基酸衍生物等，DRIs 第15章；仅记录）============
    _n('lutein', '叶黄素', 'mg', 'phyto', 0, 0, null, null, '👁️'),
    _n('zeaxanthin', '玉米黄质', 'mg', 'phyto', 0, 0, null, null, '👁️'),
    _n('lycopene', '番茄红素', 'mg', 'phyto', 0, 0, null, null, '🍅'),
    _n('proantho', '原花青素', 'mg', 'phyto', 0, 0, null, null, '🍇'),
    _n('anthocyanin', '花色苷', 'mg', 'phyto', 0, 0, null, null, '🫐'),
    _n('isoflavone', '大豆异黄酮', 'mg', 'phyto', 0, 0, null, null, '🫘'),
    _n('catechin', '儿茶素', 'mg', 'phyto', 0, 0, null, null, '🍵'),
    _n('quercetin', '槲皮素', 'mg', 'phyto', 0, 0, null, null, '🧅'),
    _n('curcumin', '姜黄素', 'mg', 'phyto', 0, 0, null, null, '🟡'),
    _n('resveratrol', '白藜芦醇', 'mg', 'phyto', 0, 0, null, null, '🍇'),
    _n('phytosterol', '植物甾醇', 'mg', 'phyto', 0, 0, null, null, '🌰'),
    _n('astaxanthin', '虾青素', 'mg', 'phyto', 0, 0, null, null, '🦐'),
    _n('coq10', '辅酶Q10', 'mg', 'phyto', 0, 0, null, null, '⚡'),
    _n('betaine', '甜菜碱', 'mg', 'phyto', 0, 0, null, null, '🥬'),
    _n('taurine', '牛磺酸', 'mg', 'phyto', 0, 0, null, null, '🐂'),
    _n('gaba', 'γ-氨基丁酸', 'mg', 'phyto', 0, 0, null, null, '😌'),
    _n('carnitine', '左旋肉碱', 'mg', 'phyto', 0, 0, null, null, '🔥'),
    _n('inulin', '菊粉/低聚果糖', 'mg', 'phyto', 0, 0, null, null, '🧅'),
    _n('glucan', 'β-葡聚糖', 'mg', 'phyto', 0, 0, null, null, '🌾'),
    _n('glucosamine', '氨基葡萄糖（氨糖）', 'mg', 'phyto', 0, 0, null, null, '🦵'),
    _n('chlorogenic', '绿原酸', 'mg', 'phyto', 0, 0, null, null, '☕'),
    _n('allicin', '大蒜素', 'mg', 'phyto', 0, 0, null, null, '🧄'),

    // ============ 其他成分（DRIs 无标准；仅记录）============
    _n('melatonin', '褪黑素', 'mg', 'other', 0, 0, null, null, '🌙'),
    _n('collagen', '胶原蛋白肽', 'mg', 'other', 0, 0, null, null, '🧴'),
    _n('chondroitin', '软骨素', 'mg', 'other', 0, 0, null, null, '🦴'),
    _n('probiotics', '益生菌', '亿CFU', 'other', 0, 0, null, null, '🦠'),
    _n('creatine', '肌酸', 'mg', 'other', 0, 0, null, null, '💪'),
    _n('hyaluronic', '透明质酸', 'mg', 'other', 0, 0, null, null, '💧'),
    _n('msm', 'MSM（二甲基砜）', 'mg', 'other', 0, 0, null, null, '🧪'),
    _n('nac', 'NAC（N-乙酰半胱氨酸）', 'mg', 'other', 0, 0, null, null, '🫁'),
    _n('nmn', 'NMN', 'mg', 'other', 0, 0, null, null, '🧬'),
    _n('inositol', '肌醇', 'mg', 'other', 0, 0, null, null, '⭕'),
    _n('theanine', '茶氨酸', 'mg', 'other', 0, 0, null, null, '🍵'),
    _n('grape_seed', '葡萄籽提取物', 'mg', 'other', 0, 0, null, null, '🍇'),
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
    String emoji, {
    String? refLabel,
    String? altUnit,
    double? altFactor,
    String? note,
  }) {
    final label = refLabel ?? (rniMale > 0 ? (ai != null ? 'AI适宜量' : 'RNI推荐量') : null);
    return NutrientRow(
      code: code,
      name: name,
      unit: unit,
      category: category,
      rniMale: rniMale,
      rniFemale: rniFemale,
      aiValue: ai,
      ulValue: ul,
      emoji: emoji,
      refLabel: label,
      altUnit: altUnit,
      altFactor: altFactor,
      note: note,
    );
  }
}
