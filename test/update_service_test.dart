import 'package:flutter_test/flutter_test.dart';
import 'package:cyjl/features/update/update_service.dart';

void main() {
  group('ReleaseInfo.fromJson', () {
    test('mirrors 优先、apk 兜底，版本号归一化', () {
      final info = ReleaseInfo.fromJson({
        'version': 'v1.2.0',
        'tag': 'v1.2.0',
        'notes': 'hi',
        'apk': 'https://github.com/x/y/releases/download/v1.2.0/app-release.apk',
        'mirrors': ['https://ghproxy.net/https://github.com/x/y/a.apk'],
        'htmlUrl': 'https://github.com/x/y',
      });
      expect(info.version, '1.2.0');
      expect(info.apkUrls.length, 2);
      expect(info.apkUrls.first, startsWith('https://ghproxy.net/'));
      expect(info.apkUrls.last, startsWith('https://github.com/'));
      expect(info.notes, 'hi');
    });

    test('无 mirrors 时只用 apk，tag 自动补 v', () {
      final info = ReleaseInfo.fromJson({
        'version': '2.0.0',
        'apk': 'https://a/b.apk',
      });
      expect(info.apkUrls, ['https://a/b.apk']);
      expect(info.tag, 'v2.0.0');
    });
  });

  group('isNewer', () {
    final svc = UpdateService();
    test('语义化比较', () {
      expect(svc.isNewer('1.2.0', '1.1.0'), isTrue);
      expect(svc.isNewer('1.1.0', '1.1.0'), isFalse);
      expect(svc.isNewer('1.0.9', '1.1.0'), isFalse);
      expect(svc.isNewer('2.0.0', '1.9.9'), isTrue);
      expect(svc.isNewer('1.1.1', '1.1.0'), isTrue);
    });

    test('忽略 build 号与前后缀', () {
      expect(svc.isNewer('1.2.0+5', '1.2.0+1'), isFalse);
      expect(svc.isNewer('v1.2.0', '1.2.0'), isFalse);
    });
  });
}
