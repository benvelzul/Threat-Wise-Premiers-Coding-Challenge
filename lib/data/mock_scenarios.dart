import '../models/email_scenario.dart';
import '../models/enums.dart';
import 'email_components.dart';
import 'dart:math';

String getComponent<T>(Map<T, List<String>> map, T key) {
  final random = Random();
  final list = map[key];
  
  // Fall back thingy
  if (list == null || list.isEmpty) {
    return 'Action required for your account.';
  }
  
  return list[random.nextInt(list.length)];
}

EmailScenario generateScenario({
  required Difficulty difficulty,
  required ScenarioCategory category,
  ThreatType? threatType,
}) {
  final random = Random();
  final isThreat = category == ScenarioCategory.phishing;

  String greeting;
  String issue;
  String cta;
  String signature;

  if (isThreat) {
    greeting = getComponent(EmailComponents.phishingGreetings, difficulty);
    issue = getComponent(
      EmailComponents.threatIssues, 
      threatType ?? ThreatType.credentialHarvesting,
    );
    cta = getComponent(EmailComponents.phishingCTAs, difficulty);
    signature = getComponent(EmailComponents.phishingSignatures, difficulty);
  } else {
    greeting = getComponent(EmailComponents.legitimateGreetings, difficulty);
    issue = 'Your regular workspace digest is ready for viewing.';
    cta = getComponent(EmailComponents.legitimateCTAs, difficulty);
    signature = getComponent(EmailComponents.legitimateSignatures, difficulty);
  }

  final fullBody = '$greeting\n\n$issue\n\n$cta\n\n$signature';

  return EmailScenario(
    id: 'scen-${random.nextInt(9999)}',
    category: category,
    difficulty: difficulty,
    isThreat: isThreat,
    threatType: isThreat ? threatType : null,
    indicators: isThreat ? [Indicator.genericGreeting, Indicator.suspiciousLink] : [],
    explanation: isThreat 
        ? 'This was a ${threatType?.name} attempt.' 
        : 'This was a legitimate notification.',
    emailData: EmailData(
      senderName: isThreat ? 'IT Support' : 'Company Portal',
      senderEmail: isThreat ? 'support@fake-sec.com' : 'no-reply@company.com',
      recipient: 'alex@threatwise.org',
      subject: isThreat ? 'URGENT: Verify Account' : 'Workspace Update',
      body: fullBody,
    ),
  );
}