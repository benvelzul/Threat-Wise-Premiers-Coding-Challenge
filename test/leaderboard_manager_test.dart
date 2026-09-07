import 'package:flutter_test/flutter_test.dart';
import 'package:threat_wise/core/xp_system/leaderboard_manager.dart';

void main() {
  test('leaderboard includes current XP and sorts entries by points', () {
    final entries = LeaderboardManager.instance.entriesFor(1500);

    expect(entries, hasLength(6));
    expect(entries.where((entry) => entry.isCurrentUser).single.points, 1500);
    for (var index = 1; index < entries.length; index++) {
      expect(
        entries[index - 1].points,
        greaterThanOrEqualTo(entries[index].points),
      );
    }
  });
}
