import 'course_divider.dart';

class QuizGrader {
  bool isCorrect({
    required QuizQuestion question,
    required int selectedAnswer,
  }) {
    return selectedAnswer == question.correctAnswer;
  }

  int calculatePoints({
    required QuizQuestion question,
    required int selectedAnswer,
  }) {
    if (isCorrect(question: question, selectedAnswer: selectedAnswer)) {
      return question.points;
    }

    return 0;
  }
}
