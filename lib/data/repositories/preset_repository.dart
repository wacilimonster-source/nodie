import 'package:cyjl/core/id.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/domain/nutrient_alias.dart';

/// 配方模板：保存「我的模板」、自定义成分
class PresetRepository {
  PresetRepository(this.dao);

  final AppDao dao;

  /// 由药品实例生成「我的模板」
  Future<String> saveAsTemplate({
    required MedicationRow med,
    required List<ProductIngredientRow> ingredients,
    required String name,
    String? category,
  }) async {
    final id = 'user_${newId()}';
    await dao.upsertPreset(ProductPresetRow(
      id: id,
      name: name,
      brand: null,
      category: category ?? 'mine',
      form: med.form,
      emoji: med.emoji,
      color: med.color,
      unit: '粒',
      serving: med.instruction,
      source: '我的模板',
      sourceDate: null,
      isBuiltin: false,
      isFavorite: true,
      sort: 0,
      updatedAt: DateTime.now(),
    ));
    await dao.replacePresetIngredients(
      id,
      [
        for (final i in ingredients)
          ProductPresetIngredientRow(
            id: '$id:${i.nutrientCode}',
            presetId: id,
            nutrientCode: i.nutrientCode,
            amountPerServing: i.amountPerUnit,
          ),
      ],
    );
    return id;
  }

  Future<void> toggleFavorite(String id, bool favorite) => dao.setPresetFavorite(id, favorite);

  Future<void> delete(String id) => dao.deletePreset(id);

  /// 确保自定义成分存在（AI 解析出字典外成分时创建）。规则：同名 → 复用。
  Future<String> ensureCustomNutrient(String name, {String unit = 'mg'}) async {
    final code = 'custom_${NutrientAlias.normalize(name).hashCode.abs()}';
    final existing = await dao.nutrientByCode(code);
    if (existing == null) {
      await dao.upsertCustomNutrient(NutrientRow(
        code: code,
        name: name,
        unit: unit.isEmpty ? 'mg' : unit,
        category: 'other',
        rniMale: 0,
        rniFemale: null,
        aiValue: null,
        ulValue: null,
        emoji: '➕',
        refLabel: null,
        altUnit: null,
        altFactor: null,
        note: '自定义成分（仅记录）',
        isBuiltin: false,
      ));
    }
    return code;
  }
}
