import 'package:flutter/material.dart';

import '../widgets/make_image.dart';

class MascotIntro extends StatelessWidget {
  final bool showMessage;

  const MascotIntro({this.showMessage = true, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 92,
              height: 112,
              child: LocalImageWidget(
                imagePath: 'assets/images/Gargoyle.png',
                width: 92,
                height: 112,
              ),
            ),
            if (showMessage) ...[
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to ThreatWise',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Oh. You're finally here \n We have a problem. \nPeople are getting tricked every day.\nAnd apparently, I'm supposed to stop that.\nUnfortunately, I can't do everything myself.\nSo I'm going to train you.\nWelcome to ThreatWise! This application will teach you cybersecurity.\n\n By the way, I'm Ward, the gargoyle. I'm here to help you learn and protect yourself from cyber threats. And i will be floating around the app. \n\n Let's get started!",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.78),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
