import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/chatbot/chatbot_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/stat_pages/leaderboard_page.dart';
import 'features/minigames/quiz_page.dart';
import 'features/incident_report/report_page.dart';
import 'features/password_system/password_page.dart';
import 'features/simulator/simulator_page.dart';
import 'features/tests.dart';
import 'features/simulator/setup_page.dart';
import 'features/courses/courses_page.dart';
import 'core/xp_system/xp_manager.dart';
import 'features/widgets/mascot_overlay.dart';
import 'core/streak_system/streak_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await XpManager.instance.loadXp();
  await StreakManager.instance.checkAndUpdateStreak();
  runApp(const MyApp());
}

final MascotRouteObserver mascotRouteObserver = MascotRouteObserver();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThreatWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      navigatorObservers: [mascotRouteObserver],
      builder: (context, child) => Stack(
        children: [
          child ?? const SizedBox.shrink(),
          MascotOverlay(routeObserver: mascotRouteObserver),
        ],
      ),
      routes: {
        CourseDetailsPage.routeName: (context) => const CourseDetailsPage(),
        DashboardPage.routeName: (context) => const DashboardPage(),
        LeaderboardPage.routeName: (context) => const LeaderboardPage(),
        ChatbotPage.routeName: (context) => const ChatbotPage(),
        MinigamesPage.routeName: (context) => const MinigamesPage(),
        PasswordPage.routeName: (context) => const PasswordPage(),
        SimulatorPage.routeName: (context) => const SimulatorPage(),
        ReportPage.routeName: (context) => const ReportPage(),
        MyHomeScreen.routeName: (context) => const MyHomeScreen(),
        StartSimulatorPage.routeName: (context) => const StartSimulatorPage(),
      },
      initialRoute: DashboardPage.routeName,
    );
  }
}
