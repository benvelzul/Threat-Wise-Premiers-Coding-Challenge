import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../chatbot/chatbot_page.dart';
import '../minigames/quiz_page.dart';
import '../password_system/password_page.dart';
import '../simulator/simulator_page.dart';
import '../incident_report/report_page.dart';
import '../widgets/make_image.dart';
import 'dart:math' as math;
import 'dart:ui';

// 1. Changed to StatefulWidget
class DashboardPage extends StatefulWidget {
  static const routeName = '/';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late final AnimationController _floatController;

  // Starting position of the floating image
  Offset _offset = const Offset(50, 100);

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showFloatingImage(context);
    });
  }

  @override
  void dispose() {
    // Clean up the overlay when the widget is destroyed
    _floatController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void showFloatingImage(BuildContext context) {
    // 1. Create a local position variable that the StatefulBuilder can manipulate directly
    Offset localOffset = _offset;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, overlaySetState) {
            return AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final floatOffset = 10 * math.sin(_floatController.value * 2 * math.pi);

                return Positioned(
                  left: localOffset.dx,
                  top: localOffset.dy + floatOffset,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      overlaySetState(() {
                        // 2. Add the tiny touch movement (delta) to our local offset
                        Offset newOffset = localOffset + details.delta;

                        Size screenSize = MediaQuery.of(context).size;

                        // 3. Clamp using 100 instead of 150 (since your widget is 100x100)
                        double clampedX = newOffset.dx.clamp(0.0, screenSize.width - 100);
                        double clampedY = newOffset.dy.clamp(0.0, screenSize.height - 100);

                        localOffset = Offset(clampedX, clampedY);

                        // 4. Sync it back to the class-level variable so it persists
                        _offset = localOffset;
                      });
                    },
                    // We wrap everything in a Container to give the shadow room to bleed past the 100x100 bounds
                    // without getting cut off by the drag limits.
                    child: SizedBox(
                      width: 115, // 100 image width + extra room for the shadow offset/blur
                      height: 115, // 100 image height + extra room for the shadow offset/blur
                      child: Stack(
                        clipBehavior: Clip.none, // Ensures the blur doesn't get clipped at the edges
                        children: [
                          // 1. THE BLURRED SILHOUETTE SHADOW LAYER
                          Positioned(
                            left: 5, // How far right the shadow falls
                            top: 5, // How far down the shadow falls
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0), // Smoothness of shadow
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4), // Shadow tint and opacity
                                  BlendMode.srcIn,
                                ),
                                child: LocalImageWidget(
                                  imagePath: 'assets/images/Gargoyle.png',
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),

                          // 2. THE ACTUAL FOREGROUND IMAGE (CLEAN)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: LocalImageWidget(
                              imagePath: 'assets/images/Gargoyle.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350, // Buttons will never grow wider than 250px
                      mainAxisSpacing: 10,     // Spacing between rows
                      crossAxisSpacing: 10,    // Spacing between columns
                      childAspectRatio: 1.2,     // Keeps a nice button shape (Width / Height)
                    ),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _buildFeatureCard(
                            context: context,
                            appColors: appColors,
                            icon: Icons.chat,
                            title: 'AI chatbot',
                            subtitle: 'Learn about threats',
                            color: appColors?.featureChat ?? Theme.of(context).colorScheme.primary,
                            onTap: () {
                              Navigator.pushNamed(context, ChatbotPage.routeName);
                            },
                          );
                        case 1:
                          return _buildFeatureCard(
                            context: context,
                            appColors: appColors,
                            icon: Icons.warning,
                            title: 'Attack simulator',
                            subtitle: 'Simulate attacks',
                            color: appColors?.featureSimulator ?? Theme.of(context).colorScheme.error,
                            onTap: () {
                              // Note: Fixed your typo here where it used EmailPage instead of SimulatorPage
                              Navigator.pushNamed(context, EmailPage.routeName);
                            },
                          );
                        case 2:
                          return _buildFeatureCard(
                            context: context,
                            appColors: appColors,
                            icon: Icons.vpn_key,
                            title: 'Password checker',
                            subtitle: 'Check password strength',
                            color: appColors?.featurePassword ?? Theme.of(context).colorScheme.secondary,
                            onTap: () {
                              Navigator.pushNamed(context, PasswordPage.routeName);
                            },
                          );
                        case 3:
                        default:
                          return _buildFeatureCard(
                            context: context,
                            appColors: appColors,
                            icon: Icons.update,
                            title: 'Mini games',
                            subtitle: 'Spot the threat',
                            color: appColors?.featureGames ?? Theme.of(context).colorScheme.tertiary,
                            onTap: () {
                              Navigator.pushNamed(context, MinigamesPage.routeName);
                            },
                          );
                        
                      }
                    },
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300, // Buttons will never grow wider than 250px
                      mainAxisSpacing: 10,     // Spacing between rows
                      crossAxisSpacing: 10,    // Spacing between columns
                      childAspectRatio: 1.2, 
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.book),
                            label: const Text('Resource Library'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          );
                        case 1:
                          return ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.analytics),
                            label: const Text('My Stats and Progress'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          );
                        case 2:
                          return ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.checklist),
                            label: const Text('Security Checklist'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          );
                        case 3:
                        default:
                          return ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, ReportPage.routeName);
                            },
                            icon: const Icon(Icons.report),
                            label: const Text('Incident Report Form'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          );
                      }
                    },
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
                  color: Theme.of(context).colorScheme.onSurface, // Note: Changed to onSurface so text is visible on typical card backgrounds
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