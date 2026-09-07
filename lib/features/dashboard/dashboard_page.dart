import 'package:flutter/material.dart';
import 'package:threat_wise/core/streak_system/streak_manager.dart';
import '../../core/theme.dart';
import '../../core/xp_system/leaderboard_manager.dart';
import '../../core/xp_system/xp_manager.dart';
import '../chatbot/chatbot_page.dart';
import '../stat_pages/leaderboard_page.dart';
import '../minigames/minigames_menu.dart';
import '../password_system/password_page.dart';
import '../simulator/setup_page.dart';
import '../incident_report/report_page.dart';
import '../courses/courses_page.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Fundamentals of VoIP/SIP Systems',
      'desc': 'Learn the fundamentals of VoIP, SIP, and network protocols.',
      'icon': Icons.menu_book_outlined,
      'progress': 0.0,
      'color': Colors.blue,
      'assetPath': 'assets/courses/course1.md',
    },
    {
      'title': 'Phishing detection essentials',
      'desc':
          'Learn the basics of phishing spotting and how to defend against them.',
      'icon': Icons.security_outlined,
      'progress': 0.0,
      'color': Colors.green,
      'assetPath': 'assets/courses/course2.md',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAnalyticsMetric({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.65),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsPage(
    ColorScheme colorScheme,
    AppColors? appColors,
    int totalXp,
  ) {
    final xpColor = appColors?.featureGames ?? colorScheme.tertiary;
    final urgencyColor = appColors?.featurePassword ?? colorScheme.error;
    final level = XpManager.instance.currentLevel;
    final xpInCurrentLevel = XpManager.instance.xpInCurrentLevel;
    final xpToNextLevel = XpManager.instance.xpToNextLevel;
    final progress = XpManager.instance.levelProgress;
    final leaderboard = LeaderboardManager.instance.entriesFor(totalXp);
    final currentUserRank =
        leaderboard.indexWhere((entry) => entry.isCurrentUser) + 1;
    final topEntry = leaderboard.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      children: [
        Text(
          'Your progress',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Keep building your cyber safety skills.',
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.65),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: appColors?.cardBackground ?? colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LEVEL $level',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$totalXp XP total',
                    style: TextStyle(
                      color: xpColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$xpInCurrentLevel / ${XpManager.xpPerLevel} XP',
                    style: TextStyle(
                      color: xpColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Lvl ${level + 1}',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: colorScheme.onSurface.withValues(
                    alpha: 0.12,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(xpColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$xpToNextLevel XP to Level ${level + 1}',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.62),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.1,
          children: [
            _buildAnalyticsMetric(
              icon: Icons.local_fire_department,
              value: '${StreakManager.instance.currentStreak} days',
              label: 'Streak',
              color: urgencyColor,
              colorScheme: colorScheme,
            ),
            _buildAnalyticsMetric(
              icon: Icons.emoji_events_outlined,
              value: '#$currentUserRank',
              label: 'Rank',
              color: colorScheme.secondary,
              colorScheme: colorScheme,
            ),
          ],
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () => Navigator.pushNamed(context, LeaderboardPage.routeName),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appColors?.cardBackground ?? colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              children: [
                Icon(Icons.leaderboard_outlined, color: colorScheme.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leaderboard',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${topEntry.name} leads with ${topEntry.points} XP',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.65),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>();
    final colorScheme = Theme.of(context).colorScheme;

    final tools = [
      {
        'title': 'Email Analyzer',
        'subtitle': 'Spot phishing emails',
        'icon': Icons.email_outlined,
        'color': appColors?.featureChat ?? colorScheme.secondary,
        'connectedPage': StartSimulatorPage.routeName,
      },
      {
        'title': 'Password Checker',
        'subtitle': 'Test password strength',
        'icon': Icons.lock_outline,
        'color': appColors?.featurePassword ?? colorScheme.primary,
        'connectedPage': PasswordPage.routeName,
      },
      {
        'title': 'Mini Games',
        'subtitle': 'Spot the security threat',
        'icon': Icons.sports_esports_outlined,
        'color': appColors?.featureGames ?? colorScheme.tertiary,
        'connectedPage': MinigamesPage.routeName,
      },
      {
        'title': 'Incident Report',
        'subtitle': 'File a simulated breach',
        'icon': Icons.assignment_late_outlined,
        'color': appColors?.featureSimulator ?? colorScheme.secondary,
        'connectedPage': ReportPage.routeName,
      },
      {
        'title': 'Chatbot',
        'subtitle': 'Ask security questions',
        'icon': Icons.smart_toy_outlined,
        'color': appColors?.featureChat ?? colorScheme.tertiary,
        'connectedPage': ChatbotPage.routeName,
      },
    ];

    return ValueListenableBuilder<int>(
      valueListenable: XpManager.instance.xpNotifier,
      builder: (context, _, _) {
        final totalXp = XpManager.instance.totalXp;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: colorScheme.primaryContainer,
            elevation: 0,
            titleSpacing: 12,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'ThreatWise',
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Material(
                color: colorScheme.secondary,
                child: TabBar(
                  controller: _tabController,
                  labelColor: colorScheme.onPrimaryContainer,
                  unselectedLabelColor: colorScheme.onPrimaryContainer
                      .withValues(alpha: 0.6),
                  tabs: const [
                    Tab(text: 'COURSES'),
                    Tab(text: 'PRACTICE TOOLS'),
                    Tab(text: 'ANALYTICS'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  final courseId = course['assetPath'] as String;
                  final isCompleted = XpManager.instance.isCourseCompleted(
                    courseId,
                  );
                  final isAttempted = XpManager.instance.isCourseAttempted(
                    courseId,
                  );
                  final progress = isCompleted
                      ? 1.0
                      : course['progress'] as double;
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              CourseDetailsPage(assetPath: courseId),
                        ),
                      );
                      if (mounted) setState(() {});
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: course['color'] as Color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: progress == 1.0
                                        ? colorScheme.primary
                                        : course['color'] as Color,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    course['icon'] as IconData,
                                    color: colorScheme.onPrimary,
                                    size: 26,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isCompleted
                                    ? 'Done'
                                    : isAttempted
                                    ? 'Attempted'
                                    : '${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    appColors?.cardBackground ??
                                    colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: colorScheme.outline),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['title'] as String,
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    course['desc'] as String,
                                    style: TextStyle(
                                      color:
                                          appColors?.featureSubtitle ??
                                          colorScheme.onSurface.withValues(
                                            alpha: 0.7,
                                          ),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: colorScheme.onSurface
                                          .withValues(alpha: 0.15),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        progress == 1.0
                                            ? colorScheme.primary
                                            : course['color'] as Color,
                                      ),
                                      minHeight: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tools.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final tool = tools[index];
                  return Ink(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: appColors?.cardBackground ?? colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: InkWell(
                      onTap: () {
                        final String? connectedPage =
                            tool['connectedPage'] as String?;
                        if (connectedPage != null) {
                          Navigator.pushNamed(context, connectedPage);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (tool['color'] as Color).withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              tool['icon'] as IconData,
                              color: tool['color'] as Color,
                              size: 28,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tool['title'] as String,
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tool['subtitle'] as String,
                                style: TextStyle(
                                  color:
                                      appColors?.featureSubtitle ??
                                      colorScheme.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              _buildAnalyticsPage(colorScheme, appColors, totalXp),
            ],
          ),
        );
      },
    );
  }
}
