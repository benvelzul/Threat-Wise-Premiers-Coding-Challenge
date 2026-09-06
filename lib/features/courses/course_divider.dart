enum QuestionDifficulty { easy, medium, hard, expert }

class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctAnswer;
  final QuestionDifficulty difficulty;
  final int points;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.difficulty,
    required this.points,
  });
}

class Course {
  final String title;
  final String information;
  final List<QuizQuestion> questions;

  Course({
    required this.title,
    required this.information,
    required this.questions,
  });
}

class CourseParser {
  Course parse(String markdown) {
    final cleaned = markdown
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();

    // title

    final titleMatch = RegExp(
      r'^# (?!Quiz$)(.+)$',
      multiLine: true,
    ).firstMatch(cleaned);

    final title = titleMatch?.group(1)?.trim() ?? 'Untitled Course';

    // separation

    final quizMatch = RegExp(
      r'^# Quiz[ \t]*$',
      multiLine: true,
    ).firstMatch(cleaned);

    String information;
    String quizMarkdown;

    if (quizMatch != null) {
      information = cleaned.substring(0, quizMatch.start).trim();
      quizMarkdown = cleaned.substring(quizMatch.end).trim();
    } else {
      information = cleaned;
      quizMarkdown = '';
    }

    final questions = _parseQuestions(quizMarkdown);

    return Course(title: title, information: information, questions: questions);
  }

  List<QuizQuestion> _parseQuestions(String markdown) {
    final questions = <QuizQuestion>[];

    final questionRegex = RegExp(
      r'^### Question[ \t]+\d+[ \t]*$',
      multiLine: true,
    );

    final matches = questionRegex.allMatches(markdown).toList();

    for (int i = 0; i < matches.length; i++) {
      final start = matches[i].end;

      final end = i + 1 < matches.length
          ? matches[i + 1].start
          : markdown.length;

      final section = markdown.substring(start, end).trim();

      final question = _parseQuestion(section);

      if (question != null) {
        questions.add(question);
      }
    }

    return questions;
  }

  QuizQuestion? _parseQuestion(String section) {
    // qs

    final questionMatch = RegExp(
      r'^(.+?)\n\n\*\*Difficulty:\*\*',
      multiLine: true,
      dotAll: true,
    ).firstMatch(section);

    if (questionMatch == null) {
      return null;
    }

    final questionText = questionMatch.group(1)!.trim();

    // hardness

    final difficultyMatch = RegExp(
      r'\*\*Difficulty:\*\*\s*(\w+)',
    ).firstMatch(section);

    if (difficultyMatch == null) {
      return null;
    }

    final difficultyString = difficultyMatch.group(1)!.toLowerCase();

    final difficulty = _parseDifficulty(difficultyString);

    if (difficulty == null) {
      return null;
    }

    // points

    final pointsMatch = RegExp(r'\*\*Points:\*\*\s*(\d+)').firstMatch(section);

    if (pointsMatch == null) {
      return null;
    }

    final points = int.parse(pointsMatch.group(1)!);

    // answers

    final answers = <String>[];
    int? correctAnswer;

    final answerRegex = RegExp(r'^- \[([ xX])\]\s*(.+)$', multiLine: true);

    for (final match in answerRegex.allMatches(section)) {
      final isCorrect = match.group(1)!.toLowerCase() == 'x';
      final answerText = match.group(2)!.trim();

      if (isCorrect) {
        // no 2 correct answers allowed
        if (correctAnswer != null) {
          return null;
        }

        correctAnswer = answers.length;
      }

      answers.add(answerText);
    }

    // recheck

    if (answers.isEmpty) {
      return null;
    }

    if (correctAnswer == null) {
      return null;
    }

    return QuizQuestion(
      question: questionText,
      answers: answers,
      correctAnswer: correctAnswer,
      difficulty: difficulty,
      points: points,
    );
  }

  QuestionDifficulty? _parseDifficulty(String value) {
    switch (value) {
      case 'easy':
        return QuestionDifficulty.easy;

      case 'medium':
        return QuestionDifficulty.medium;

      case 'hard':
        return QuestionDifficulty.hard;

      case 'expert':
        return QuestionDifficulty.expert;

      default:
        return null;
    }
  }
}
