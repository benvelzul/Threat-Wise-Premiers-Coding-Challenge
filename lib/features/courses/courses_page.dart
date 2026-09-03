import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class CourseDetailsPage extends StatelessWidget {
  static const routeName = '/courses';
  final String assetPath;

  const CourseDetailsPage({
    super.key,
    this.assetPath = 'assets/courses/information/course1.md',
  });

  Future<String> _loadMarkdownData() async {
    return await rootBundle.loadString(assetPath);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Course Overview",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _loadMarkdownData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            );
          }

          return Markdown(
            data: snapshot.data ?? "",
            selectable: true,
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.0),
            styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
              h1: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                height: 1.4,
              ),
              h2: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
              h3: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              p: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.87),
              ),
              listBullet: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              blockquoteDecoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 4,
                  ),
                ),
              ),
              blockquotePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              code: theme.textTheme.bodySmall?.copyWith(
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                fontFamily: 'monospace',
                color: theme.colorScheme.primary,
              ),
              codeblockDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              codeblockPadding: const EdgeInsets.all(16),
              tableBorder: TableBorder.all(
                color: theme.colorScheme.outlineVariant,
                width: 1,
              ),
              tableHead: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            onTapLink: (text, href, title) {
              if (href != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Link tapped: $href"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}