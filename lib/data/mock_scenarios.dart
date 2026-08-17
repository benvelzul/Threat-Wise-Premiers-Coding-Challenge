import '../models/email_scenario.dart';
import '../models/enums.dart';
import '../models/email_component.dart';
import 'email_components.dart';
import 'dart:math';

// Helper to get random enum value
T _getRandomEnumValue<T>(List<T> enumValues) {
  final random = Random();
  return enumValues[random.nextInt(enumValues.length)];
}

// Random data generators
String _getRandomSenderName(bool isPhishing) {
  final random = Random();
  final phishingNames = [
    'Account Security Team',
    'IT Support Desk',
    'System Administrator',
    'Support Team',
    'Security Department',
    'Admin Team',
  ];
  final legitimateNames = [
    'System Notifications',
    'Team Updates',
    'Platform Support',
    'Service Alerts',
    'Workspace Assistant',
    'Notification Center',
  ];
  final names = isPhishing ? phishingNames : legitimateNames;
  return names[random.nextInt(names.length)];
}

String _getRandomSenderEmail(bool isPhishing) {
  final random = Random();
  if (isPhishing) {
    final domains = ['support@', 'admin@', 'verify@', 'security@'];
    final fakes = ['fake-sec.com', 'phish-corp.net', 'verify-now.io', 'secure-check.co'];
    return '${domains[random.nextInt(domains.length)]}${fakes[random.nextInt(fakes.length)]}';
  } else {
    final domains = ['no-reply@', 'notifications@', 'alerts@'];
    final legits = ['company.com', 'workspace.com', 'platform.io', 'service.co'];
    return '${domains[random.nextInt(domains.length)]}${legits[random.nextInt(legits.length)]}';
  }
}

String _getRandomRecipient() {
  final random = Random();
  final firstNames = ['alex', 'jordan', 'casey', 'morgan', 'taylor', 'sam'];
  final lastNames = ['smith', 'johnson', 'williams', 'brown', 'jones', 'miller'];
  final domains = ['company.com', 'work.io', 'org.net', 'corp.co'];
  final first = firstNames[random.nextInt(firstNames.length)];
  final last = lastNames[random.nextInt(lastNames.length)];
  final domain = domains[random.nextInt(domains.length)];
  return '$first.$last@$domain';
}

String _getRandomSubject(bool isPhishing, Difficulty difficulty, ThreatType? threatType) {
  final random = Random();
  if (isPhishing) {
    if (threatType == ThreatType.credentialHarvesting) {
      final subjects = [
        'URGENT: Verify Your Account',
        'ACTION REQUIRED: Security Alert',
        'Confirm Your Identity Now',
        'Account Lock Warning',
        'Suspicious Activity Detected',
      ];
      return subjects[random.nextInt(subjects.length)];
    } else if (threatType == ThreatType.malware) {
      final subjects = [
        'Important Document Attached',
        'Updated Security Policy',
        'Required Setup Instructions',
        'Latest System Update',
        'Critical Patch Available',
      ];
      return subjects[random.nextInt(subjects.length)];
    } else if (threatType == ThreatType.invoiceFraud) {
      final subjects = [
        'Invoice Awaiting Payment',
        'Outstanding Balance Notice',
        'Urgent: Payment Required',
        'Invoice #${random.nextInt(99999)} Past Due',
        'Billing Alert',
      ];
      return subjects[random.nextInt(subjects.length)];
    } else {
      final subjects = [
        'Quick Request',
        'Need Your Help',
        'Urgent Matter',
        'Time-Sensitive Request',
        'Action Needed',
      ];
      return subjects[random.nextInt(subjects.length)];
    }
  } else {
    final subjects = [
      'Team Update',
      'Workspace Notification',
      'System Alert',
      'Weekly Summary',
      'Service Status',
      'New Features Available',
    ];
    return subjects[random.nextInt(subjects.length)];
  }
}

