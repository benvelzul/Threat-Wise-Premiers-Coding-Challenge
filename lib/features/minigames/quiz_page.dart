import 'package:flutter/material.dart';

class MinigamesPage extends StatelessWidget {
  static const routeName = '/minigames';

  const MinigamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final games = const [
      {'title': 'Local Multiplayer', 'subtitle': 'Play with a friend', 'icon': Icons.groups},
      {'title': 'Quiz', 'subtitle': 'Answer security questions', 'icon': Icons.quiz},
      {'title': 'Pairs', 'subtitle': 'Match the cards', 'icon': Icons.grid_view},
      {'title': 'Password Puzzle', 'subtitle': 'Crack the code', 'icon': Icons.lock_open},
      {'title': 'Threat Hunt', 'subtitle': 'Find suspicious items', 'icon': Icons.search},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minigames'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF0A0E17),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a minigame to play',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: games.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final game = games[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF141B2D),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(game['icon'] as IconData, size: 34, color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(height: 16),
                          Text(
                            game['title'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            game['subtitle'] as String,
                            style: TextStyle(color: Colors.grey[400], fontSize: 13),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Coming soon',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
