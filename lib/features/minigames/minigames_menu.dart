import 'package:flutter/material.dart';
import '../../core/theme.dart';

class MinigamesPage extends StatelessWidget {
  static const routeName = '/minigames';

  const MinigamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final games = const [
      {'title': 'Local Multiplayer', 'subtitle': 'Play with a friend', 'icon': Icons.groups},
      {'title': 'Build a Strong password', 'subtitle': 'Build an unhackable password in record time', 'icon': Icons.lock_outline_rounded},
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
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose a minigame to play',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: games.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final game = games[index];
                    return Ink(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).extension<AppColors>()?.cardBackground ?? Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(game['icon'] as IconData, size: 34, color: Theme.of(context).colorScheme.secondary),
                              const SizedBox(height: 16),
                              Text(
                                game['title'] as String,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                game['subtitle'] as String,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 13),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Coming soon',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
