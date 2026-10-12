import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'package:cyjl/app/providers.dart';
import 'package:cyjl/app/theme/app_colors.dart';
import 'package:cyjl/core/date_utils.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/core/format.dart';
import 'package:cyjl/features/update/update_service.dart';
import 'package:cyjl/notifications/notification_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cyjl/shared/widgets/page_scaffold.dart';
import 'package:cyjl/shared/widgets/section_title.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return PageScaffold(
      title: '设置',
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SectionTitle('营养参考'),
          _group([
            _row(
              context,
              icon: '🧍',
              title: '人群档案（DRIs 取值）',
              value: '${settings.profile.label} ›',
              onTap: () => ref.read(settingsProvider.notifier).setProfile(
                    settings.profile == ProfileType.male ? ProfileType.female : ProfileType.male,
                  ),
            ),
          ]),
          const SectionTitle('提醒'),
          _group([
            _switchRow(
              icon: '🔔',
              title: '服用提醒',
              value: settings.notificationsEnabled,
              onChanged: (v) async {
                await ref.read(settingsProvider.notifier).setNotifications(v);
                if (v) await NotificationService.requestPermission();
              },
            ),
            _row(
              context,
              icon: '⏳',
              title: '漏服确认窗口',
              value: '${settings.confirmWindowHours} 小时 ›',
              onTap: () => _pickWindow(context, ref, settings.confirmWindowHours),
            ),
            _row(
              context,
              icon: '💤',
              title: '稍后提醒时长',
              value: '${settings.snoozeMinutes} 分钟 ›',
              onTap: () => _pickSnooze(context, ref, settings.snoozeMinutes),
            ),
          ]),
          const SectionTitle('系统权限（Android 保活）'),
          _group([
            _row(
              context,
              icon: '🔔',
              title: '通知权限',
              value: '点此申请 ›',
              onTap: () async {
                final ok = await NotificationService.requestPermission();
                if (context.mounted) {
                  _toast(context, ok ? '通知权限已开启' : '请在系统设置中允许通知');
                }
              },
            ),
            _row(
              context,
              icon: '🔋',
              title: '电池优化白名单',
              value: '去开启 ›',
              onTap: () => _toast(context, '请在系统设置 → 应用 → 电池优化中允许「用药记」后台运行'),
            ),
            _row(
              context,
              icon: '🛡️',
              title: '国产 ROM 保活引导',
              value: '查看 ›',
              onTap: () => _toast(context, '小米/华为/OPPO/vivo：设置 → 应用启动管理中允许自启动与后台运行'),
            ),
          ]),
          const SectionTitle('数据'),
          _group([
            _row(
              context,
              icon: '📤',
              title: '导出记录 CSV',
              value: '→',
              onTap: () => _exportCsv(context, ref),
            ),
            _row(
              context,
              icon: '🗑️',
              title: '清空全部数据',
              value: '›',
              valueColor: AppColors.bad,
              onTap: () => _clearAll(context, ref),
            ),
          ]),
          const SectionTitle('关于'),
          _group([
            _row(
              context,
              icon: '🔄',
              title: '检查更新',
              value: '检查 ›',
              onTap: () => _checkUpdate(context),
            ),
            _versionRow(context),
          ]),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '⚠️ 免责声明：本应用仅提供服用提醒与记录功能，营养素参考值来源于公开标准，不构成医疗建议、诊断或治疗依据。所有用药请遵医嘱，请勿根据本应用记录自行调整剂量或停药。数据仅存储于您的设备本地。',
              style: TextStyle(fontSize: 10.5, height: 1.8, color: AppColors.sub),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _group(List<Widget> children) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x105D5040), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++)
              Container(
                decoration: BoxDecoration(
                  border: i == 0
                      ? null
                      : const Border(top: BorderSide(color: Color(0xFFF3EDE0), width: 1.5)),
                ),
                child: children[i],
              ),
          ],
        ),
      );

  Widget _row(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    VoidCallback? onTap,
    Color? valueColor,
  }) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.priLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(icon, style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.sub,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _switchRow({
    required String icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.priLight,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
            const Spacer(),
            Switch(
              value: value,
              activeColor: AppColors.pri,
              onChanged: onChanged,
            ),
          ],
        ),
      );

  Future<void> _pickWindow(BuildContext context, WidgetRef ref, int current) async {
    final v = await _pickOption(context, '漏服确认窗口', [1, 2, 4, 6, 8, 12], current, (x) => '$x 小时');
    if (v != null) await ref.read(settingsProvider.notifier).setConfirmWindow(v);
  }

  Future<void> _pickSnooze(BuildContext context, WidgetRef ref, int current) async {
    final v = await _pickOption(context, '稍后提醒时长', [5, 10, 15, 30], current, (x) => '$x 分钟');
    if (v != null) await ref.read(settingsProvider.notifier).setSnooze(v);
  }

  Future<int?> _pickOption(
    BuildContext context,
    String title,
    List<int> options,
    int current,
    String Function(int) label,
  ) =>
      showDialog<int>(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          children: options
              .map(
                (o) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, o),
                  child: Row(
                    children: [
                      Text(label(o), style: const TextStyle(fontWeight: FontWeight.w600)),
                      if (o == current) ...[
                        const Spacer(),
                        const Icon(Icons.check, color: AppColors.pri, size: 18),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      );

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      final dao = ref.read(daoProvider);
      final now = DateTime.now();
      final events = await dao.eventsInRange(
        ymd(now.subtract(const Duration(days: 90))),
        ymd(now),
      );
      final meds = {for (final m in await dao.getAllMeds()) m.id: m.name};
      final rows = <List<String>>[
        ['日期', '计划时间', '药品/保健品', '计划剂量', '状态', '实际时间', '备注'],
        for (final e in events)
          [
            e.planDate,
            e.planTime,
            meds[e.medicationId] ?? '',
            _num(e.planDose),
            EventStatus.fromCode(e.status).label,
            e.actualAt == null ? '' : fmtHM(DateTime.fromMillisecondsSinceEpoch(e.actualAt!)),
            e.note ?? '',
          ],
      ];
      final csvText = const ListToCsvConverter().convert(rows);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/用药记_记录_${ymd(now)}.csv');
      await file.writeAsString('\uFEFF$csvText');
      await Share.shareXFiles([XFile(file.path, mimeType: 'text/csv')], subject: '用药记记录导出');
    } catch (e) {
      if (context.mounted) _toast(context, '导出失败：$e');
    }
  }

  Future<void> _clearAll(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空全部数据', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('将删除全部药品、计划与记录，且不可恢复。确定继续吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('清空', style: TextStyle(color: AppColors.bad, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(daoProvider).clearAll();
      await ref.read(eventControllerProvider).refreshPlan();
      if (context.mounted) _toast(context, '已清空全部数据');
    }
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _versionRow(BuildContext context) => FutureBuilder<String>(
        future: PackageInfo.fromPlatform().then((i) => i.version).catchError((_) => '1.0.0'),
        builder: (context, snap) => _row(
          context,
          icon: 'ℹ️',
          title: '当前版本',
          value: 'v${snap.data ?? '…'}',
        ),
      );

  Future<void> _checkUpdate(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context, rootNavigator: true);
    void closeLoading() {
      if (nav.canPop()) nav.pop();
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final svc = UpdateService();
      final current = await svc.currentVersion();
      final latest = await svc.fetchLatest();
      closeLoading();

      if (latest == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('检查更新失败或暂无发布版本，请检查网络后重试')),
        );
        return;
      }
      if (!svc.isNewer(latest.version, current)) {
        messenger.showSnackBar(SnackBar(content: Text('已是最新版本 v$current')));
        return;
      }
      if (!context.mounted) return;

      final action = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('发现新版本 ${latest.tag}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('当前 v$current → 最新 ${latest.tag}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                if (latest.notes.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(latest.notes, style: const TextStyle(fontSize: 12, height: 1.6)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, 'later'), child: const Text('稍后')),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'browser'),
              child: const Text('浏览器打开'),
            ),
            if (latest.apkUrls.isNotEmpty)
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'download'),
                child: const Text('下载更新', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
          ],
        ),
      );

      if (action == 'browser') {
        await svc.openReleasePage(latest.htmlUrl);
      } else if (action == 'download' && latest.apkUrls.isNotEmpty && context.mounted) {
        await _downloadAndInstall(context, svc, latest.apkUrls);
      }
    } catch (e) {
      closeLoading();
      messenger.showSnackBar(SnackBar(content: Text('检查更新失败：$e')));
    }
  }

  Future<void> _downloadAndInstall(
    BuildContext context,
    UpdateService svc,
    List<String> urls,
  ) async {
    final nav = Navigator.of(context, rootNavigator: true);
    final messenger = ScaffoldMessenger.of(context);
    final progress = ValueNotifier<double?>(null);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => AlertDialog(
        title: const Text('正在下载更新'),
        content: ValueListenableBuilder<double?>(
          valueListenable: progress,
          builder: (_, v, __) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('请保持网络连接…', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: v),
              const SizedBox(height: 6),
              Text(v == null ? '' : '${(v * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
    try {
      final file = await svc.downloadApk(
        urls,
        onProgress: (r, t) {
          if (t > 0) progress.value = r / t;
        },
      );
      if (nav.canPop()) nav.pop();
      await svc.installApk(file);
    } catch (e) {
      if (nav.canPop()) nav.pop();
      messenger.showSnackBar(SnackBar(content: Text('下载失败：$e')));
    }
  }

  static String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
