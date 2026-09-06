import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class XpManager {
  XpManager._() : xpNotifier = ValueNotifier<int>(0);

  static final XpManager instance = XpManager._();

  static const String _xpKey = 'total_xp';
  static const String _attemptedCoursesKey = 'attempted_courses';
  static const String _completedCoursesKey = 'completed_courses';
  static const int xpPerLevel = 1000;

  final ValueNotifier<int> xpNotifier;

  int _totalXp = 0;
  final Set<String> _attemptedCourses = <String>{};
  final Set<String> _completedCourses = <String>{};

  int get totalXp => _totalXp;

  int get currentLevel => (_totalXp ~/ xpPerLevel) + 1;

  int get xpInCurrentLevel => _totalXp % xpPerLevel;

  int get xpToNextLevel => xpPerLevel - xpInCurrentLevel;

  double get levelProgress => xpInCurrentLevel / xpPerLevel;

  double streakMultiplier(int streak) {
    if (streak <= 1) return 1.0;
    return 1.0 + ((streak - 1) * 0.1);
  }

  int xpWithStreak(int amount, int streak) =>
      (amount * streakMultiplier(streak)).round();

  bool _containsCourse(Set<String> courses, String courseId) {
    if (courses.isEmpty) return false;
    return courses.contains(courseId);
  }

  bool isCourseCompleted(String courseId) =>
      _containsCourse(_completedCourses, courseId);

  bool isCourseAttempted(String courseId) =>
      _containsCourse(_attemptedCourses, courseId) ||
      isCourseCompleted(courseId);

  void _notify() {
    xpNotifier.value = _totalXp;
  }

  Future<void> loadXp() async {
    final prefs = await SharedPreferences.getInstance();
    _totalXp = prefs.getInt(_xpKey) ?? 0;
    _attemptedCourses
      ..clear()
      ..addAll(prefs.getStringList(_attemptedCoursesKey) ?? <String>[]);
    _completedCourses
      ..clear()
      ..addAll(prefs.getStringList(_completedCoursesKey) ?? <String>[]);
    _notify();
  }

  Future<void> markCourseAttempted(String courseId) async {
    if (isCourseAttempted(courseId)) return;

    _attemptedCourses.add(courseId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_attemptedCoursesKey, _attemptedCourses.toList());
    _notify();
  }

  Future<bool> completeCourse({
    required String courseId,
    required int xpReward,
  }) async {
    if (isCourseCompleted(courseId)) return false;

    final prefs = await SharedPreferences.getInstance();
    _completedCourses.add(courseId);
    await prefs.setStringList(_completedCoursesKey, _completedCourses.toList());
    await addXp(xpReward);
    return true;
  }

  Future<void> addXp(int amount, {int streak = 1}) async {
    if (amount <= 0) return;

    _totalXp += xpWithStreak(amount, streak);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, _totalXp);
    _notify();
  }

  Future<void> resetXp() async {
    _totalXp = 0;
    _attemptedCourses.clear();
    _completedCourses.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, _totalXp);
    await prefs.remove(_attemptedCoursesKey);
    await prefs.remove(_completedCoursesKey);
    _notify();
  }
}
