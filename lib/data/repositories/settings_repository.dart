import 'package:shared_preferences/shared_preferences.dart';
import 'package:cyjl/core/enums.dart';

/// 本地设置（SharedPreferences）
class SettingsRepository {
  static const _profile = 'settings.profile';
  static const _window = 'settings.confirmWindowHours';
  static const _snooze = 'settings.snoozeMinutes';
  static const _notif = 'settings.notificationsEnabled';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<ProfileType> profile() async =>
      ProfileType.fromCode((await _prefs).getString(_profile) ?? ProfileType.male.code);

  Future<void> setProfile(ProfileType v) async => (await _prefs).setString(_profile, v.code);

  Future<int> confirmWindowHours() async => (await _prefs).getInt(_window) ?? 4;

  Future<void> setConfirmWindowHours(int v) async =>
      (await _prefs).setInt(_window, v.clamp(1, 12));

  Future<int> snoozeMinutes() async => (await _prefs).getInt(_snooze) ?? 10;

  Future<void> setSnoozeMinutes(int v) async => (await _prefs).setInt(_snooze, v);

  Future<bool> notificationsEnabled() async => (await _prefs).getBool(_notif) ?? true;

  Future<void> setNotificationsEnabled(bool v) async =>
      (await _prefs).setBool(_notif, v);
}
