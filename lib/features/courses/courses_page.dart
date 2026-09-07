import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/theme.dart';
import '../../core/xp_system/xp_manager.dart';
import 'course_divider.dart';
import 'grade_course.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

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
  final List<QuestionResult> _results = [];
  final Set<int> _answeredQuestionIndexes = {};
  bool _isShowingAnswerFeedback = false;

  bool get _isCourseCompleted =>
      XpManager.instance.isCourseCompleted(widget.assetPath);

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

  Future<void> _finishQuiz(Course course) async {
    final totalPoints = _results.fold<int>(
      0,
      (sum, result) => sum + result.pointsEarned,
    );

    final totalPossiblePoints = course.questions.fold<int>(
      0,
      (sum, question) => sum + question.points,
    );

    final completedPerfectly =
        _results.length == course.questions.length &&
        _results.every((result) => result.correct);
    if (completedPerfectly) {
      await XpManager.instance.completeCourse(
        courseId: widget.assetPath,
        xpReward: totalPossiblePoints * 2,
      );
    } else if (totalPoints > 5) {
      await XpManager.instance.addXp(totalPoints);
    }

    if (!mounted) return;

    Confetti.launch(
      context,
      options: ConfettiOptions(
        particleCount: completedPerfectly ? 300 : 150,
        spread: completedPerfectly ? 160 : 80,
        y: 0.6,
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            completedPerfectly ? 'Course Completed' : 'Quiz Completed',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                completedPerfectly
                    ? 'assets/images/Gargoyle.png' // Trophy or success illustration
                    : 'assets/images/Gargoyle.png', // Secondary or default illustration
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 16),
              Text(
                completedPerfectly
                    ? 'Perfect score!'
                    : 'Next time you will do even better!',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (completedPerfectly) ...[
                _buildRewardStat(
                  icon: Icons.bolt,
                  label: 'XP Earned',
                  value: '+$totalPoints*2',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRewardStat(
                      icon: Icons.star_outline_rounded,
                      label: 'Score',
                      value: '$totalPoints',
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    _buildRewardStat(
                      icon: Icons.flag_outlined,
                      label: 'Total',
                      value: '$totalPossiblePoints',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ],
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            if (!completedPerfectly)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentQuestionIndex = 0;
                    _results.clear();
                    _answeredQuestionIndexes.clear();
                  });
                },
                child: const Text('Restart Quiz'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleAnswerSelected(
    Course course,
    QuizQuestion question,
    int selectedAnswer,
  ) async {
    if (_isShowingAnswerFeedback ||
        _answeredQuestionIndexes.contains(_currentQuestionIndex)) {
      return;
    }

    final questionIndex = _currentQuestionIndex;
    await XpManager.instance.markCourseAttempted(widget.assetPath);
    final result = QuizGrader().gradeQuestion(
      question: question,
      selectedAnswer: selectedAnswer,
    );

    setState(() {
      _isShowingAnswerFeedback = true;
      _answeredQuestionIndexes.add(questionIndex);
      _results.add(result);
    });

    if (result.correct) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 150, spread: 80, y: 0.6),
      );
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isCorrect = result.correct;
        final primaryColor = isCorrect ? Colors.green : Colors.orangeAccent;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.only(top: 24),
          title: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: primaryColor.withAlpha(30),
                child: Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: primaryColor,
                  size: 36,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isCorrect ? 'Awesome Job!' : 'Nice Try!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect
                      ? Colors.green.shade800
                      : Colors.orange.shade900,
                ),
              ),
            ],
          ),
          content: Text(
            isCorrect
                ? 'You earned +${result.pointsEarned} points!'
                : 'The correct answer was option ${result.correctAnswer + 1}.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 16),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    setState(() {
      _isShowingAnswerFeedback = false;
      if (questionIndex < course.questions.length - 1) {
        _currentQuestionIndex = questionIndex + 1;
      }
    });

    if (questionIndex == course.questions.length - 1) {
      await _finishQuiz(course);
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              if (constraints.maxWidth >= 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: 8),
                        child: courseContent,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _buildQuizSection(course, theme),
                      ),
                    ),
                  ],
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [courseContent, _buildQuizSection(course, theme)],
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
    final cardColor =
        theme.extension<AppColors>()?.cardBackground ?? colorScheme.surface;
    final accentColor =
        theme.extension<AppColors>()?.featureChat ?? colorScheme.primary;

    if (_isCourseCompleted) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Column(
          children: [
            Icon(Icons.verified_rounded, size: 48, color: accentColor),
            const SizedBox(height: 12),
            Text(
              'Course completed',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text('You answered every question correctly.'),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      decoration: BoxDecoration(
        color: cardColor,
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
          _buildQuestionCard(
            course.questions[_currentQuestionIndex],
            course,
            theme,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed:
                      _isShowingAnswerFeedback || _currentQuestionIndex == 0
                      ? null
                      : () {
                          setState(() => _currentQuestionIndex--);
                        },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                FilledButton.icon(
                  onPressed:
                      _isShowingAnswerFeedback ||
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

  Widget _buildQuestionCard(
    QuizQuestion question,
    Course course,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;
    final accentColor =
        theme.extension<AppColors>()?.featureChat ?? colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
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
          const SizedBox(height: 16),
          ...List.generate(question.answers.length, (index) {
            final answer = question.answers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: OutlinedButton(
                onPressed:
                    _isShowingAnswerFeedback ||
                        _answeredQuestionIndexes.contains(_currentQuestionIndex)
                    ? (_results.length == course.questions.length
                          ? () => _finishQuiz(course)
                          : null)
                    : () => _handleAnswerSelected(course, question, index),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: accentColor),
                  foregroundColor: accentColor,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(answer),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRewardStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.65),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
