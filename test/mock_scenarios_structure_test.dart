import 'package:flutter_test/flutter_test.dart';
import 'package:threat_wise/data/mock_scenarios.dart';
import 'package:threat_wise/models/enums.dart';

void main() {
  test('generateScenarioFor keeps threat type and difficulty aligned with valid components', () {
    final scenario = generateScenarioFor(
      threatType: ThreatType.malware,
      difficulty: Difficulty.hard,
      category: ScenarioCategory.phishing,
    );

    expect(scenario.isThreat, isTrue);
    expect(scenario.threatType, ThreatType.malware);
    expect(scenario.difficulty, Difficulty.hard);
    expect(scenario.indicators, isNotEmpty);
    expect(scenario.correctAnswer, contains('malware'));
  });

  test('generateScenario still produces a valid answer for legitimate emails', () {
    final scenario = generateScenario();

    expect(scenario.correctAnswer, isNotEmpty);
    expect(scenario.correctAnswer, isA<String>());
  });
}
