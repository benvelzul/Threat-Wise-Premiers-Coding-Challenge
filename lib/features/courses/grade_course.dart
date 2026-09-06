import 'course_divider.dart';

class QuestionResult {
  final bool correct;
  final int pointsEarned;
  final int? selectedAnswer;
  final int correctAnswer;

  QuestionResult({
    required this.correct,
    required this.pointsEarned,
    required this.selectedAnswer,
    required this.correctAnswer,
  });
}

class QuizGrader {
  QuestionResult gradeQuestion({
    required QuizQuestion question,
    required int selectedAnswer,
  }) {
    final correct = selectedAnswer == question.correctAnswer;

    return QuestionResult(
      correct: correct,
      pointsEarned: correct ? question.points : 0,
      selectedAnswer: selectedAnswer,
      correctAnswer: question.correctAnswer,
    );
  }
}
