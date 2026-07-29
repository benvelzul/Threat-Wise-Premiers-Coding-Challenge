import '../models/email_scenario.dart';
import 'email_components.dart';
import 'dart:math';

String buildEmailBody({
  required String greeting,
  required String issue,
  required String cta,
  required String signature,
  String? actionLink,
}) {
  final linkText = actionLink != null ? '\n\n👉 $actionLink\n' : '';
  return '$greeting\n\n$issue\n\n$cta$linkText\n\n$signature';
}

final List<EmailScenario> mockScenarios = [
  // Variation 1: Password Urgency Theme
  EmailScenario(
    id: 'phish-001',
    category: 'Phishing',
    difficulty: 'Easy',
    isThreat: true,
    threatType: 'Credential Harvesting',
    indicators: [
      'Generic greeting',
      'Artificial urgency',
      'External verification domain'
    ],
    explanation: 'Fake security alerts use urgent threats of account closure to trick you into entering credentials on spoofed pages.',
    emailData: EmailData(
      senderName: 'IT Helpdesk',
      senderEmail: 'support@auth-company-portal.com',
      recipient: 'alex@threatwise.org',
      subject: 'URGENT: Password Expiration Notice',
      body: buildEmailBody(
        greeting: EmailComponents.phishingGreetings[1], // "Attention Account Holder,"
        issue: EmailComponents.phishingIssues[1],     // Password expiring
        cta: EmailComponents.phishingCTAs[2],       // "Log into your portal..."
        actionLink: 'https://auth-company-portal.com/login',
        signature: EmailComponents.phishingSignatures[2],
      ),
    ),
  ),

  // Variation 2: Security Alert Theme (Uses different starters & issues)
  EmailScenario(
    id: 'phish-002',
    category: 'Phishing',
    difficulty: 'Medium',
    isThreat: true,
    threatType: 'Account Takeover Trap',
    indicators: [
      'Vague greeting',
      'Unverified login location designed to induce panic',
      'Suspicious link'
    ],
    explanation: 'Attackers cause panic by claiming your account was compromised, hoping you will blindly click their link.',
    emailData: EmailData(
      senderName: 'Security Desk',
      senderEmail: 'alert@sec-verify-login.net',
      recipient: 'alex@threatwise.org',
      subject: 'Unusual Login Attempt Detected',
      body: buildEmailBody(
        greeting: EmailComponents.phishingGreetings[0], // "Dear Valued Customer,"
        issue: EmailComponents.phishingIssues[0],     // Unauthorized sign-in attempt
        cta: EmailComponents.phishingCTAs[0],       // "Click the secure link..."
        actionLink: 'https://sec-verify-login.net/challenge',
        signature: EmailComponents.phishingSignatures[0],
      ),
    ),
  ),

  // Variation 3: Legitimate Notification
  EmailScenario(
    id: 'safe-001',
    category: 'Legitimate',
    difficulty: 'Easy',
    isThreat: false,
    threatType: 'None',
    indicators: [],
    explanation: 'Personalized greeting, authentic domain, and no high-pressure demand to click a link.',
    emailData: EmailData(
      senderName: 'Dev Workspace',
      senderEmail: 'no-reply@github.com',
      recipient: 'alex@threatwise.org',
      subject: 'PR #42 Merged Successfully',
      body: buildEmailBody(
        greeting: EmailComponents.legitimateGreetings[0], // "Hi Alex,"
        issue: EmailComponents.legitimateIssues[1],      // PR merged
        cta: EmailComponents.legitimateCTAs[0],        // "View full activity log..."
        signature: EmailComponents.legitimateSignatures[0],
      ),
    ),
  ),
];

// Helper function to pick a random item from any List
T getRandomElement<T>(List<T> list) {
  final random = Random();
  return list[random.nextInt(list.length)];
}

// Generates a dynamic scenario on the fly
EmailScenario generateRandomScenario() {
  final random = Random();
  final bool isThreat = random.nextBool(); // 50% chance for Threat vs Legitimate

  if (isThreat) {
    // Generate Phishing Scenario
    return EmailScenario(
      id: 'gen-phish-${random.nextInt(1000)}',
      category: 'Phishing',
      difficulty: 'Medium',
      isThreat: true,
      threatType: 'Credential Harvesting',
      indicators: [
        'Generic greeting',
        'Suspicious domain',
        'Urgent request'
      ],
      explanation: 'Fake alerts use urgency and lookalike domains to steal login credentials.',
      emailData: EmailData(
        senderName: 'IT Support Desk',
        senderEmail: 'support@company-verify-security.com',
        recipient: 'alex@threatwise.org',
        subject: 'URGENT: Action Required on Your Account',
        body: buildEmailBody(
          greeting: getRandomElement(EmailComponents.phishingGreetings),
          issue: getRandomElement(EmailComponents.phishingIssues),
          cta: getRandomElement(EmailComponents.phishingCTAs),
          actionLink: 'https://company-verify-security.com/login',
          signature: getRandomElement(EmailComponents.phishingSignatures),
        ),
      ),
    );
  } else {
    // Generate Legitimate Scenario
    return EmailScenario(
      id: 'gen-safe-${random.nextInt(1000)}',
      category: 'Legitimate',
      difficulty: 'Easy',
      isThreat: false,
      threatType: 'None',
      indicators: [],
      explanation: 'This is an authentic system email from a verified domain requiring no risky actions.',
      emailData: EmailData(
        senderName: 'GitHub Team',
        senderEmail: 'noreply@github.com',
        recipient: 'alex@threatwise.org',
        subject: 'Workspace Update Notification',
        body: buildEmailBody(
          greeting: getRandomElement(EmailComponents.legitimateGreetings),
          issue: getRandomElement(EmailComponents.legitimateIssues),
          cta: getRandomElement(EmailComponents.legitimateCTAs),
          signature: getRandomElement(EmailComponents.legitimateSignatures),
        ),
      ),
    );
  }
}