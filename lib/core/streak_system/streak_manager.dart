import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../xp_system/xp_manager.dart';

class StreakManager {
  StreakManager._() : streakNotifier = ValueNotifier<int>(0);

  static final StreakManager instance = StreakManager._();

  static const String _streakKey = 'current_streak';
  static const String _longestStreakKey = 'longest_streak';
  static const String _lastLoginKey = 'last_login_date';

  static const int _dailyStreakBonusXp = 10;

  final ValueNotifier<int> streakNotifier;

  int _currentStreak = 0;
  int _longestStreak = 0;
  DateTime? _lastLoginDate;

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  DateTime? get lastLoginDate => _lastLoginDate;

  void _notify() {
    streakNotifier.value = _currentStreak;
  }

  Future<void> loadStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    _currentStreak = prefs.getInt(_streakKey) ?? 0;
    _longestStreak = prefs.getInt(_longestStreakKey) ?? 0;

    final lastLoginString = prefs.getString(_lastLoginKey);
    _lastLoginDate = lastLoginString != null
        ? DateTime.tryParse(lastLoginString)
        : null;

    _notify();
  }

  /// Call this once per app launch. Increments, resets, or leaves the
  /// streak untouched depending on when the user last opened the app.
  /// Returns true if the streak actually advanced today (used to decide
  /// whether to award the XP bonus).
  Future<void> checkAndUpdateStreak() async {
    await loadStreakData();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    bool streakAdvanced = false;

    if (_lastLoginDate == null) {
      // First time ever opening the app
      _currentStreak = 1;
      streakAdvanced = true;
    } else {
      final lastDay = DateTime(
        _lastLoginDate!.year,
        _lastLoginDate!.month,
        _lastLoginDate!.day,
      );
      final differenceInDays = today.difference(lastDay).inDays;

      if (differenceInDays == 0) {
        // Already counted today, nothing to do
        return;
      } else if (differenceInDays == 1) {
        // Logged in yesterday too — streak continues
        _currentStreak += 1;
        streakAdvanced = true;
      } else {
        // Missed a day (or more) — streak resets
        _currentStreak = 1;
        streakAdvanced = true;
      }
    }

    if (_currentStreak > _longestStreak) {
      _longestStreak = _currentStreak;
    }

    _lastLoginDate = today;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, _currentStreak);
    await prefs.setInt(_longestStreakKey, _longestStreak);
    await prefs.setString(_lastLoginKey, today.toIso8601String());

    _notify();

    if (streakAdvanced) {
      await XpManager.instance.addXp(_dailyStreakBonusXp);
    }
  }

  Future<void> resetStreak() async {
    _currentStreak = 0;
    _lastLoginDate = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, _currentStreak);
    await prefs.remove(_lastLoginKey);

    _notify();
  }
}