EmailComponent _getRandomComponentFromMap<T>(Map<T, List<EmailComponent>> map, T key) {
  final random = Random();
  final list = map[key];

  if (list == null || list.isEmpty) {
    return EmailComponent(
      text: 'Action required for your account.',
      indicators: [Indicator.urgency],
    );
  }

  return list[random.nextInt(list.length)];
}

String _getCorrectAnswerText(bool isThreat, ThreatType? threatType) {
  if (isThreat && threatType != null) {
    return threatType.name;
  }
  return 'legitimate';
}

EmailScenario generateScenarioFor({
  ThreatType? threatType,
  Difficulty? difficulty,
  ScenarioCategory? category,
}) {
  final random = Random();

  final Difficulty selectedDifficulty = difficulty ?? _getRandomEnumValue(Difficulty.values);
  final ThreatType selectedThreatType = threatType ?? _getRandomEnumValue(ThreatType.values);
  final ScenarioCategory selectedCategory =
      category ?? (threatType != null ? ScenarioCategory.phishing : _getRandomEnumValue(ScenarioCategory.values));
  final bool isThreat = selectedCategory == ScenarioCategory.phishing;

  final ThreatType? threat = isThreat ? selectedThreatType : null;

  String greeting;
  String issue;
  String cta;
  String signature;
  List<Indicator> chosenIndicators = [];

  if (isThreat && threat != null) {
    final greetingComponent = _getRandomComponentFromMap(
      EmailComponents.phishingGreetings,
      selectedDifficulty,
    );
    final issueComponent = _getRandomComponentFromMap(
      EmailComponents.threatIssues,
      threat,
    );
    final ctaComponent = _getRandomComponentFromMap(
      EmailComponents.phishingCTAs,
      selectedDifficulty,
    );
    final signatureComponent = _getRandomComponentFromMap(
      EmailComponents.phishingSignatures,
      selectedDifficulty,
    );

    greeting = greetingComponent.text;
    issue = issueComponent.text;
    cta = ctaComponent.text;
    signature = signatureComponent.text;
    chosenIndicators = [
      ...greetingComponent.indicators,
      ...issueComponent.indicators,
      ...ctaComponent.indicators,
      ...signatureComponent.indicators,
    ].toSet().toList();
  } else {
    final greetingComponent = _getRandomComponentFromMap(
      EmailComponents.legitimateGreetings,
      selectedDifficulty,
    );
    final ctaComponent = _getRandomComponentFromMap(
      EmailComponents.legitimateCTAs,
      selectedDifficulty,
    );
    final signatureComponent = _getRandomComponentFromMap(
      EmailComponents.legitimateSignatures,
      selectedDifficulty,
    );
    final issues = [
      'Your regular workspace digest is ready for viewing.',
      'New updates are available in your account.',
      'Weekly summary of your team activities.',
      'Security report for your account.',
      'System maintenance completed successfully.',
    ];

    greeting = greetingComponent.text;
    issue = issues[random.nextInt(issues.length)];
    cta = ctaComponent.text;
    signature = signatureComponent.text;
    chosenIndicators = [
      ...greetingComponent.indicators,
      ...ctaComponent.indicators,
      ...signatureComponent.indicators,
    ].toSet().toList();
  }

  final fullBody = '$greeting\n\n$issue\n\n$cta\n\n$signature';

  return EmailScenario(
    id: 'scen-${random.nextInt(999999)}',
    category: selectedCategory,
    difficulty: selectedDifficulty,
    isThreat: isThreat,
    threatType: threat,
    indicators: chosenIndicators,
    explanation: isThreat
        ? 'This was a ${threat?.name ?? 'unknown'} phishing attempt.'
        : 'This was a legitimate notification.',
    correctAnswer: _getCorrectAnswerText(isThreat, threat),
    emailData: EmailData(
      senderName: _getRandomSenderName(isThreat),
      senderEmail: _getRandomSenderEmail(isThreat),
      recipient: _getRandomRecipient(),
      subject: _getRandomSubject(isThreat, selectedDifficulty, threat),
      body: fullBody,
    ),
  );
}

EmailScenario generateScenario() {
  return generateScenarioFor();
}