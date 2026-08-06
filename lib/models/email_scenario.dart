import 'enums.dart';

class EmailData {
  final String senderName;
  final String senderEmail;
  final String recipient;
  final String subject;
  final String body;

  const EmailData({
    required this.senderName,
    required this.senderEmail,
    required this.recipient,
    required this.subject,
    required this.body,
  });
}

class EmailScenario {
  final String id;
  final ScenarioCategory category; // Enum
  final Difficulty difficulty;     // Enum
  final EmailData emailData;
  final bool isThreat;
  final ThreatType? threatType;    // Enum (Null if legitimate)
  final List<String> indicators;
  final String explanation;

  const EmailScenario({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.emailData,
    required this.isThreat,
    this.threatType,
    required this.indicators,
    required this.explanation,
  });
}