/// 药品/保健品类型
enum MedType {
  medicine('medicine', '药', '药品'),
  supplement('supplement', '保', '保健品');

  const MedType(this.code, this.shortLabel, this.label);
  final String code;
  final String shortLabel;
  final String label;

  static MedType fromCode(String code) =>
      MedType.values.firstWhere((e) => e.code == code, orElse: () => MedType.medicine);
}

/// 服用频率模式
enum FreqType {
  daily('daily', '每天', '每日固定时间服用'),
  weekly('weekly', '每周指定日', '如每周一、三、五'),
  everyNDays('every_n_days', '每隔 N 天', '适合隔天服用等'),
  cycle('cycle', '周期循环', '吃 N 天停 M 天'),
  asNeeded('as_needed', '按需服用', '不提醒，随吃随记');

  const FreqType(this.code, this.label, String desc);

  final String code;
  final String label;

  static FreqType fromCode(String code) =>
      FreqType.values.firstWhere((e) => e.code == code, orElse: () => FreqType.daily);
}

/// 服用事件状态（四终态）
enum EventStatus {
  pending('pending', '待确认'),
  taken('taken', '已服用'),
  skipped('skipped', '已跳过'),
  missed('missed', '漏服');

  const EventStatus(this.code, this.label);

  final String code;
  final String label;

  static EventStatus fromCode(String code) =>
      EventStatus.values.firstWhere((e) => e.code == code, orElse: () => EventStatus.pending);

  bool get isConfirmed => this != EventStatus.pending;
}

/// 人群档案（DRIs 取值）
enum ProfileType {
  male('adult_male', '成年男性'),
  female('adult_female', '成年女性');

  const ProfileType(this.code, this.label);

  final String code;
  final String label;

  static ProfileType fromCode(String code) =>
      ProfileType.values.firstWhere((e) => e.code == code, orElse: () => ProfileType.male);
}

/// 植物成长阶段（每日灌溉游戏化）
enum PlantStage {
  seed('🌱', '种子', 0),
  sprout('🌿', '发芽', 4),
  lush('🪴', '茁壮', 14),
  bloom('🌻', '盛开', 30);

  const PlantStage(this.emoji, this.label, this.minStreak);

  final String emoji;
  final String label;
  final int minStreak;

  static PlantStage forStreak(int streak) {
    PlantStage stage = PlantStage.seed;
    for (final s in PlantStage.values) {
      if (streak >= s.minStreak) stage = s;
    }
    return stage;
  }
}
