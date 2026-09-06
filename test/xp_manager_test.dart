import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threat_wise/core/xp_system/xp_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await XpManager.instance.resetXp();
  });

  test('xp manager tracks total xp and level progress', () async {
    await XpManager.instance.addXp(425);

    expect(XpManager.instance.totalXp, 425);
    expect(XpManager.instance.currentLevel, 1);
    expect(XpManager.instance.xpInCurrentLevel, 425);
    expect(XpManager.instance.xpToNextLevel, 575);
    expect(XpManager.instance.levelProgress, closeTo(0.425, 0.001));
  });

  test('streak multiplier increases xp for continued streaks', () async {
    expect(XpManager.instance.streakMultiplier(1), 1.0);
    expect(XpManager.instance.streakMultiplier(2), 1.1);
    expect(XpManager.instance.streakMultiplier(3), 1.2);
    expect(XpManager.instance.xpWithStreak(50, 2), 55);

    await XpManager.instance.addXp(50, streak: 2);

    expect(XpManager.instance.totalXp, 55);
  });

  test('empty course collections return false', () {
    expect(
      XpManager.instance.isCourseAttempted('assets/courses/course1.md'),
      isFalse,
    );
    expect(
      XpManager.instance.isCourseCompleted('assets/courses/course1.md'),
      isFalse,
    );
  });

  test('course completion awards xp once and persists', () async {
    final firstCompletion = await XpManager.instance.completeCourse(
      courseId: 'assets/courses/course1.md',
      xpReward: 100,
    );
    final secondCompletion = await XpManager.instance.completeCourse(
      courseId: 'assets/courses/course1.md',
      xpReward: 100,
    );

    expect(firstCompletion, isTrue);
    expect(secondCompletion, isFalse);
    expect(XpManager.instance.totalXp, 100);
    expect(
      XpManager.instance.isCourseCompleted('assets/courses/course1.md'),
      isTrue,
    );

    await XpManager.instance.loadXp();

    expect(
      XpManager.instance.isCourseCompleted('assets/courses/course1.md'),
      isTrue,
    );
  });

  test('course attempt persists separately from completion', () async {
    await XpManager.instance.markCourseAttempted('assets/courses/course2.md');

    expect(
      XpManager.instance.isCourseAttempted('assets/courses/course2.md'),
      isTrue,
    );
    expect(
      XpManager.instance.isCourseCompleted('assets/courses/course2.md'),
      isFalse,
    );

    await XpManager.instance.loadXp();

    expect(
      XpManager.instance.isCourseAttempted('assets/courses/course2.md'),
      isTrue,
    );
  });
}
