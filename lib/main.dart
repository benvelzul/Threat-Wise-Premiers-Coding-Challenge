import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/chatbot/chatbot_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/minigames/quiz_page.dart';
import 'features/incident_report/report_page.dart';
import 'features/password_system/password_page.dart';
import 'features/simulator/simulator_page.dart';
//import 'features/tests.dart';

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
        DashboardPage.routeName: (context) => const DashboardPage(),
        ChatbotPage.routeName: (context) => const ChatbotPage(),
        MinigamesPage.routeName: (context) => const MinigamesPage(),
        PasswordPage.routeName: (context) => const PasswordPage(),
        EmailPage.routeName: (context) => const EmailPage(),
        ReportPage.routeName: (context) => const ReportPage(),
        // TestPage.routeName: (context) => const TestPage(),
      },
      initialRoute: DashboardPage.routeName,
    );
  }
}
