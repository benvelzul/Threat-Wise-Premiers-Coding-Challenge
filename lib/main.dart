import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/password_system/password_page.dart';
import 'features/simulator/simulator_page.dart';

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
        PasswordPage.routeName: (context) => const PasswordPage(),
        EmailPage.routeName: (context) => const EmailPage(),
      },
      initialRoute: DashboardPage.routeName,
    );
  }
}
