import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/repositories/medication_repository.dart';
import 'package:cyjl/domain/ai_parse.dart';
import 'package:cyjl/domain/ai_prompt.dart';
import 'package:cyjl/domain/plan_slot.dart';
import 'package:cyjl/shared/widgets/pop_button.dart';

const _paletteHex = [
  '#E07A5F', '#DDA54F', '#F2CC8F', '#5F8D4E', '#7BA96A', '#8CB4C9', '#9B8CB8', '#E8A0B4',
];
const _emojiChoices = ['💊', '🌿', '🌞', '🐟', '🌙', '🧬', '🍊', '🦴'];
const _formChoices = ['片剂', '胶囊', '软胶囊', '液体', '粉剂', '软糖', '其他'];
const _instructionChoices = ['随餐', '空腹', '睡前', '晨起'];
const _unitChoices = ['片', '粒', 'mg', 'g', 'ml', 'IU', '袋', '滴'];

class AddMedScreen extends ConsumerStatefulWidget {
  const AddMedScreen({super.key, this.editMedId});

  final String? editMedId;

  @override
  ConsumerState<AddMedScreen> createState() => _AddMedScreenState();
}

class _AddMedScreenState extends ConsumerState<AddMedScreen> {
  MedType _type = MedType.supplement;
  String _name = '';
  String _form = '片剂';
  String _color = '#7BA96A';
  String _emoji = '🌿';
  String? _instruction;
  String _note = '';

  FreqType _freq = FreqType.daily;
  List<int> _weekdays = [1, 3, 5];
  int _intervalDays = 2;
  int _cycleOn = 5;
  int _cycleOff = 2;
  List<PlanSlot> _slots = [const PlanSlot(time: '08:00', dose: 1, unit: '片')];

  bool _stockOn = true;
  double _stock = 60;
  int _lowDays = 7;

  List<IngredientDraft> _ingredients = [];

  DateTime _start = DateTime.now();
  DateTime? _end;

  int _step = 0;
  bool _saving = false;
  bool _prefillDone = false;

  // 快速填充（模板 / AI 解析）
  String _fillMode = 'blank'; // blank | template | ai
  String? _selectedPresetId;
  String _tplQuery = '';
  final TextEditingController _aiCtrl = TextEditingController();
  final TextEditingController _tplNameCtrl = TextEditingController();
  ParseOutcome? _parseOutcome;
  bool _aiBusy = false;
  bool _saveAsTemplate = false;

  bool get _isEdit => widget.editMedId != null;

