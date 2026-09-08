import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'matching_pairs.dart';
import 'url_game.dart';

class MinigamesPage extends StatelessWidget {
  static const routeName = '/minigames';

  const MinigamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final games = const [
      {
        'title': 'Pairs',
        'subtitle': 'Match the cards',
        'icon': Icons.grid_view,
        'connectedPage': MatchingGameScreen.routeName,
      },
      {
        'title': 'URL Safety',
        'subtitle': 'Swipe to identify safe URLs',
        'icon': Icons.link,
        'connectedPage': UrlSafetySwipeScreen.routeName,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minigames'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                          color:
                              Theme.of(
                                context,
                              ).extension<AppColors>()?.cardBackground ??
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.14),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () {
                            final String? connectedPage =
                                game['connectedPage'] as String?;
                            if (connectedPage != null) {
                              Navigator.pushNamed(context, connectedPage);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                game['icon'] as IconData,
                                size: 34,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                game['title'] as String,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                game['subtitle'] as String,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
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
