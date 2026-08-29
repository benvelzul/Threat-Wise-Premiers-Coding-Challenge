import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class XpManager {
  XpManager._() : xpNotifier = ValueNotifier<int>(0);

  static final XpManager instance = XpManager._();

  static const String _xpKey = 'total_xp';
  static const int xpPerLevel = 1000;

  final ValueNotifier<int> xpNotifier;

  int _totalXp = 0;

  int get totalXp => _totalXp;

  int get currentLevel => (_totalXp ~/ xpPerLevel) + 1;

  int get xpInCurrentLevel => _totalXp % xpPerLevel;

  int get xpToNextLevel => xpPerLevel - xpInCurrentLevel;

  double get levelProgress => xpInCurrentLevel / xpPerLevel;

  void _notify() {
    xpNotifier.value = _totalXp;
  }

  Future<void> loadXp() async {
    final prefs = await SharedPreferences.getInstance();
    _totalXp = prefs.getInt(_xpKey) ?? 0;
    _notify();
  }

  Future<void> addXp(int amount) async {
    if (amount <= 0) return;

    _totalXp += amount;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, _totalXp);
    _notify();
  }

  Future<void> resetXp() async {
    _totalXp = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, _totalXp);
    _notify();
  }
}