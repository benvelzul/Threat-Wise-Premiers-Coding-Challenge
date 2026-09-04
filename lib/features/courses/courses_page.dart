import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/theme.dart';

class CourseDetailsPage extends StatelessWidget {
  static const routeName = '/courses';
  final String assetPath;

  const CourseDetailsPage({
    super.key,
    this.assetPath = 'assets/courses/course1.md',
  });

  Future<String> _loadMarkdownData() async {
    return await rootBundle.loadString(assetPath);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColors>();
    final cardColor = appColors?.cardBackground ?? colorScheme.surface;
    final accentColor = appColors?.featureChat ?? colorScheme.primary;
    final subtitleColor =
        appColors?.featureSubtitle ?? colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        title: const Text('Course Overview'),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<String>(
        future: _loadMarkdownData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: accentColor));
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Failed to load course details",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Could not find '$assetPath'",
                      style: TextStyle(color: subtitleColor),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Markdown(
              data: snapshot.data ?? '',
              selectable: true,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                h1: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  height: 1.4,
                ),
                h2: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
                h3: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                ),
                p: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: colorScheme.onSurface.withValues(alpha: 0.87),
                ),
                listBullet: theme.textTheme.bodyMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
                blockquoteDecoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    left: BorderSide(color: accentColor, width: 4),
                  ),
                ),
                blockquotePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                code: theme.textTheme.bodySmall?.copyWith(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  fontFamily: 'monospace',
                  color: accentColor,
                ),
                codeblockDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                codeblockPadding: const EdgeInsets.all(16),
                tableBorder: TableBorder.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
                tableHead: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              onTapLink: (text, href, title) {
                if (href != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Link tapped: $href'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: colorScheme.onPrimary,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: () {},
            icon: const Icon(Icons.play_circle_fill_rounded),
            label: const Text(
              "Start Course",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
