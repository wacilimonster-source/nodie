import 'package:cyjl/data/database/app_database.dart';

/// 内置通用配方模板（35 个）。
/// 成分含量为**参考近似值**，仅供快速录入，请以实物标签为准。
abstract final class PresetSeed {
  static final DateTime _when = DateTime(2026, 1, 1);

  static final List<ProductPresetRow> presets = [
    _p('pre_multi_men', '复合维生素（男士）', 'basic', '💪', '每天1粒·随餐'),
    _p('pre_multi_women', '复合维生素（女士）', 'basic', '🌸', '每天1粒·随餐'),
    _p('pre_multi_min', '复合维生素+矿物质', 'basic', '💊', '每天1粒·随餐'),
    _p('pre_b_complex', 'B族复合', 'basic', '🌾', '每天1粒'),
    _p('pre_vc', '维生素C', 'basic', '🍊', '每天1粒'),
    _p('pre_d3', '维生素D3', 'basic', '☀️', '每天1粒·随餐'),
    _p('pre_d3k2', '维生素D3+K2', 'basic', '☀️', '每天1粒·随餐'),
    _p('pre_ve', '维生素E', 'basic', '🌰', '每天1粒·随餐'),
    _p('pre_fe', '铁+维C', 'basic', '🩸', '每天1粒·空腹'),
    _p('pre_zn_se', '锌+硒', 'basic', '🛡️', '每天1粒·随餐'),
    _p('pre_ca_d3', '钙+D3', 'bone', '🦴', '每天1-2粒·随餐'),
    _p('pre_ca_d3k2', '钙+D3+K2', 'bone', '🦴', '每天1-2粒·随餐'),
    _p('pre_joint', '氨糖软骨素', 'bone', '🦵', '每天1-2片·随餐'),
    _p('pre_collagen_vc', '胶原蛋白+VC', 'bone', '🧴', '每天1份'),
    _p('pre_msm', 'MSM 二甲基砜', 'bone', '🧪', '每天1-2片·随餐'),
    _p('pre_fish_oil', '鱼油', 'cardio', '🐟', '每天1-2粒·随餐'),
    _p('pre_fish_oil_hi', '鱼油（高浓度）', 'cardio', '🐟', '每天1粒·随餐'),
    _p('pre_krill', '磷虾油', 'cardio', '🦐', '每天1粒·随餐'),
    _p('pre_coq10', '辅酶Q10', 'cardio', '⚡', '每天1粒·随餐'),
    _p('pre_folate_b', '叶酸+B族', 'cardio', '🥬', '每天1片'),
    _p('pre_natto', '纳豆激酶', 'cardio', '🫘', '每天1粒·睡前'),
    _p('pre_propolis', '蜂胶', 'immune', '🐝', '每天1粒'),
    _p('pre_lutein', '叶黄素+玉米黄质', 'eye', '👁️', '每天1粒·随餐'),
    _p('pre_bilberry', '越橘花青素', 'eye', '🫐', '每天1粒'),
    _p('pre_probiotic', '益生菌', 'gut', '🦠', '每天1粒·空腹'),
    _p('pre_inulin', '菊粉/膳食纤维', 'gut', '🧅', '每天1份'),
    _p('pre_grape_seed', '葡萄籽原花青素', 'beauty', '🍇', '每天1粒'),
    _p('pre_biotin', '生物素', 'beauty', '💇', '每天1片'),
    _p('pre_hyaluronic', '透明质酸', 'beauty', '💧', '每天1粒'),
    _p('pre_melatonin', '褪黑素', 'sleep', '🌙', '睡前1粒'),
    _p('pre_gaba', 'GABA+茶氨酸', 'sleep', '😌', '睡前1-2粒'),
    _p('pre_mg_gly', '甘氨酸镁', 'sleep', '🌿', '睡前1-2粒'),
    _p('pre_prenatal', '孕期复合维生素', 'female', '🤰', '每天1粒·随餐'),
    _p('pre_cranberry', '蔓越莓提取物', 'female', '🍒', '每天1粒'),
    _p('pre_gla', '月见草油', 'female', '🌼', '每天1-2粒·随餐'),
  ];

