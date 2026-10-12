/// 成分名称别名词典：把标签 / 大模型输出的各种写法归一化到 nutrient code。
/// 归一化：转小写 + 去空格与常见标点。
abstract final class NutrientAlias {
  static String normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[\s\u3000()（）\[\]【】{}·、,，.。:：;；/\\%％*|\-_—]'), '');

  /// code → 别名列表（会一并加入 code 本身作为别名）
  static const Map<String, List<String>> raw = {
    'vd': ['维生素d', '维d', 'vd', '维生素d3', '维d3', 'd3', '胆钙化醇', 'vitamind', 'cholecalciferol'],
    'va': ['维生素a', '维a', 'va', '视黄醇', 'vitamina', 'retinol', 'β胡萝卜素'],
    've': ['维生素e', '维e', 've', '生育酚', 'vitamine', 'tocopherol'],
    'vk': ['维生素k', '维k', 'vk', '维生素k2', 'k2', 'mk7', '甲萘醌'],
    'vc': ['维生素c', '维c', 'vc', '抗坏血酸', 'vitaminc', 'ascorbicacid'],
    'b1': ['维生素b1', '维b1', 'b1', '硫胺素', 'thiamine', 'thiamin'],
    'b2': ['维生素b2', '维b2', 'b2', '核黄素', 'riboflavin'],
    'b3': ['维生素b3', '维b3', 'b3', '烟酸', '烟酰胺', '尼克酸', 'niacin', 'nicotinamide'],
    'b5': ['维生素b5', '维b5', 'b5', '泛酸', 'pantothenicacid'],
    'b6': ['维生素b6', '维b6', 'b6', '吡哆醇', 'pyridoxine'],
    'b7': ['维生素b7', '维b7', 'b7', '生物素', 'biotin', '维生素h'],
    'b9': ['维生素b9', '维b9', 'b9', '叶酸', 'folate', 'folicacid'],
    'b12': ['维生素b12', '维b12', 'b12', '钴胺素', '甲钴胺', 'cobalamin'],
    'choline': ['胆碱', 'choline'],
    'ca': ['钙', 'ca', 'calcium', '碳酸钙', '柠檬酸钙', '液体钙'],
    'p': ['磷', 'phosphorus', 'phosphate'],
    'k': ['钾', 'potassium'],
    'na': ['钠', 'sodium'],
    'mg': ['镁', 'magnesium', '氧化镁', '甘氨酸镁', '柠檬酸镁', '苏糖酸镁'],
    'fe': ['铁', 'iron', '硫酸亚铁', '富马酸亚铁', '葡萄糖酸亚铁', '甘氨酸亚铁'],
    'zn': ['锌', 'zinc', '葡萄糖酸锌', '柠檬酸锌', '酵母锌'],
    'i': ['碘', 'iodine', 'iodide', '碘化钾'],
    'se': ['硒', 'selenium', '硒代蛋氨酸', '酵母硒'],
    'cu': ['铜', 'copper'],
    'mn': ['锰', 'manganese'],
    'mo': ['钼', 'molybdenum'],
    'cr': ['铬', 'chromium'],
    'f': ['氟', 'fluoride'],
    'omg': ['omega3', 'omega-3', '欧米伽3', '欧米伽-3', 'epa+dha', 'dha+epa', '深海鱼油', '鱼油', '鳕鱼肝油', 'ω3'],
    'epa': ['epa', '二十碳五烯酸'],
    'dha': ['dha', '二十二碳六烯酸', '藻油dha'],
    'ala': ['ala', 'α亚麻酸', 'α-亚麻酸', '亚麻酸'],
    'gla': ['gla', 'γ亚麻酸', 'γ-亚麻酸', '月见草'],
    'lutein': ['叶黄素', 'lutein'],
    'zeaxanthin': ['玉米黄质', '玉米黄素', 'zeaxanthin'],
    'lycopene': ['番茄红素', 'lycopene'],
    'proantho': ['原花青素', 'opc', 'proanthocyanidin'],
    'anthocyanin': ['花青素', '花色苷', 'anthocyanin', '越橘', '蓝莓提取物'],
    'isoflavone': ['大豆异黄酮', '异黄酮', 'isoflavone'],
    'catechin': ['儿茶素', '茶多酚', 'catechin', 'egcg'],
    'quercetin': ['槲皮素', 'quercetin'],
    'curcumin': ['姜黄素', 'curcumin', '姜黄'],
    'resveratrol': ['白藜芦醇', 'resveratrol'],
    'phytosterol': ['植物甾醇', 'phytosterol', '甾醇'],
    'astaxanthin': ['虾青素', 'astaxanthin'],
    'coq10': ['辅酶q10', '辅酶q-10', 'coq10', 'coenzymeq10', '泛醌'],
    'betaine': ['甜菜碱', 'betaine'],
    'taurine': ['牛磺酸', 'taurine'],
    'gaba': ['gaba', 'γ氨基丁酸', 'γ-氨基丁酸', '氨基丁酸'],
    'carnitine': ['左旋肉碱', '肉碱', 'carnitine', 'l-carnitine'],
    'inulin': ['菊粉', '低聚果糖', 'inulin', 'fos'],
    'glucan': ['葡聚糖', 'β葡聚糖', 'β-葡聚糖', 'betaglucan'],
    'glucosamine': ['氨基葡萄糖', '氨糖', '葡萄糖胺', 'glucosamine'],
    'chlorogenic': ['绿原酸', 'chlorogenicacid'],
    'allicin': ['大蒜素', 'allicin'],
    'silymarin': ['水飞蓟', '水飞蓟素', '奶蓟草', 'silymarin', 'milkthistle'],
    'propolis': ['蜂胶', 'propolis'],
    'cranberry': ['蔓越莓', 'cranberry'],
    'nattokinase': ['纳豆激酶', 'nattokinase'],
    'melatonin': ['褪黑素', 'melatonin', '松果体素'],
    'collagen': ['胶原蛋白', '胶原蛋白肽', '水解胶原蛋白', 'collagen'],
    'chondroitin': ['软骨素', '硫酸软骨素', 'chondroitin'],
    'probiotics': ['益生菌', '双歧杆菌', '乳酸菌', 'probiotic'],
    'creatine': ['肌酸', 'creatine'],
    'hyaluronic': ['透明质酸', '玻尿酸', 'hyaluronicacid'],
    'msm': ['msm', '二甲基砜', '甲基磺酰基甲烷'],
    'nac': ['nac', '乙酰半胱氨酸', 'nacetylcysteine'],
    'nmn': ['nmn', '烟酰胺单核苷酸'],
    'inositol': ['肌醇', 'inositol'],
    'theanine': ['茶氨酸', 'l-茶氨酸', 'theanine'],
    'grape_seed': ['葡萄籽', '葡萄籽提取物', 'grapeseed'],
  };

  static final Map<String, String> _map = _build();

  static Map<String, String> _build() {
    final m = <String, String>{};
    raw.forEach((code, aliases) {
      m[normalize(code)] = code;
      for (final a in aliases) {
        m[normalize(a)] = code;
      }
    });
    return m;
  }

  /// 归一化名称 → nutrient code；先精确匹配，再按最长别名做包含匹配。
  static String? lookup(String name) {
    final q = normalize(name);
    if (q.isEmpty) return null;
    final direct = _map[q];
    if (direct != null) return direct;

    String? best;
    var bestLen = 0;
    for (final entry in _map.entries) {
      final alias = entry.key;
      if (alias.length < 2) continue;
      if ((q.contains(alias) || alias.contains(q)) && alias.length > bestLen) {
        best = entry.value;
        bestLen = alias.length;
      }
    }
    return best;
  }
}
