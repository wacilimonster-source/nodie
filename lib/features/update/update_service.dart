import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// 发布信息（来自 version.json 或 GitHub API）
class ReleaseInfo {
  const ReleaseInfo({
    required this.version,
    required this.tag,
    required this.notes,
    required this.htmlUrl,
    required this.apkUrls,
  });

  final String version; // 规范化版本，如 1.2.0
  final String tag; // 原始 tag，如 v1.2.0
  final String notes;
  final String htmlUrl;

  /// 依次尝试的 APK 下载地址（国内镜像优先，GitHub 直连兜底）
  final List<String> apkUrls;

  factory ReleaseInfo.fromJson(Map<String, dynamic> j) {
    final raw = (j['version'] as String?) ?? '';
    final version = raw.replaceFirst(RegExp(r'^[vV]'), '');
    final apk = (j['apk'] as String?)?.trim();
    final mirrors = (j['mirrors'] as List?)
            ?.map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        <String>[];
    final urls = <String>[...mirrors];
    if (apk != null && apk.isNotEmpty) urls.add(apk);
    return ReleaseInfo(
      version: version,
      tag: (j['tag'] as String?) ?? (version.isEmpty ? '' : 'v$version'),
      notes: (j['notes'] as String?) ?? '',
      htmlUrl: (j['htmlUrl'] as String?) ?? UpdateService.releasesPage,
      apkUrls: urls,
    );
  }
}

/// 检查更新：优先国内可直连的 jsDelivr 元数据，下载走镜像优先
class UpdateService {
  UpdateService({this.owner = 'wacilimonster-source', this.repo = 'nodie'});

  final String owner;
  final String repo;

  static const defaultOwner = 'wacilimonster-source';
  static const defaultRepo = 'nodie';

  static String get releasesPage =>
      'https://github.com/$defaultOwner/$defaultRepo/releases/latest';

  /// 国内可直连的元数据源（jsDelivr CDN，读仓库 main 分支的 version.json）
  String get metadataUrl => 'https://cdn.jsdelivr.net/gh/$owner/$repo@main/version.json';

  /// jsDelivr 备用域名
  String get metadataUrlAlt =>
      'https://fastly.jsdelivr.net/gh/$owner/$repo@main/version.json';

  /// 海外回退：GitHub Releases API（国内常被墙）
  String get _api => 'https://api.github.com/repos/$owner/$repo/releases/latest';

  Future<String> currentVersion() async => (await PackageInfo.fromPlatform()).version;

  /// 拉取最新版本信息：优先 jsDelivr（国内可直连），失败回退 GitHub API
  Future<ReleaseInfo?> fetchLatest() async {
    final meta = await _fetchVersionJson();
    if (meta != null) return meta;
    return _fetchFromGitHubApi();
  }

  Future<ReleaseInfo?> _fetchVersionJson() async {
    for (final url in [metadataUrl, metadataUrlAlt]) {
      try {
        final res = await http
            .get(Uri.parse(url), headers: const {'User-Agent': 'cyjl-medlog'})
            .timeout(const Duration(seconds: 15));
        if (res.statusCode == 200) {
          final j = jsonDecode(utf8.decode(res.bodyBytes));
          if (j is Map<String, dynamic>) {
            final info = ReleaseInfo.fromJson(j);
            if (info.version.isNotEmpty) return info;
          }
        }
      } catch (_) {
        // 换下一条线路
      }
    }
    return null;
  }

  Future<ReleaseInfo?> _fetchFromGitHubApi() async {
    try {
      final res = await http.get(
        Uri.parse(_api),
        headers: const {
          'Accept': 'application/vnd.github+json',
          'User-Agent': 'cyjl-medlog',
        },
      ).timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) return null;
      final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      final tag = (json['tag_name'] as String?) ?? '';
      final version = tag.replaceFirst(RegExp(r'^[vV]'), '');
      String? apk;
      for (final a in (json['assets'] as List?)?.cast<Map<String, dynamic>>() ?? const []) {
        final name = (a['name'] as String?) ?? '';
        if (name.toLowerCase().endsWith('.apk')) {
          apk = a['browser_download_url'] as String?;
          break;
        }
      }
      final urls = <String>[
        if (apk != null) 'https://ghproxy.net/$apk',
        if (apk != null) 'https://ghfast.top/$apk',
        if (apk != null) apk,
      ];
      return ReleaseInfo(
        version: version,
        tag: tag,
        notes: (json['body'] as String?) ?? '',
        htmlUrl: (json['html_url'] as String?) ?? releasesPage,
        apkUrls: urls,
      );
    } catch (_) {
      return null;
    }
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

  /// 依次尝试各线路下载 APK（镜像优先）
  Future<File> downloadApk(
    List<String> urls, {
    void Function(int received, int total)? onProgress,
  }) async {
    Object? last;
    for (final url in urls) {
      try {
        return await _download(url, onProgress: onProgress);
      } catch (e) {
        last = e;
      }
    }
    throw Exception('所有下载线路均失败：$last');
  }

  Future<File> _download(
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
        throw Exception('HTTP ${resp.statusCode}');
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

  /// 调起系统安装器
  Future<void> installApk(File file) async {
    await OpenFilex.open(file.path, type: 'application/vnd.android.package-archive');
  }

  Future<void> openReleasePage([String? url]) async {
    await launchUrl(Uri.parse(url ?? releasesPage), mode: LaunchMode.externalApplication);
  }
}
