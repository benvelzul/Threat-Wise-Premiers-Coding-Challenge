import 'package:flutter/material.dart';
import '../../core/theme.dart';

class LeaderboardPage extends StatelessWidget {
  static const routeName = '/leaderboard';

  const LeaderboardPage({super.key});

  Widget _buildRankBadge(int rank, Color color) {
    final rankLabel = rank <= 3 ? 'TOP' : '#$rank';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        rankLabel,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> entry, ColorScheme colorScheme) {
    final rank = entry['rank'] as int;
    final points = entry['points'] as int;
    final name = entry['name'] as String;
    final isCurrentUser = entry['isCurrentUser'] as bool;
    final accentColor = entry['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? accentColor.withValues(alpha: 0.14) : colorScheme.primaryContainer.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCurrentUser ? accentColor.withValues(alpha: 0.35) : colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: accentColor.withValues(alpha: 0.17),
          child: Text(
            '$rank',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '$points points',
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.72),
            fontSize: 13,
          ),
        ),
        trailing: _buildRankBadge(rank, accentColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();

    final leaderboardData = [
      {'rank': 1, 'name': 'Skylar', 'points': 1980, 'color': colorScheme.secondary, 'isCurrentUser': false},
      {'rank': 2, 'name': 'Morgan', 'points': 1765, 'color': appColors?.featureChat ?? colorScheme.primary, 'isCurrentUser': false},
      {'rank': 3, 'name': 'Jordan', 'points': 1620, 'color': appColors?.featureGames ?? colorScheme.tertiary, 'isCurrentUser': false},
      {'rank': 4, 'name': 'You', 'points': 1490, 'color': colorScheme.primary, 'isCurrentUser': true},
      {'rank': 5, 'name': 'Avery', 'points': 1380, 'color': appColors?.featurePassword ?? colorScheme.secondary, 'isCurrentUser': false},
      {'rank': 6, 'name': 'Riley', 'points': 1250, 'color': appColors?.featureSimulator ?? colorScheme.error, 'isCurrentUser': false},
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primaryContainer,
        elevation: 0,
        title: Text(
          'Leaderboard',
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: appColors?.cardBackground ?? colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Top Performer',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Skylar',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '1980 points',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.emoji_events, color: colorScheme.onSecondary, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          '1st',
                          style: TextStyle(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Current Rank',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '#4',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This Week',
                          style: TextStyle(
                            color: colorScheme.onSecondaryContainer.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '+120 pts',
                          style: TextStyle(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Top Players',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: leaderboardData.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return _buildUserTile(leaderboardData[index], colorScheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
