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
}
