# AGENTS.md — 用药记（cyjl）

吃药 / 保健品记录 + 营养素 DRIs 对比 App（Flutter，个人自用，本地优先）。

## 环境
- Flutter SDK: `G:\game\nw\flutter\flutter`（3.24.0 stable / Dart 3.5.0）
- 命令前需把 SDK 加入 PATH（当前 shell 未全局安装）：
  ```powershell
  $env:PATH = "G:\game\nw\flutter\flutter\bin;G:\game\nw\flutter\flutter\bin\cache\dart-sdk\bin;" + $env:PATH
  ```

## 常用命令
```powershell
flutter pub get                                    # 安装依赖
dart run build_runner build --delete-conflicting-outputs   # Drift 代码生成（改表/DAO 后必跑）
flutter analyze                                    # 静态检查（应 0 issue）
flutter test                                       # 单元 + 组件测试
flutter run                                        # 真机/模拟器运行
flutter build apk --release                        # 打包 Android（需 Android SDK）
```

## 关键约定
- 改 `lib/data/database/tables.dart` / `daos.dart` 后必须重跑 build_runner。
- 行类（MedicationRow 等）生成在 `app_database.g.dart`，通过 `import app_database.dart` 使用；`tables.dart` 只放表定义（无 part）。
- 业务规则全部在 `lib/domain/services.dart`（纯 Dart，可注入 `now` 便于测试）。
- UI 只读 Riverpod Provider，写操作走 `EventController` / Repository；DB 写后调用 `refreshPlan()` 重排通知。
- 设计令牌集中在 `lib/app/theme/`，勿在页面写死颜色/圆角。

## 设备验收清单（CI 覆盖不到，需真机）
1. 杀进程后点通知【✓ 已服用】→ 打开 App 该条已为「已服用」、库存已扣减
2. 点【💤 稍后】→ 10 分钟后再次提醒
3. 重启手机 → 通知仍能按时触发（ScheduledNotificationBootReceiver）
4. Android 13 / 12 的通知权限与精确闹钟授权
5. 国产 ROM 电池优化白名单（设置页有引导文案）
6. 新增保健品 → 次日到点提醒；确认服用 → 营养页进度条增长

## 文档
- 产品设计：`docs/product-design.md`
- 技术架构：`docs/tech-architecture.md`
- 交互原型：`prototype/index.html`（浏览器直接打开）