  List<String> get _steps => _type == MedType.supplement
      ? const ['选择类型', '选择方式', '基本信息', '营养成分', '频率', '时间与剂量', '库存']
      : const ['选择类型', '基本信息', '频率', '时间与剂量', '库存'];

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prefill());
    }
  }

  @override
  void dispose() {
    _aiCtrl.dispose();
    _tplNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _prefill() async {
    if (_prefillDone) return;
    _prefillDone = true;
    final dao = ref.read(daoProvider);
    final med = await dao.getMed(widget.editMedId!);
    if (med == null) return;
    final schedules = await dao.getActiveSchedulesForMed(med.id);
    final ingredients = await dao.ingredientsForMed(med.id);
    if (!mounted) return;
    setState(() {
      _type = MedType.fromCode(med.type);
      _name = med.name;
      _form = med.form;
      _color = med.color;
      _emoji = med.emoji;
      _instruction = med.instruction;
      _note = med.note ?? '';
      _stockOn = med.stockEnabled;
      _stock = med.stockRemaining ?? 60;
      _lowDays = med.lowStockDays;
      if (schedules.isNotEmpty) {
        final s = schedules.first;
        _freq = FreqType.fromCode(s.freqType);
        _weekdays = parseWeekdaysLocal(s.weekdays);
        _intervalDays = s.intervalDays ?? 2;
        _cycleOn = s.cycleOn ?? 5;
        _cycleOff = s.cycleOff ?? 2;
        _slots = decodeSlots(s.times);
        _start = s.startDate;
        _end = s.endDate;
      }
      _ingredients = ingredients
          .map((i) => IngredientDraft(nutrientCode: i.nutrientCode, amountPerUnit: i.amountPerUnit))
          .toList();
    });
  }

  List<int> parseWeekdaysLocal(String? json) {
    if (json == null || json.trim().isEmpty) return const [];
    return json
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',')
        .map(int.tryParse)
        .whereType<int>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leadingWidth: 96,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFE9DB),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: const Text('取消',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ),
          ),
        ),
        title: Text(
          '${_isEdit ? '编辑' : '新增'} · ${_steps[_step]}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _progress(),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _body())),
          _footer(),
        ],
      ),
    );
  }

  Widget _progress() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (var i = 0; i < _steps.length; i++)
              Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= _step ? AppColors.pri : const Color(0xFFE3DBC7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
          ],
        ),
      );

  // ==================== 步骤内容 ====================
  Widget _body() {
    switch (_steps[_step]) {
      case '选择类型':
        return _stepType();
      case '选择方式':
        return _stepFillMode();
      case '基本信息':
        return _stepBasic();
      case '营养成分':
        return _stepIngredients();
      case '频率':
        return _stepFreq();
      case '时间与剂量':
        return _stepTimes();
      case '库存':
        return _stepStock();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _stepType() => Row(
        children: [
          _typeCard(MedType.medicine, '💊', '药品', '处方药 / OTC\n强调疗程与遵医嘱'),
          const SizedBox(width: 12),
          _typeCard(MedType.supplement, '🌿', '保健品', '维生素 / 补剂\n可录入成分对照 DRIs'),
        ],
      );

  Widget _typeCard(MedType t, String emoji, String name, String desc) {
    final sel = _type == t;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _type = t;
          _emoji = t == MedType.medicine ? '💊' : '🌿';
          if (_step >= _steps.length) _step = _steps.length - 1;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFFF4F8EE) : AppColors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: sel ? AppColors.pri : Colors.transparent, width: 2.5),
            boxShadow: const [
              BoxShadow(color: Color(0x125D5040), blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 38)),
              const SizedBox(height: 9),
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.sub)),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== 选择方式（模板 / AI 解析 / 空白） ====================
  Widget _stepFillMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _fillCard('template', '📋', '从模板', '常见配方\n一键填充'),
            const SizedBox(width: 10),
            _fillCard('ai', '🤖', 'AI 解析', '豆包拍图\n识别回贴'),
            const SizedBox(width: 10),
            _fillCard('blank', '✏️', '从空白', '手动填写\n成分'),
          ],
        ),
        const SizedBox(height: 16),
        if (_fillMode == 'template') _templateBrowser(),
        if (_fillMode == 'ai') _aiParsePanel(),
        if (_fillMode == 'blank')
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('点「下一步」直接手动填写成分。',
                style: TextStyle(fontSize: 12, color: AppColors.sub)),
          ),
      ],
    );
  }

  Widget _fillCard(String mode, String emoji, String title, String desc) {
    final sel = _fillMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _fillMode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFFF4F8EE) : AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: sel ? AppColors.pri : Colors.transparent, width: 2.5),
            boxShadow: const [
              BoxShadow(color: Color(0x105D5040), blurRadius: 10, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9.5, color: AppColors.sub)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _templateBrowser() {
    final presetsAsync = ref.watch(presetsProvider);
    final ingList = ref.watch(presetIngredientsProvider).valueOrNull ?? const <ProductPresetIngredientRow>[];
    final nutrients = ref.watch(nutrientsProvider).valueOrNull ?? const <NutrientRow>[];
    final byCode = {for (final n in nutrients) n.code: n};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (v) => setState(() => _tplQuery = v),
          decoration: const InputDecoration(
            hintText: '搜索：复合维生素 / 鱼油 / 品牌…',
            prefixIcon: Icon(Icons.search, size: 20),
          ),
        ),
        const SizedBox(height: 10),
        presetsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('加载失败：$e'),
          data: (presets) {
            final q = _tplQuery.trim().toLowerCase();
            final filtered = presets
                .where((p) =>
                    q.isEmpty ||
                    p.name.toLowerCase().contains(q) ||
                    (p.brand ?? '').toLowerCase().contains(q))
                .toList();
            if (filtered.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('没有匹配的配方？可改用「AI 解析」或「从空白创建」。',
                    style: TextStyle(fontSize: 12, color: AppColors.sub)),
              );
            }
            return Column(
              children: [
                for (final p in filtered)
                  _presetRow(p, ingList.where((i) => i.presetId == p.id).toList(), byCode),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _presetRow(
    ProductPresetRow p,
    List<ProductPresetIngredientRow> ings,
    Map<String, NutrientRow> byCode,
  ) {
    final sel = _selectedPresetId == p.id;
    final preview = ings
        .take(3)
        .map((i) => '${byCode[i.nutrientCode]?.name ?? i.nutrientCode} '
            '${_num(i.amountPerServing)}${byCode[i.nutrientCode]?.unit ?? ''}')
        .join(' · ');
    return GestureDetector(
      onTap: () => _applyTemplate(p, ings),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: sel ? const Color(0xFFF4F8EE) : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sel ? AppColors.pri : AppColors.line, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.fromHex(p.color),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(p.emoji, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                      ),
                      if (!p.isBuiltin) ...[
                        const SizedBox(width: 6),
                        const Text('我的',
                            style: TextStyle(fontSize: 9, color: AppColors.acc, fontWeight: FontWeight.w800)),
                      ],
                      if (sel) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.check_circle, size: 15, color: AppColors.pri),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${ings.length}种成分${preview.isEmpty ? '' : ' · $preview'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: AppColors.sub),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyTemplate(ProductPresetRow p, List<ProductPresetIngredientRow> ings) {
    setState(() {
      _selectedPresetId = p.id;
      _name = (p.brand ?? '').isNotEmpty ? '${p.brand} ${p.name}' : p.name;
      _form = p.form;
      _emoji = p.emoji;
      _color = p.color;
      _ingredients = [
        for (final i in ings)
          IngredientDraft(nutrientCode: i.nutrientCode, amountPerUnit: i.amountPerServing),
      ];
    });
    _snack('已套用「${p.name}」：${ings.length} 项成分，下一步可编辑');
  }

  Widget _aiParsePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF4EFE3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            '① 复制提示词  →  ② 打开豆包/元宝，拍照并粘贴提示词  →  ③ 复制它返回的内容  →  ④ 回到本页粘贴后解析',
            style: TextStyle(fontSize: 11, height: 1.75, color: AppColors.sub),
          ),
        ),
        const SizedBox(height: 12),
        CapsuleButton(label: '📋 复制提示词', kind: CapsuleKind.accent, onPressed: _copyPrompt),
        const SizedBox(height: 14),
        TextField(
          controller: _aiCtrl,
          maxLines: 6,
          minLines: 4,
          decoration: const InputDecoration(hintText: '在此粘贴 AI 返回的 JSON…'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CapsuleButton(label: '粘贴', kind: CapsuleKind.ghost, onPressed: _pasteClipboard),
            const SizedBox(width: 8),
            CapsuleButton(
              label: _aiBusy ? '解析中…' : '🔍 解析',
              onPressed: _aiBusy ? null : _parseAi,
            ),
          ],
        ),
        if (_parseOutcome != null) ...[
          const SizedBox(height: 14),
          _parseResultView(),
        ],
      ],
    );
  }

  Future<void> _copyPrompt() async {
    await Clipboard.setData(const ClipboardData(text: AiPrompt.text));
    _snack('已复制提示词，去豆包拍照识别吧');
  }

  Future<void> _pasteClipboard() async {
    final data = await Clipboard.getData('text/plain');
    final t = data?.text ?? '';
    if (t.isEmpty) {
      _snack('剪贴板为空');
      return;
    }
    setState(() => _aiCtrl.text = t);
  }

  Future<void> _parseAi() async {
    final raw = _aiCtrl.text;
    if (raw.trim().isEmpty) {
      _snack('请先粘贴 AI 返回的内容');
      return;
    }
    setState(() => _aiBusy = true);
    try {
      final parser = await ref.read(aiParserProvider.future);
      final outcome = parser.parse(raw);
      if (!mounted) return;
      setState(() {
        _parseOutcome = outcome;
        _aiBusy = false;
      });
      if (outcome.mergedCount > 0) _snack('已合并 ${outcome.mergedCount} 项同名成分');
    } catch (e) {
      if (mounted) {
        setState(() => _aiBusy = false);
        _snack('解析失败：$e');
      }
    }
  }

  Widget _parseResultView() {
    final o = _parseOutcome!;
    if (o.error != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.badLight, borderRadius: BorderRadius.circular(12)),
        child: Text('解析失败：${o.error}',
            style: const TextStyle(fontSize: 12, color: AppColors.bad, fontWeight: FontWeight.w700)),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '识别到 ${o.items.length} 项${o.mergedCount > 0 ? '（已合并 ${o.mergedCount} 项）' : ''}'
          '${(o.productName ?? '').isNotEmpty ? ' · ${o.productName}' : ''}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < o.items.length; i++) _parsedRow(i, o.items[i]),
        const SizedBox(height: 10),
        CapsuleButton(
          label: '✓ 确认填入（${o.items.length}）',
          expand: true,
          onPressed: o.items.isEmpty ? null : _applyParsed,
        ),
      ],
    );
  }

  Widget _parsedRow(int index, ParsedIngredient it) {
    late final Color bg;
    late final Color fg;
    late final String tag;
    switch (it.status) {
      case ParseItemStatus.matched:
        bg = AppColors.doneTag;
        fg = AppColors.doneInk;
        tag = '✓ 已匹配';
        break;
      case ParseItemStatus.needsConfirm:
        bg = const Color(0xFFFBF0DA);
        fg = const Color(0xFFA0742A);
        tag = '⚠ 需确认';
        break;
      case ParseItemStatus.custom:
        bg = const Color(0xFFE3ECF7);
        fg = const Color(0xFF3B6BA5);
        tag = '＋ 自定义';
        break;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
            child: Text(tag, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: fg)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${it.rawName}${it.code != null ? '  →  ${it.name}' : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                if ((it.note ?? '').isNotEmpty)
                  Text(it.note!, style: const TextStyle(fontSize: 10, color: AppColors.sub)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text('${_num(it.amount)}${it.unit}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.priDark)),
          GestureDetector(
            onTap: () => setState(() => _parseOutcome!.items.removeAt(index)),
            child: const Padding(
              padding: EdgeInsets.only(left: 8, top: 2, bottom: 2),
              child: Icon(Icons.close, size: 15, color: AppColors.bad),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _applyParsed() async {
    final o = _parseOutcome;
    if (o == null || o.items.isEmpty) return;
    final repo = ref.read(presetRepoProvider);
    final drafts = <IngredientDraft>[];
    var createdCustom = false;
    for (final it in o.items) {
      if (it.code != null) {
        drafts.add(IngredientDraft(nutrientCode: it.code!, amountPerUnit: it.amount));
      } else {
        final code = await repo.ensureCustomNutrient(it.name, unit: it.unit);
        createdCustom = true;
        drafts.add(IngredientDraft(nutrientCode: code, amountPerUnit: it.amount));
      }
    }
    if (createdCustom) ref.invalidate(nutrientsProvider);
    if (!mounted) return;
    setState(() {
      _ingredients = drafts;
      if (_name.trim().isEmpty && (o.productName ?? '').isNotEmpty) _name = o.productName!;
    });
    _snack('已填入 ${drafts.length} 项成分，下一步可继续编辑');
  }

  Widget _stepBasic() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('名称 *'),
          TextFormField(
            initialValue: _name,
            onChanged: (v) => _name = v,
            decoration: const InputDecoration(hintText: '如：维生素D3'),
          ),
          _label('剂型'),
          _chips(_formChoices, _form, (v) => setState(() => _form = v)),
          _label('图标'),
          Wrap(
            spacing: 10,
            children: _emojiChoices
                .map((e) => GestureDetector(
                      onTap: () => setState(() => _emoji = e),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _emoji == e ? const Color(0xFFF4F8EE) : AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _emoji == e ? AppColors.pri : AppColors.line,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(e, style: const TextStyle(fontSize: 19)),
                      ),
                    ))
                .toList(),
          ),
          _label('颜色标识'),
          Wrap(
            spacing: 13,
            runSpacing: 10,
            children: _paletteHex
                .map((h) => GestureDetector(
                      onTap: () => setState(() => _color = h),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.fromHex(h),
                          shape: BoxShape.circle,
                          border: _color == h
                              ? Border.all(color: Colors.white, width: 3)
                              : Border.all(color: Colors.transparent, width: 3),
                          boxShadow: _color == h
                              ? [BoxShadow(color: AppColors.pri.withOpacity(0.6), blurRadius: 8, spreadRadius: 1)]
                              : null,
                        ),
                      ),
                    ))
                .toList(),
          ),
          _label('服用说明（可选）'),
          _chips(_instructionChoices, _instruction, (v) {
            setState(() => _instruction = _instruction == v ? null : v);
          }),
        ],
      );

  Widget _stepIngredients() {
    final nutrients = ref.watch(nutrientsProvider).valueOrNull ?? const <NutrientRow>[];
    return _IngredientsEditor(
      nutrients: nutrients,
      drafts: _ingredients,
      onChanged: (list) => setState(() => _ingredients = list),
    );
  }

  Widget _stepFreq() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final f in FreqType.values)
          GestureDetector(
            onTap: () => setState(() => _freq = f),
            child: Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _freq == f ? const Color(0xFFF4F8EE) : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _freq == f ? AppColors.pri : Colors.transparent, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Color(0x105D5040), blurRadius: 10, offset: Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  Text(_freqEmoji(f), style: const TextStyle(fontSize: 21)),
                  const SizedBox(width: 12),
                  Text(f.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        if (_freq == FreqType.weekly) ...[
          _label('选择星期'),
          Wrap(
            spacing: 8,
            children: List.generate(7, (i) {
              final day = i + 1;
              final sel = _weekdays.contains(day);
              return GestureDetector(
                onTap: () => setState(() {
                  if (sel) {
                    _weekdays.remove(day);
                  } else {
                    _weekdays.add(day);
                  }
                }),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFFF4F8EE) : AppColors.card,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: sel ? AppColors.pri : AppColors.line, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text('一二三四五六日'[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: sel ? AppColors.priDark : AppColors.sub,
                      )),
                ),
              );
            }),
          ),
        ],
        if (_freq == FreqType.everyNDays)
          _numberRow('每隔', _intervalDays, (v) => setState(() => _intervalDays = v), '天服用一次'),
        if (_freq == FreqType.cycle)
          Row(
            children: [
              Text('吃', style: _bodyStyle()),
              _numField(_cycleOn, (v) => setState(() => _cycleOn = v)),
              Text('天 · 停', style: _bodyStyle()),
              _numField(_cycleOff, (v) => setState(() => _cycleOff = v)),
              Text('天', style: _bodyStyle()),
            ],
          ),
      ],
    );
  }

  Widget _stepTimes() {
    if (_freq == FreqType.asNeeded) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Text('🆘', style: TextStyle(fontSize: 44)),
            SizedBox(height: 10),
            Text('按需服用不生成计划、不提醒',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.sub)),
            SizedBox(height: 6),
            Text('服用后在药箱点「记一笔」即可',
                style: TextStyle(fontSize: 11, color: AppColors.sub)),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('时间点与单次剂量（支持早晚不同剂量）'),
        for (var i = 0; i < _slots.length; i++) _slotRow(i),
        GestureDetector(
          onTap: () => setState(() => _slots =
              [..._slots, PlanSlot(time: '20:00', dose: 1, unit: _slots.first.unit)]),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.pri,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            alignment: Alignment.center,
            child: const Text('＋ 添加一个时间点',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.priDark)),
          ),
        ),
        _label('开始日期'),
        _dateTile(_start, (d) => setState(() => _start = d)),
        _label('结束日期（留空 = 长期）'),
        _dateTile(_end, (d) => setState(() => _end = d), clearable: true),
      ],
    );
  }

  Widget _slotRow(int i) {
    final slot = _slots[i];
    final time = slot.time.split(':');
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line, width: 2),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1])),
              );
              if (t != null) {
                setState(() => _slots[i] = slot.copyWith(
                      time:
                          '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
                    ));
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EFE3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(slot.time,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: TextFormField(
              initialValue: _num(slot.dose),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 9)),
              onChanged: (v) {
                final d = double.tryParse(v);
                if (d != null && d > 0) setState(() => _slots[i] = slot.copyWith(dose: d));
              },
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: slot.unit,
            underline: const SizedBox.shrink(),
            items: _unitChoices
                .map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: (u) {
              if (u != null) setState(() => _slots[i] = slot.copyWith(unit: u));
            },
          ),
          const Spacer(),
          if (_slots.length > 1)
            GestureDetector(
              onTap: () => setState(() => _slots = [..._slots]..removeAt(i)),
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(color: AppColors.badLight, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Text('✕', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.bad)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stepStock() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('🧮 启用库存追踪',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                const Spacer(),
                Switch(
                  value: _stockOn,
                  activeColor: AppColors.pri,
                  onChanged: (v) => setState(() => _stockOn = v),
                ),
              ],
            ),
          ),
          if (_stockOn) ...[
            _label('当前库存数量'),
            TextFormField(
              initialValue: _num(_stock),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => _stock = double.tryParse(v) ?? _stock,
              decoration: const InputDecoration(hintText: '如 60'),
            ),
            _label('低库存提醒阈值'),
            _chipsInt([3, 7, 14], _lowDays, (v) => setState(() => _lowDays = v), (v) => '剩 $v 天'),
          ] else
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text('不追踪库存时，确认服药不会扣减数量',
                  style: TextStyle(fontSize: 11, color: AppColors.sub)),
            ),
          if (!_isEdit && _type == MedType.supplement) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: [
                  const Text('⭐ 保存为我的模板',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Switch(
                    value: _saveAsTemplate,
                    activeColor: AppColors.pri,
                    onChanged: (v) => setState(() => _saveAsTemplate = v),
                  ),
                ],
              ),
            ),
            if (_saveAsTemplate) ...[
              _label('模板名称'),
              TextField(
                controller: _tplNameCtrl,
                decoration: InputDecoration(
                  hintText: _name.isEmpty ? '如 Swisse 男士复合维生素' : _name,
                ),
              ),
            ],
          ],
        ],
      );

  // ==================== 底部按钮 ====================
  Widget _footer() => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: const BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.line, width: 1.5)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (_step > 0)
                CapsuleButton(
                  label: '上一步',
                  kind: CapsuleKind.ghost,
                  onPressed: () => setState(() => _step--),
                ),
              if (_step > 0) const SizedBox(width: 10),
              Expanded(
                child: CapsuleButton(
                  label: _step == _steps.length - 1
                      ? (_saving ? '保存中…' : '✓ 完成')
                      : '下一步',
                  expand: true,
                  onPressed: _saving ? null : _next,
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _next() async {
    if (_steps[_step] == '基本信息' && _name.trim().isEmpty) {
      _snack('请填写名称');
      return;
    }
    if (_step < _steps.length - 1) {
      setState(() => _step++);
      return;
    }
    await _save();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final slots = _freq == FreqType.asNeeded ? _slots : _slots;
      final draft = MedDraft(
        id: widget.editMedId,
        name: _name.trim(),
        type: _type,
        form: _form,
        color: _color,
        emoji: _emoji,
        instruction: _instruction,
        note: _note.isEmpty ? null : _note,
        stockEnabled: _stockOn,
        stock: _stock,
        lowStockDays: _lowDays,
        freq: _freq,
        weekdays: _weekdays,
        intervalDays: _intervalDays,
        cycleOn: _cycleOn,
        cycleOff: _cycleOff,
        slots: slots,
        unit: slots.first.unit,
        startDate: DateTime(_start.year, _start.month, _start.day),
        endDate: _end,
        ingredients: _type == MedType.supplement ? _ingredients : const [],
      );
      final repo = ref.read(medicationRepoProvider);
      String? newMedId;
      if (_isEdit) {
        await repo.update(draft);
      } else {
        newMedId = await repo.create(draft);
      }
      // 保存为我的模板
      if (newMedId != null && _saveAsTemplate && _type == MedType.supplement) {
        final dao = ref.read(daoProvider);
        final med = await dao.getMed(newMedId);
        final ings = await dao.ingredientsForMed(newMedId);
        if (med != null) {
          await ref.read(presetRepoProvider).saveAsTemplate(
                med: med,
                ingredients: ings,
                name: _tplNameCtrl.text.trim().isEmpty ? _name.trim() : _tplNameCtrl.text.trim(),
              );
        }
      }
      await ref.read(eventControllerProvider).refreshPlan();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) _snack('保存失败：$e');
      setState(() => _saving = false);
    }
  }

  // ==================== 小组件 ====================
  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 17, 2, 9),
        child: Text(text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.sub)),
      );

  TextStyle _bodyStyle() => const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink);

  Widget _chips(List<String> options, String? current, ValueChanged<String> onTap) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options
            .map((o) => GestureDetector(
                  onTap: () => onTap(o),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    decoration: BoxDecoration(
                      color: current == o ? const Color(0xFFF4F8EE) : AppColors.card,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: current == o ? AppColors.pri : AppColors.line, width: 2),
                    ),
                    child: Text(o,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: current == o ? AppColors.priDark : AppColors.sub,
                        )),
                  ),
                ))
            .toList(),
      );

  Widget _chipsInt(List<int> options, int current, ValueChanged<int> onTap, String Function(int) label) =>
      Wrap(
        spacing: 8,
        children: options
            .map((o) => GestureDetector(
                  onTap: () => onTap(o),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    decoration: BoxDecoration(
                      color: current == o ? const Color(0xFFF4F8EE) : AppColors.card,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: current == o ? AppColors.pri : AppColors.line, width: 2),
                    ),
                    child: Text(label(o),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: current == o ? AppColors.priDark : AppColors.sub,
                        )),
                  ),
                ))
            .toList(),
      );

  Widget _numberRow(String pre, int value, ValueChanged<int> onChanged, String post) => Row(
        children: [
          Text(pre, style: _bodyStyle()),
          _numField(value, onChanged),
          Text(post, style: _bodyStyle()),
        ],
      );

  Widget _numField(int value, ValueChanged<int> onChanged) => SizedBox(
        width: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: TextFormField(
            initialValue: '$value',
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 8)),
            onChanged: (v) {
              final n = int.tryParse(v);
              if (n != null && n > 0) onChanged(n);
            },
          ),
        ),
      );

  Widget _dateTile(DateTime? date, ValueChanged<DateTime> onPick, {bool clearable = false}) => GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) onPick(picked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line, width: 2),
          ),
          child: Row(
            children: [
              Text(
                date == null
                    ? '长期 / 未设置'
                    : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: date == null ? AppColors.muted : AppColors.ink,
                ),
              ),
              const Spacer(),
              if (clearable && date != null)
                GestureDetector(
                  onTap: () => setState(() => _end = null),
                  child: const Text('清除',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.bad)),
                )
              else
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.sub),
            ],
          ),
        ),
      );

  String _freqEmoji(FreqType f) {
    switch (f) {
      case FreqType.daily:
        return '📆';
      case FreqType.weekly:
        return '🗓️';
      case FreqType.everyNDays:
        return '🔁';
      case FreqType.cycle:
        return '⏸️';
      case FreqType.asNeeded:
        return '🆘';
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  static String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}

/// 成分编辑器（保健品专属步骤）
class _IngredientsEditor extends StatefulWidget {
  const _IngredientsEditor({
    required this.nutrients,
    required this.drafts,
    required this.onChanged,
  });

  final List<NutrientRow> nutrients;
  final List<IngredientDraft> drafts;
  final ValueChanged<List<IngredientDraft>> onChanged;

  @override
  State<_IngredientsEditor> createState() => _IngredientsEditorState();
}

class _IngredientsEditorState extends State<_IngredientsEditor> {
  late String _sel = widget.nutrients.isNotEmpty ? widget.nutrients.first.code : '';
  late String _unit = _unitOf(_sel);
  final TextEditingController _amt = TextEditingController();

  NutrientRow? _byCode(String code) =>
      widget.nutrients.where((n) => n.code == code).firstOrNull;

  String _unitOf(String code) => _byCode(code)?.unit ?? '';

  @override
  void dispose() {
    _amt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final byCode = {for (final n in widget.nutrients) n.code: n};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final d in widget.drafts)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Color(0x105D5040), blurRadius: 10, offset: Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                Text(byCode[d.nutrientCode]?.name ?? d.nutrientCode,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                Text('${_num(d.amountPerUnit)} ${byCode[d.nutrientCode]?.unit ?? ''}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sub)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    final list = [...widget.drafts]
                      ..removeWhere((x) => x.nutrientCode == d.nutrientCode);
                    widget.onChanged(list);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(color: AppColors.badLight, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Text('✕',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.bad)),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        // 成分选择（下拉较长，含 Emoji 便于辨认）
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line, width: 2),
          ),
          child: DropdownButton<String>(
            value: _sel.isEmpty ? null : _sel,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            items: widget.nutrients
                .map((n) => DropdownMenuItem(
                      value: n.code,
                      child: Text('${n.emoji} ${n.name}（${n.unit}）',
                          style: const TextStyle(fontSize: 12)),
                    ))
                .toList(),
            onChanged: (v) => setState(() {
              _sel = v ?? _sel;
              _unit = _unitOf(_sel);
            }),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 96,
              child: TextField(
                controller: _amt,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: '含量'),
              ),
            ),
            const SizedBox(width: 8),
            if (_byCode(_sel)?.altUnit != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.line, width: 2),
                ),
                child: DropdownButton<String>(
                  value: _unit,
                  underline: const SizedBox.shrink(),
                  items: [_byCode(_sel)!.unit, _byCode(_sel)!.altUnit!]
                      .map((u) => DropdownMenuItem(
                            value: u,
                            child: Text(u, style: const TextStyle(fontSize: 12)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _unit = v ?? _unit),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(_byCode(_sel)?.unit ?? '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.sub)),
              ),
            const Spacer(),
            CapsuleButton(label: '添加', onPressed: _add),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF4EFE3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            '💡 按包装「营养成分表 / 配料表」逐项填写。\n'
            '维生素D/A/E 可直接按 IU 填写（如维生素D 1000IU 会自动换算为 25μg）。\n'
            '「其他膳食成分 / 其他成分」为仅记录，不与 DRIs 对比。\n'
            '不录入成分也可使用，只是不参与营养摄入统计。',
            style: TextStyle(fontSize: 10.5, height: 1.7, color: AppColors.sub),
          ),
        ),
      ],
    );
  }

  void _add() {
    final cur = _byCode(_sel);
    final amt = double.tryParse(_amt.text);
    if (cur == null || amt == null || amt <= 0) return;
    // 若按 altUnit（如 IU）填写，换算为规范单位
    final canonical = (cur.altUnit != null && _unit == cur.altUnit && cur.altFactor != null)
        ? amt * cur.altFactor!
        : amt;
    final list = [...widget.drafts]..removeWhere((x) => x.nutrientCode == _sel);
    list.add(IngredientDraft(nutrientCode: _sel, amountPerUnit: canonical));
    widget.onChanged(list);
    _amt.clear();
  }

  static String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
