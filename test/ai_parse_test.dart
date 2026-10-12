import 'package:flutter_test/flutter_test.dart';
import 'package:cyjl/data/database/nutrient_seed.dart';
import 'package:cyjl/domain/ai_parse.dart';
import 'package:cyjl/domain/nutrient_alias.dart';

void main() {
  final parser = AiLabelParser(NutrientSeed.all);

  group('NutrientAlias', () {
    test('常见别名归一', () {
      expect(NutrientAlias.lookup('维生素D'), 'vd');
      expect(NutrientAlias.lookup('VD'), 'vd');
      expect(NutrientAlias.lookup('维生素D3'), 'vd');
      expect(NutrientAlias.lookup('胆钙化醇'), 'vd');
      expect(NutrientAlias.lookup('DHA'), 'dha');
      expect(NutrientAlias.lookup('二十二碳六烯酸'), 'dha');
      expect(NutrientAlias.lookup('碳酸钙'), 'ca');
      expect(NutrientAlias.lookup('葡萄籽提取物'), 'grape_seed');
      expect(NutrientAlias.lookup('辅酶Q10'), 'coq10');
      expect(NutrientAlias.lookup('不存在的东西'), isNull);
    });
  });

  group('AiLabelParser', () {
    test('标准 JSON 解析 + 匹配', () {
      final o = parser.parse('''
      {"product_name":"测试多维","serving":"1粒","ingredients":[
        {"name":"维生素C","value":60,"unit":"mg"},
        {"name":"锌","value":10,"unit":"mg"}
      ]}
      ''');
      expect(o.ok, isTrue);
      expect(o.productName, '测试多维');
      expect(o.items.length, 2);
      expect(o.items.first.code, 'vc');
      expect(o.items.first.amount, 60);
      expect(o.items.every((i) => i.status == ParseItemStatus.matched), isTrue);
    });

    test('IU 自动换算（维D 1000IU → 25μg）', () {
      final o = parser.parse(
          '{"ingredients":[{"name":"维生素D","value":1000,"unit":"IU"}]}');
      final vd = o.items.single;
      expect(vd.code, 'vd');
      expect(vd.amount, closeTo(25, 0.001));
      expect(vd.unit, 'μg');
      expect(vd.note, contains('换算'));
    });

    test('字典外成分 → custom', () {
      final o = parser.parse(
          '{"ingredients":[{"name":"西番莲提取物","value":100,"unit":"mg"}]}');
      final it = o.items.single;
      expect(it.code, isNull);
      expect(it.status, ParseItemStatus.custom);
    });

    test('单位不一致 → needsConfirm', () {
      final o = parser.parse(
          '{"ingredients":[{"name":"钙","value":0.6,"unit":"g"}]}');
      expect(o.items.single.status, ParseItemStatus.needsConfirm);
    });

    test('同名合并求和', () {
      final o = parser.parse(
          '{"ingredients":[{"name":"维生素C","value":60,"unit":"mg"},{"name":"维C","value":40,"unit":"mg"}]}');
      expect(o.items.length, 1);
      expect(o.items.single.amount, 100);
      expect(o.mergedCount, 1);
    });

    test('容忍 ```json 围栏与多余文字', () {
      final o = parser.parse('好的，结果如下：\n```json\n{"ingredients":[{"name":"锌","value":15,"unit":"mg"}]}\n```\n希望有帮助');
      expect(o.ok, isTrue);
      expect(o.items.single.code, 'zn');
    });

    test('值缺失 → 记 0 并标注', () {
      final o = parser.parse(
          '{"ingredients":[{"name":"葡萄籽提取物","value":null,"unit":null}]}');
      final it = o.items.single;
      expect(it.amount, 0);
      expect(it.note, contains('含量未知'));
    });

    test('非法输入 → 报错', () {
      expect(parser.parse('').error, isNotNull);
      expect(parser.parse('没有 json').error, isNotNull);
      expect(parser.parse('{"foo":1}').error, isNotNull);
    });
  });
}
