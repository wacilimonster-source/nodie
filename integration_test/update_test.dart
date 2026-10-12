import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cyjl/features/update/update_service.dart';

/// 验证「检查更新」在设备网络下可用（优先国内源 jsDelivr）。
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('可获取最新版本信息（jsDelivr 优先，GitHub API 兜底）', (tester) async {
    final svc = UpdateService();
    final info = await svc.fetchLatest();
    expect(info, isNotNull, reason: '应能从 jsDelivr 或 GitHub API 获取版本信息');
    expect(info!.version, isNotEmpty);
    expect(info.apkUrls, isNotEmpty);
    // ignore: avoid_print
    print('LATEST tag=${info.tag} version=${info.version} urls=${info.apkUrls.length}');
    // ignore: avoid_print
    print('FIRST_URL=${info.apkUrls.first}');
  });
}
