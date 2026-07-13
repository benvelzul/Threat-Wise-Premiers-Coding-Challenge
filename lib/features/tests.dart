import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../core/theme.dart';
import 'chatbot/chatbot_page.dart';
import 'minigames/quiz_page.dart';
import 'password_system/password_page.dart';
import 'simulator/simulator_page.dart';
import 'incident_report/report_page.dart';
import 'widgets/make_image.dart';

class TestPage extends StatefulWidget {
  static const routeName = '/';

  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  late final TabController _tabController;

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

    _tabController = TabController(length: 2, vsync: this);


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

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required Color color,
    String? connectedPage,
  }) {
    return InkWell(
      onTap: connectedPage != null
          ? () {
              Navigator.pushNamed(context, connectedPage);
            }
          : () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Static mockup datasets for UI building blocks
    final courses = [
      {'title': 'Introduction to Cyber Threats', 'desc': 'Chat with AI to learn security fundamentals.', 'icon': Icons.chat_bubble_outline, 'progress': 1.0, 'color': Colors.blueAccent},
      {'title': 'Social Engineering Tactics', 'desc': 'Understand human exploitation frameworks.', 'icon': Icons.people_outline, 'progress': 0.3, 'color': Colors.deepPurpleAccent},
      {'title': 'Network Security Foundations', 'desc': 'Deep dive into data streams and encryption.', 'icon': Icons.lan_outlined, 'progress': 0.0, 'color': Colors.teal},
    ];

    final tools = [
      {'title': 'Email Analyzer', 'subtitle': 'Spot phishing emails', 'icon': Icons.email_outlined, 'color': Colors.blueAccent, 'connectedPage': EmailPage.routeName},
      {'title': 'Password Checker', 'subtitle': 'Test password strength', 'icon': Icons.lock_outline, 'color': Colors.orangeAccent, 'connectedPage': PasswordPage.routeName},
      {'title': 'Mini Games', 'subtitle': 'Spot the security threat', 'icon': Icons.sports_esports_outlined, 'color': Colors.greenAccent, 'connectedPage': MinigamesPage.routeName},
      {'title': 'Incident Report', 'subtitle': 'File a simulated breach', 'icon': Icons.assignment_late_outlined, 'color': Colors.amberAccent, 'connectedPage': ReportPage.routeName},
      {'title': 'Chatbot', 'subtitle': 'Ask security questions', 'icon': Icons.smart_toy_outlined, 'color': Colors.purpleAccent, 'connectedPage': ChatbotPage.routeName},
    ];

    return Scaffold(
      backgroundColor: const Color(0xff121824),
      appBar: AppBar(
        backgroundColor: const Color(0xff1a2333),
        elevation: 0,
        titleSpacing: 12,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Text(
                'ThreatWise',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.local_fire_department,
                        value: '7',
                        color: Colors.orangeAccent,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.groups_3,
                        value: 'A1',
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.monetization_on,
                        value: '250',
                        color: Colors.amberAccent,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.bolt,
                        value: '85',
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          tabs: const [
            Tab(text: 'COURSES'),
            Tab(text: 'PRACTICE TOOLS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final double progress = course['progress'] as double;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline Indicator Block
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: (course['color'] as Color),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: progress == 1.0 ? Colors.green : course['color'] as Color, 
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Icon(course['icon'] as IconData, color: Colors.white, size: 26),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              progress == 1.0 ? 'Done' : '${(progress * 100).toInt()}%', 
                              style: const TextStyle(color: Colors.white60, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Module Information Card
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xff1a2333), 
                              borderRadius: BorderRadius.circular(12), 
                              border: Border.all(color: Colors.white),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course['title'] as String, 
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  course['desc'] as String, 
                                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress, 
                                    backgroundColor: Colors.white, 
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      progress == 1.0 ? Colors.green : course['color'] as Color,
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
                  );
                },
              ),
            ],
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
                  color: const Color(0xff1a2333),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white),
                ),
                child: InkWell(
                  onTap: () {
                    // Navigate to the connected page if it exists
                    final String? connectedPage = tool['connectedPage'] as String?;
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
                          color: (tool['color'] as Color).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(tool['icon'] as IconData, color: tool['color'] as Color, size: 28),
                      ),
                      // Titles Panel
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tool['title'] as String, 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tool['subtitle'] as String, 
                            style: TextStyle(color: Colors.grey[500], fontSize: 11),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff1a2333),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white38,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.import_contacts), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}