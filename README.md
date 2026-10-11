# 用药记（cyjl / nodie）

吃药 + 保健品 **统一记录** App：到点提醒、一键记服、库存管理，并把保健品的**摄入成分与中国营养学会 DRIs（2023）推荐量对比**进可视化。

> 个人自用工具 · Flutter · 本地优先（数据不出设备）

## ✨ 功能

- **今日行动中心**：植物养成 Hero（连续打卡 = 灌溉 🌱→🌿→🪴→🌻）+ 待办卡片一键「已服用 / 跳过」
- **闭环提醒**：到点本地通知，通知上直接【✓ 已服用】/【💤 稍后】，**无需打开 App 即完成记录与库存扣减**
- **服用计划**：5 种频率（每天 / 每周指定日 / 每隔 N 天 / 吃 N 停 M / 按需），支持早晚不同剂量
- **四状态记录**：已服用 / 跳过 / 漏服 / 待确认，历史留痕、可补记
- **营养摄入对比**：保健品录入成分（每粒含 XX μg），自动汇总当日摄入，对照 **DRIs 2023** 的 RNI/AI/UL 双刻度进度条，超上限预警；支持人群档案（成年男/女）
- **库存**：确认即扣减，低库存横幅提醒
- **记录统计**：日历热力（绿/黄/红）、7/30 天依从率、按药品依从率
- **数据**：CSV 导出、清空；完全本地存储
- **检查更新**：应用内查询 GitHub Release，有新版本可下载 APK 并调起安装

## 🛠 技术栈

Flutter 3.24 / Dart 3.5 · Riverpod · Drift(SQLite) · flutter_local_notifications + timezone · package_info_plus / http / url_launcher / open_filex

分层架构（见 `docs/tech-architecture.md`）：`features/`(UI) → `app/providers.dart`(状态) → `domain/services.dart`(纯 Dart 业务) → `data/`(Drift) + `notifications/`(可注入网关)。

## 🚀 构建

```powershell
$env:PATH = "<flutter-sdk>\bin;<flutter-sdk>\bin\cache\dart-sdk\bin;" + $env:PATH
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # 改表/DAO 后
flutter analyze
flutter test
flutter run                      # 真机/模拟器
flutter build apk --release      # 打包
```

## 🔄 发布与更新

1. 修改 `pubspec.yaml` 的 `version: x.y.z+n`
2. 打 tag 并推送：`git tag vx.y.z && git push origin vx.y.z`
3. GitHub Actions（`.github/workflows/release.yml`）自动 `flutter build apk --release` 并创建 Release、上传 `app-release.apk`
4. 用户端「设置 → 检查更新」读取 `releases/latest`，比较版本后可直接下载安装

> 首次发布前请在仓库的 Actions 权限中允许 `contents: write`（工作流已声明）。

## ⚠️ 免责声明

本应用仅提供服用提醒与记录功能，营养素参考值来源于公开标准，**不构成医疗建议、诊断或治疗依据**。所有用药请遵医嘱，请勿根据本记录自行调整剂量或停药。
