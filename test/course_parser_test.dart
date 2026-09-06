import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threat_wise/features/courses/course_divider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses quiz questions from the course markdown', () async {
    final markdown = await rootBundle.loadString('assets/courses/course1.md');

    final course = CourseParser().parse(markdown);

    expect(course.questions, hasLength(10));
    expect(
      course.questions.first.question,
      'What does the acronym VoIP stand for?',
    );
    expect(course.questions.first.correctAnswer, 1);
  });
}
