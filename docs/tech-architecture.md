# 技术架构设计文档（用药记 V1.0）

> 版本：v1.0 · 2026-10-11 · 配套《产品设计文档 v2.0》
> 目标平台：Android（优先）/ iOS · Flutter 3.24 / Dart 3.5

---

## 1. 总体架构（分层）

```
┌─────────────────────────────────────────────┐
│  Presentation（features/）                     │
│  今日 / 营养 / 记录 / 药箱 / 设置 · 向导 · 详情   │  ← ConsumerWidget，只读 Provider
├─────────────────────────────────────────────┤
│  State（Riverpod Providers）                  │
│  StreamProvider ← Drift watch()               │  ← 单向数据流：DB 写 → 流自动推 UI
│  FutureProvider ← 计算营养汇总/统计            │
│  StateNotifier ← 事件 Controller              │
├─────────────────────────────────────────────┤
│  Domain（domain/services/）                   │
│  EventGenerator  MissedMarking  StockService  │  ← 纯 Dart，可单测
│  NutritionService  PlantService  SettingsSvc  │
├─────────────────────────────────────────────┤
│  Data（data/）                                │
│  Drift DAO(4) ─ SQLite(5 表 + DRIs 种子)       │
│  SharedPreferences（设置）                     │
├─────────────────────────────────────────────┤
│  Platform（notifications/）                   │
│  flutter_local_notifications + timezone       │
│  通知调度 / Action 后台处理 / 开机重排          │
└─────────────────────────────────────────────┘
```

原则：**UI 不直接写库**（全部经 Riverpod Controller → Repository/DAO）；**业务规则全部纯 Dart**（不依赖 Flutter widget，方便单测）；**DB 写操作旁路触发通知重排**（写后即调 NotificationService.reschedule）。

## 2. 技术选型（最终）

| 层 | 选型 | 说明 |
|---|---|---|
| UI | Flutter 3.24 + Material 3（自定义主题） | 自然活力设计语言全部走主题 token |
| 状态管理 | flutter_riverpod (2.x) | StreamProvider 天然适配 Drift |
| 本地库 | drift + drift_flutter + sqlite3_flutter_libs | 类型安全 SQL、流式查询、迁移框架 |
| 通知 | flutter_local_notifications 17.x + timezone + flutter_timezone | 本地通知、Action 按钮、精确闹钟、设备时区 |
| 设置 | shared_preferences | 人群档案/确认窗口等 |
| 导出 | csv + share_plus + path_provider | CSV 导出走系统分享 |
| 码生成 | drift_dev + build_runner | 表/DAO 生成 `.g.dart` |
| 测试 | flutter_test（drift NativeDatabase.memory） | 单测+集成测试 |

**明确不用**：go_router（5 Tab + 少量 push 用内置 Navigator 足够，少一层路由 DSL）；fl_chart（营养双刻度条用 CustomPaint 自绘）；任何联网包（V1.0 零网络权限即可运行，隐私合规）。

## 3. 目录结构

```
lib/
├── main.dart                      # 初始化：DB/通知/时区/ProviderScope
├── app/
│   ├── app.dart                   # MaterialApp + 主题 + 根导航(CapsuleNav)
│   └── theme/
│       ├── app_colors.dart        # Design Tokens（奶油/苔藓绿/陶土/蜂蜜）
│       ├── app_shapes.dart        # 圆角/胶囊常量
│       ├── app_text.dart          # 字阶
│       └── app_theme.dart         # ThemeData 组装
├── core/
│   ├── enums.dart                 # MedType/FreqType/EventStatus/PlantStage
│   ├── date_utils.dart            # 计划匹配、日期键 yyyy-MM-dd
│   └── format.dart                # 剂量/百分比格式化
├── data/
│   ├── database/
│   │   ├── tables.dart            # 5 表（meds/schedules/events/ingredients/nutrients）
│   │   ├── app_database.dart      # _$AppDatabase + 迁移 + beforeOpen 种子
│   │   ├── daos.dart              # 4 个 DatabaseAccessor
│   │   └── nutrient_seed.dart     # DRIs 2023 内置字典（9 项）
│   └── repositories/
│       ├── medication_repository.dart   # 药+计划+成分 事务写
│       ├── event_repository.dart        # 事件读写/确认/撤销
│       └── settings_repository.dart    # SharedPreferences
├── domain/
│   ├── nutrient.dart              # 营养素领域模型(带 DRIs 取值)
│   └── services/
│       ├── event_generator.dart   # 计划→事件 幂等生成
│       ├── missed_marker.dart     # 漏服判定
│       ├── stock_service.dart     # 扣减/回补/低库存
│       ├── nutrition_service.dart # 当日摄入汇总 vs DRIs
│       └── plant_service.dart     # streak/植物阶段
├── notifications/
│   └── notification_service.dart  # 初始化/调度/Action/开机
├── features/
│   ├── today/ nutrition/ history/ cabinet/ settings/   # 各 Tab
│   ├── med_detail/                # 详情子页
│   └── add_med/                   # 新增向导（含成分录入）
├── shared/widgets/                # 胶囊按钮/剂量卡/营养条/植物Hero/日历/胶囊导航
└── generated?                     # 无，生成文件与源同目录 .g.dart
```

