import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// 一个可用的发布信息
class ReleaseInfo {
  const ReleaseInfo({
    required this.version,
    required this.tag,
    required this.title,
    required this.notes,
    required this.htmlUrl,
    this.apkUrl,
  });

  final String version; // 规范化版本，如 1.2.0
  final String tag; // 原始 tag，如 v1.2.0
  final String title;
  final String notes;
  final String htmlUrl;
  final String? apkUrl; // assets 中的 .apk 下载地址
}

/// 从 GitHub Releases 检查更新
class UpdateService {
  UpdateService({this.owner = 'wacilimonster-source', this.repo = 'nodie'});

  final String owner;
  final String repo;

  String get _latestApi => 'https://api.github.com/repos/$owner/$repo/releases/latest';
  String get releasesPage => 'https://github.com/$owner/$repo/releases/latest';

  /// 当前安装版本（读取 pubspec version）
  Future<String> currentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /// 拉取最新 release；仓库暂无 release 时返回 null
  Future<ReleaseInfo?> fetchLatest() async {
    final res = await http.get(
      Uri.parse(_latestApi),
      headers: const {
        'Accept': 'application/vnd.github+json',
        'User-Agent': 'cyjl-medlog',
      },
    );
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) {
      throw Exception('GitHub 返回 HTTP ${res.statusCode}');
    }
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final tag = (json['tag_name'] as String?) ?? '';
    final version = tag.replaceFirst(RegExp(r'^[vV]'), '');
    final assets = (json['assets'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    String? apk;
    for (final a in assets) {
      final name = (a['name'] as String?) ?? '';
      if (name.toLowerCase().endsWith('.apk')) {
        apk = a['browser_download_url'] as String?;
        break;
      }
    }
    return ReleaseInfo(
      version: version,
      tag: tag,
      title: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : tag,
      notes: (json['body'] as String?) ?? '',
      htmlUrl: (json['html_url'] as String?) ?? releasesPage,
      apkUrl: apk,
    );
  }

  /// 语义化比较：latest 是否比 current 新
  bool isNewer(String latest, String current) {
    final a = _parts(latest);
    final b = _parts(current);
    for (var i = 0; i < 3; i++) {
      if (a[i] != b[i]) return a[i] > b[i];
    }
    return false;
  }

  List<int> _parts(String v) {
    final core = v.split('+').first.split('-').first;
    final seg = core.split('.');
    return [for (var i = 0; i < 3; i++) int.tryParse(i < seg.length ? seg[i] : '0') ?? 0];
  }

  /// 下载 APK 到临时目录（分块回调进度）
  Future<File> downloadApk(
    String url, {
    void Function(int received, int total)? onProgress,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/update-${DateTime.now().millisecondsSinceEpoch}.apk');
    final client = http.Client();
    try {
      final req = http.Request('GET', Uri.parse(url));
      req.headers['User-Agent'] = 'cyjl-medlog';
      final resp = await client.send(req);
      if (resp.statusCode != 200) {
        throw Exception('下载失败 HTTP ${resp.statusCode}');
      }
      final total = resp.contentLength ?? -1;
      var received = 0;
      final sink = file.openWrite();
      await for (final chunk in resp.stream) {
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(received, total);
      }
      await sink.flush();
      await sink.close();
      return file;
    } finally {
      client.close();
    }
  }

  /// 调用系统安装器安装 APK
  Future<void> installApk(File file) async {
    await OpenFilex.open(file.path, type: 'application/vnd.android.package-archive');
  }

  Future<void> openReleasePage([String? url]) async {
    await launchUrl(Uri.parse(url ?? releasesPage), mode: LaunchMode.externalApplication);
  }
}
