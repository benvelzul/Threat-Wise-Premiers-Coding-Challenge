import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../chatbot/chatbot_page.dart';
import '../minigames/quiz_page.dart';
import '../password_system/password_page.dart';
import '../simulator/simulator_page.dart';
import '../incident_report/report_page.dart';

class DashboardPage extends StatelessWidget {
  static const routeName = '/';

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            floating: false,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(14),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.local_fire_department,
                        value: '7',
                        color: appColors?.statItem ?? Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.groups_3,
                        value: 'A1',
                        color: appColors?.statItem ?? Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.monetization_on,
                        value: '250',
                        color: appColors?.statItem ?? Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.bolt,
                        value: '85',
                        color: appColors?.statItem ?? Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.shield, size: 48, color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(height: 16),
                        Text(
                          '{Headline of an article or course}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A brief description of the content goes here, enticing users to click and learn more.',
                          style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Get Started'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                foregroundColor: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Security Modules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildFeatureCard(
                        context: context,
                        appColors: appColors,
                        icon: Icons.chat,
                        title: 'AI chatbot',
                        subtitle: 'Learn about threats',
                        color: appColors?.featureChat ?? Theme.of(context).colorScheme.primary,
                        onTap: () {
                          Navigator.pushNamed(context, ChatbotPage.routeName);
                        },
                      ),
                      _buildFeatureCard(
                        context: context,
                        appColors: appColors,
                        icon: Icons.warning,
                        title: 'Attack simulator',
                        subtitle: 'Simulate attacks',
                        color: appColors?.featureSimulator ?? Theme.of(context).colorScheme.error,
                        onTap: () {
                          Navigator.pushNamed(context, EmailPage.routeName);
                        },
                      ),
                      _buildFeatureCard(
                        context: context,
                        appColors: appColors,
                        icon: Icons.vpn_key,
                        title: 'Password checker',
                        subtitle: 'Check password strength',
                        color: appColors?.featurePassword ?? Theme.of(context).colorScheme.secondary,
                        onTap: () {
                          Navigator.pushNamed(context, PasswordPage.routeName);
                        },
                      ),
                      _buildFeatureCard(
                        context: context,
                        appColors: appColors,
                        icon: Icons.update,
                        title: 'Mini games',
                        subtitle: 'Spot the threat',
                        color: appColors?.featureGames ?? Theme.of(context).colorScheme.tertiary,
                        onTap: () {
                          Navigator.pushNamed(context, MinigamesPage.routeName);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Tools & Resources',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.75,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.book),
                        label: const Text('Resource Library'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.checklist),
                        label: const Text('Security Checklist'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, ReportPage.routeName);
                        },
                        icon: const Icon(Icons.report),
                        label: const Text('Incident Report Form'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.analytics),
                        label: const Text('My stats & progress'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 25),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required AppColors? appColors,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: appColors?.cardBackground ?? Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: appColors?.featureSubtitle ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