## 4. 核心机制

### 4.1 事件生成（EventGenerator）
输入：schedules（激活）× 日期区间 `[today, today+6]`（滚动 7 天，同时满足通知调度上限）。
规则（按 freq_type）：
- `daily`：每天
- `weekly`：weekdays 含目标 weekday
- `every_n_days`：`(date - start_date).days % interval == 0`
- `cycle`：`(date - start_date).days % (on+off) < on`
- `as_needed`：不生成
幂等键：`(schedule_id, plan_date, plan_time)` 唯一 → `insertOnConflictUpdate(doNothing)`。
触发时机：App 启动、计划增改、每日 00:10 本地闹钟。App 数天未开时启动补生成（历史事件一并补齐，保证日历连续）。

### 4.2 漏服判定（MissedMarker）
`status=pending` 且 `计划时刻 < now - 确认窗口(默认4h)` → 批量改 `missed`。触发：App 启动 + 前台 resume。

### 4.3 通知与 Action（闭环）
- 每个 pending 事件在计划时刻注册**本地通知**：标题「该吃药啦」正文「药名 剂量 说明」，Action 按钮：`✓已服用`（payload `take|eventId`）/ `💤稍后`（`snooze|eventId`）。
- 点击通知主体 → 打开 App 到今日页。
- **后台 Action**：`onDidReceiveBackgroundNotificationResponse`（`@pragma('vm:entry-point')`）在后台 isolate 独立开库执行标记 + 库存扣减，再发一条"已记录 ✓"确认通知；App 未开也能完成闭环。
- 稍后：10 分钟后重发同事件一次（可配）。
- **开机/时区变化恢复**：AndroidManifest 注册 `ScheduledNotificationBootReceiver`；App 启动即全量重排。
- Android 12+：`SCHEDULE_EXACT_ALARM`/`USE_EXACT_ALARM` + `AndroidScheduleMode.exactAllowWhileIdle`；Android 13+ `requestNotificationsPermission`。设置页提供国产 ROM 保活图文引导。

### 4.4 营养计算（NutritionService）
```
当日摄入[nutrient] = Σ(event.taken × ingredient.amount_per_unit)
```
三档状态：`<RNI` 未达标（蜂蜜黄填充）/ `≥RNI` 达标（苔藓绿）/ `>UL` 超上限（陶红 + 保守文案）；`≥0.8UL` 附"接近上限"提示。人群档案决定 RNI 取值（铁 12/20mg、维A 800/700μgRAE）。
分子分母均来自 SQLite 单查询 + 内存聚合（数据量 < 千行，无需预聚合表）。

### 4.5 植物养成（PlantService）
streak = 连续"当日全部确认且无 missed"天数；阶段：0-3 🌱 / 4-13 🌿 / 14-29 🪴 / 30+ 🌻。当日全确认 → 浇水中（hero 文案 + 进度条渐变填充）。

## 5. 状态管理映射

| Provider | 类型 | 来源 |
|---|---|---|
| `appDatabaseProvider` | Provider | 单例 AppDatabase |
| `repositoryProvider` | Provider | Repository 组合 |
| `medicationsProvider` | StreamProvider | medications watch() |
| `schedulesProvider` | StreamProvider | schedules watch() |
| `todayEventsProvider` | StreamProvider | events WHERE plan_date=today |
| `nutritionSummaryProvider` | FutureProvider | depends(todayEvents, meds, profile) |
| `settingsProvider` | StateNotifierProvider | SharedPreferences |
| `eventControllerProvider` | Provider(Controller) | mark/skip/undo/fixMissed |

写路径：`UI → Controller → Repository(事务) → Drift streams 自动推 UI + NotificationService.reschedule()`。

## 6. 测试策略

| 层 | 手段 |
|---|---|
| 事件生成 | Drift in-memory，断言 5 种频率 × 区间生成/幂等/补生成 |
| 漏服判定 | 构造 pending + 时间差，断言边界（=window 不判、>window 判） |
| 库存 | 扣减/回补/低库存边界 |
| 营养计算 | 多产品×多剂量汇总、人群切换（铁 12→20）、UL 提示 |
| Widget | NutrientBar 双刻度渲染、DoseCard 超时态、PlantStage 文案 |
| 通知 | 仅测调度参数组装（payload/时间），设备实测列入 §7 |

## 7. 已知限制与设备验证清单（本仓库 CI 无法覆盖）

1. 通知后台 Action 落库（真机验证：杀进程后点【已服用】）
2. 精确闹钟/开机恢复（各 ROM 表现差异，尤其国产机）
3. iOS Action 分组（DarwinNotificationCategory）与角标
4. sqlite3_flutter_libs 真机加载
5. UI 走查：手感/动效/字体渲染

以上 5 项在首次真机安装后逐项核对（见 AGENTS.md「设备验收清单」）。

## 8. 可扩展预留（对应设计文档路线图）

- 云同步：所有表 uuid 主键 + `updated_at` + `is_deleted`，V1.5 加 Supabase/PowerSync 不改表
- 闭环追提醒：事件表加 `followup_count`，通知 Action 增加"稍后"阶梯即可
- 相互作用规则库： nutrients 字典 + 静态规则 JSON（本地）