  static final List<ProductPresetIngredientRow> ingredients = [
    ..._ing('pre_multi_men', {
      'vd': 10, 'vc': 100, 've': 14, 'b1': 1.4, 'b2': 1.4, 'b3': 16, 'b5': 5,
      'b6': 1.4, 'b7': 30, 'b9': 200, 'b12': 2.4, 'zn': 10, 'se': 55, 'mg': 60, 'ca': 120,
    }),
    ..._ing('pre_multi_women', {
      'vd': 10, 'vc': 100, 've': 14, 'b1': 1.4, 'b2': 1.4, 'b3': 16, 'b5': 5,
      'b6': 1.4, 'b7': 30, 'b9': 300, 'b12': 2.4, 'fe': 10, 'zn': 8, 'se': 55, 'mg': 60, 'ca': 150,
    }),
    ..._ing('pre_multi_min', {
      'vd': 10, 'vc': 100, 've': 14, 'b1': 1.4, 'b2': 1.4, 'b3': 16, 'b6': 1.4, 'b9': 200,
      'b12': 2.4, 'ca': 200, 'mg': 100, 'zn': 10, 'se': 55, 'cu': 0.5, 'mn': 2, 'i': 100, 'cr': 25, 'mo': 50,
    }),
    ..._ing('pre_b_complex', {
      'b1': 1.4, 'b2': 1.3, 'b3': 16, 'b5': 5, 'b6': 1.4, 'b7': 30, 'b9': 200, 'b12': 2.4, 'choline': 50,
    }),
    ..._ing('pre_vc', {'vc': 500}),
    ..._ing('pre_d3', {'vd': 25}),
    ..._ing('pre_d3k2', {'vd': 25, 'vk': 45}),
    ..._ing('pre_ve', {'ve': 100}),
    ..._ing('pre_fe', {'fe': 20, 'vc': 100}),
    ..._ing('pre_zn_se', {'zn': 15, 'se': 100}),
    ..._ing('pre_ca_d3', {'ca': 600, 'vd': 10}),
    ..._ing('pre_ca_d3k2', {'ca': 600, 'vd': 10, 'vk': 45}),
    ..._ing('pre_joint', {'glucosamine': 1500, 'chondroitin': 800}),
    ..._ing('pre_collagen_vc', {'collagen': 5000, 'vc': 100}),
    ..._ing('pre_msm', {'msm': 1500}),
    ..._ing('pre_fish_oil', {'omg': 300}),
    ..._ing('pre_fish_oil_hi', {'omg': 1000}),
    ..._ing('pre_krill', {'omg': 250, 'astaxanthin': 1}),
    ..._ing('pre_coq10', {'coq10': 100}),
    ..._ing('pre_folate_b', {'b9': 400, 'b6': 1.4, 'b12': 2.4, 'b2': 1.3}),
    ..._ing('pre_natto', {'nattokinase': 2000}),
    ..._ing('pre_propolis', {'propolis': 500}),
    ..._ing('pre_lutein', {'lutein': 10, 'zeaxanthin': 2}),
    ..._ing('pre_bilberry', {'anthocyanin': 100}),
    ..._ing('pre_probiotic', {'probiotics': 100}),
    ..._ing('pre_inulin', {'inulin': 5000}),
    ..._ing('pre_grape_seed', {'grape_seed': 150, 'proantho': 95}),
    ..._ing('pre_biotin', {'b7': 5000}),
    ..._ing('pre_hyaluronic', {'hyaluronic': 120}),
    ..._ing('pre_melatonin', {'melatonin': 3}),
    ..._ing('pre_gaba', {'gaba': 100, 'theanine': 100}),
    ..._ing('pre_mg_gly', {'mg': 200}),
    ..._ing('pre_prenatal', {'b9': 600, 'fe': 20, 'vd': 10, 'ca': 200, 'b12': 2.6, 'i': 150, 'zn': 10}),
    ..._ing('pre_cranberry', {'cranberry': 500}),
    ..._ing('pre_gla', {'gla': 100}),
  ];

  static ProductPresetRow _p(
    String id,
    String name,
    String category,
    String emoji,
    String serving,
  ) =>
      ProductPresetRow(
        id: id,
        name: name,
        brand: null,
        category: category,
        form: '片剂',
        emoji: emoji,
        color: '#7BA96A',
        unit: '粒',
        serving: serving,
        source: '内置通用配方（近似值，仅供参考）',
        sourceDate: '2026-01',
        isBuiltin: true,
        isFavorite: false,
        sort: 0,
        updatedAt: _when,
      );

  static List<ProductPresetIngredientRow> _ing(String presetId, Map<String, double> map) => map.entries
      .map((e) => ProductPresetIngredientRow(
            id: '$presetId:${e.key}',
            presetId: presetId,
            nutrientCode: e.key,
            amountPerServing: e.value,
          ))
      .toList();
}
