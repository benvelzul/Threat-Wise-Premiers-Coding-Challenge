import 'dart:math';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.name,
    required this.points,
    required this.isCurrentUser,
  });

  final String name;
  final int points;
  final bool isCurrentUser;
}

class LeaderboardManager {
  LeaderboardManager._() : _opponents = _generateOpponents();

  static final LeaderboardManager instance = LeaderboardManager._();

  static const List<String> _opponentNames = [
    'Skylar',
    'Morgan',
    'Jordan',
    'Avery',
    'Riley',
  ];

  final List<_Opponent> _opponents;

  static List<_Opponent> _generateOpponents() {
    final random = Random();
    return _opponentNames
        .map(
          (name) => _Opponent(name: name, points: 900 + random.nextInt(1301)),
        )
        .toList();
  }

  List<LeaderboardEntry> entriesFor(int currentUserXp) {
    final entries = [
      ..._opponents.map(
        (opponent) => LeaderboardEntry(
          name: opponent.name,
          points: opponent.points,
          isCurrentUser: false,
        ),
      ),
      LeaderboardEntry(name: 'You', points: currentUserXp, isCurrentUser: true),
    ];

    entries.sort((first, second) {
      final pointsComparison = second.points.compareTo(first.points);
      if (pointsComparison != 0) return pointsComparison;
      if (first.isCurrentUser != second.isCurrentUser) {
        return first.isCurrentUser ? -1 : 1;
      }
      return first.name.compareTo(second.name);
    });
    return entries;
  }
}

class _Opponent {
  const _Opponent({required this.name, required this.points});

  final String name;
  final int points;
}
