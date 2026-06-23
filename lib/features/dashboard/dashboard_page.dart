import 'package:flutter/material.dart';
import '../../core/avatar.dart';
import '../password_system/password_page.dart';
import '../simulator/simulator_page.dart';

class DashboardPage extends StatelessWidget {
  static const routeName = '/';

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF3A0CA3),
            elevation: 0,
            floating: true,
            pinned: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Welcome back {name}',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Avatar(
                  initials: 'BV',
                  size: 45,
                  backgroundColor: stringToColor('BV'),
                  textColor: Colors.white,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                width: double.infinity,
                color: const Color(0xFF7209B7),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  children: [
                    Text(
                      'Continue Learning',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.5,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondaryContainer),
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
                        const Icon(Icons.shield, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          '{Headline of an article or course}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                  const Text(
                    'Security Modules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                        icon: Icons.chat,
                        title: 'AI chatbot',
                        subtitle: 'Learn about threats',
                        color: Colors.blue,
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        context: context,
                        icon: Icons.warning,
                        title: 'Attack simulator',
                        subtitle: 'Simulate attacks',
                        color: Colors.red,
                        onTap: () {
                          Navigator.pushNamed(context, EmailPage.routeName);
                        },
                      ),
                      _buildFeatureCard(
                        context: context,
                        icon: Icons.vpn_key,
                        title: 'Password checker',
                        subtitle: 'Check password strength',
                        color: Colors.amber,
                        onTap: () {
                          Navigator.pushNamed(context, PasswordPage.routeName);
                        },
                      ),
                      _buildFeatureCard(
                        context: context,
                        icon: Icons.update,
                        title: 'Mini games',
                        subtitle: 'Spot the threat',
                        color: Colors.purple,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required MaterialColor color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF141B2D),
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
              Icon(icon, color: color[400], size: 32),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
    required Color statusColor,
  }) {
    return Card(
      color: const Color(0xFF141B2D),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: statusColor),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        subtitle: Text(
          time,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
