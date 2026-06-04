import 'package:flutter/material.dart';
import 'features/simulator/simulator_page.dart';
import 'features/password_system/password_page.dart';

void main() {
  runApp(const MyApp());
}
// helpers/utility functions
Color stringToColor(String text) {
  var hash = 0;
  // Custom hashing loop to generate a deterministic integer
  for (var i = 0; i < text.length; i++) {
    hash = text.codeUnitAt(i) + ((hash << 5) - hash);
  }

  // Ensure the hash is positive and within the 24-bit range (0 to 16,777,215)
  final finalHash = hash.abs() % (256 * 256 * 256);

  // Extract Red, Green, and Blue components using bitwise shifts
  final red = (finalHash & 0xFF0000) >> 16;
  final green = (finalHash & 0x00FF00) >> 8;
  final blue = (finalHash & 0x0000FF);

  // Return a Flutter Color object with full opacity (1.0)
  return Color.fromRGBO(red, green, blue, 1.0);
}


// Reusable widgets
class Avatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  Avatar({
    super.key,
    required this.initials,
    this.size = 50,
    Color? backgroundColor,
    this.textColor = Colors.white,
  }) : backgroundColor = backgroundColor ?? stringToColor(initials);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: textColor,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThreatWise',
      debugShowCheckedModeBanner: false,
      // Change the primary color of the whole app here
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFf72585),
          onPrimary: Colors.white,
          secondary: const Color(0xFF7209b7),
          onSecondary: Colors.white,
          tertiary: const Color(0xFF3a0ca3),
          onTertiary: Colors.white,
          primaryContainer: const Color(0xFF4361ee),
          onPrimaryContainer: Colors.white,
          secondaryContainer: const Color(0xFF4cc9f0),
          onSecondaryContainer: Colors.black,
          surface: const Color(0xFF0A0E17),
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  // Hero Section
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
                  // Section Title
                  const Text(
                    'Security Modules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Feature Grid
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EmailPage()),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        context: context,
                        icon: Icons.vpn_key,
                        title: 'Password checker',
                        subtitle: 'Check password strength',
                        color: Colors.amber,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PasswordPage()),
                          );
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
                  // Recent Activity Section
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityItem(
                    icon: Icons.check_circle,
                    title: 'System scan completed',
                    time: '2 hours ago',
                    statusColor: Theme.of(context).colorScheme.secondary,
                  ),
                  _buildActivityItem(
                    icon: Icons.block,
                    title: 'Threat blocked',
                    time: '5 hours ago',
                    statusColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  _buildActivityItem(
                    icon: Icons.download_done,
                    title: 'Security update installed',
                    time: '1 day ago',
                    statusColor: Theme.of(context).colorScheme.primaryContainer,
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
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
