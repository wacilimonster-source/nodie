import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/repositories/medication_repository.dart';
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

  bool get _isEdit => widget.editMedId != null;

  List<String> get _steps => _type == MedType.supplement
      ? const ['选择类型', '基本信息', '营养成分', '频率', '时间与剂量', '库存']
      : const ['选择类型', '基本信息', '频率', '时间与剂量', '库存'];

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prefill());
    }
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
      if (_isEdit) {
        await repo.update(draft);
      } else {
        await repo.create(draft);
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
  final TextEditingController _amt = TextEditingController();

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
        Row(
          children: [
            Expanded(
              child: Container(
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
                            child: Text('${n.name}（${n.unit}）', style: const TextStyle(fontSize: 12)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _sel = v ?? _sel),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _amt,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: '含量'),
              ),
            ),
            const SizedBox(width: 8),
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
            '💡 查看产品包装上的「营养成分表 / 配料表」逐项填写。\n'
            '例如某品牌维生素D3标注「每粒含维生素D 25μg（1000IU）」，即选「维生素D」填 25。\n'
            '不录入成分也可使用，只是不参与营养摄入统计。',
            style: TextStyle(fontSize: 10.5, height: 1.7, color: AppColors.sub),
          ),
        ),
      ],
    );
  }

  void _add() {
    final amt = double.tryParse(_amt.text);
    if (amt == null || amt <= 0) return;
    final list = [...widget.drafts]..removeWhere((x) => x.nutrientCode == _sel);
    list.add(IngredientDraft(nutrientCode: _sel, amountPerUnit: amt));
    widget.onChanged(list);
    _amt.clear();
  }

  static String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
