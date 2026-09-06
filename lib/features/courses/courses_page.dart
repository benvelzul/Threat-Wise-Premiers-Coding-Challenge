import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/theme.dart';
import 'course_divider.dart';

class CourseDetailsPage extends StatefulWidget {
  static const routeName = '/courses';
  final String assetPath;

  const CourseDetailsPage({
    super.key,
    this.assetPath = 'assets/courses/course1.md',
  });

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  int _currentQuestionIndex = 0;

  Future<Course> _loadCourse() async {
    try {
      final markdown = await rootBundle.loadString(widget.assetPath);

      final parsedCourse = CourseParser().parse(markdown);

      return parsedCourse;
    } catch (e, stacktrace) {
      debugPrint('Error loading course: $e\n$stacktrace');
      rethrow;
    }
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
        title: const Text("Course"),
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
      body: FutureBuilder<Course>(
        future: _loadCourse(),
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
                      "Could not find '${widget.assetPath}'",
                      style: TextStyle(color: subtitleColor),
                    ),
                  ],
                ),
              ),
            );
          }
          final course = snapshot.data!;
          final courseContent = Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 8, 24),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
              child: MarkdownBody(
                data: course.information.trim().isEmpty
                    ? "# Markdown Content Was Empty\nCheck your parser logic or file content."
                    : course.information,
                selectable: true,
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
            ),
          );

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: IntrinsicHeight(
                    child: constraints.maxWidth >= 900
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: courseContent),
                              Expanded(child: _buildQuizSection(course, theme)),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              courseContent,
                              _buildQuizSection(course, theme),
                            ],
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildQuizSection(Course course, ThemeData theme) {
    if (course.questions.isEmpty) {
      return const Center(
        child: Text(
          'No Questions Found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final colorScheme = theme.colorScheme;
    final accentColor =
        theme.extension<AppColors>()?.featureChat ?? colorScheme.primary;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Quiz",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Question ${_currentQuestionIndex + 1} of ${course.questions.length}',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          _buildQuestionCard(course.questions[_currentQuestionIndex], theme),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _currentQuestionIndex == 0
                      ? null
                      : () {
                          setState(() => _currentQuestionIndex--);
                        },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                FilledButton.icon(
                  onPressed:
                      _currentQuestionIndex == course.questions.length - 1
                      ? null
                      : () {
                          setState(() => _currentQuestionIndex++);
                        },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion question, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final accentColor =
        theme.extension<AppColors>()?.featureChat ?? colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Difficulty: ${question.difficulty}",
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Points: ${question.points}",
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
