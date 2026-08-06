import '../models/email_scenario.dart';
import '../models/enums.dart';
import 'email_components.dart';
import 'dart:math';

// Helper to pick a random item from a map list safely
String getComponent<T>(Map<T, List<String>> map, T key) {
  final random = Random();
  final list = map[key];
  
  if (list == null || list.isEmpty) {
    // Return a fallback string if the key list doesn't exist yet
    return 'Action required for your account.';
  }
  
  return list[random.nextInt(list.length)];
}

// Generator
EmailScenario generateScenario({
  required Difficulty difficulty,
  required ScenarioCategory category,
  ThreatType? threatType,
}) {
  final random = Random();
  final isThreat = category == ScenarioCategory.phishing;

  // 1. Pick components based on enums
  String greeting;
  String issue;
  String cta;
  String signature;

  if (isThreat) {
    greeting = getComponent(EmailComponents.phishingGreetings, difficulty);
    // Pick issue based on specific ThreatType!
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

  // 2. Build body
  final fullBody = '$greeting\n\n$issue\n\n$cta\n\n$signature';

  // 3. Return full typed scenario
  return EmailScenario(
    id: 'scen-${random.nextInt(9999)}',
    category: category,
    difficulty: difficulty,
    isThreat: isThreat,
    threatType: isThreat ? threatType : null,
    indicators: isThreat ? ['Generic greeting', 'Unverified link'] : [],
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