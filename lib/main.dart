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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThreatWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
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
