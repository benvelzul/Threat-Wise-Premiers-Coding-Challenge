import '../core/constants.dart';
import '../models/enums.dart';

class EmailComponents {
  // --- GREETINGS BY DIFFICULTY ---
  static const Map<Difficulty, List<String>> phishingGreetings = {
    Difficulty.easy: [
      'Dear Valued Customer,',
      'Attention Account Holder,',
    ],
    Difficulty.medium: [
      'Dear Employee,',
      'Hello,',
    ],
    Difficulty.hard: [
      'Hi $UserFirstName,',
    ],
    Difficulty.expert: [
      'Quick request $UserFirstName,',
    ],
  };

  static const Map<Difficulty, List<String>> legitimateGreetings = {
    Difficulty.easy: ['Hi $UserFirstName,'],
    Difficulty.medium: ['Dear $UserFirstName $UserLastName,'],
    Difficulty.hard: ['Hi there, $UserFirstName!'],
    Difficulty.expert: ['Hey $UserFirstName,'],
  };

  // --- ISSUES BY THREAT TYPE ---
  // Tip: You can group issues by ThreatType to match the exact attack vector!
  static const Map<ThreatType, List<String>> threatIssues = {
    ThreatType.credentialHarvesting: [
      'Your password is set to expire in 2 hours. Please reset it immediately.',
      'An unauthorized sign-in attempt was detected from Moscow, Russia.',
    ],
    ThreatType.malware: [
      'Please see the attached document for the required workspace setup steps.',
    ],
    ThreatType.invoiceFraud: [
      'Overdue invoice (#88402) requires immediate payment to avoid penalty.',
    ],
    ThreatType.businessEmailCompromise: [
      'I am currently in a meeting and need you to handle an urgent wire request.',
    ],
    ThreatType.qrScam: [
      'Multi-factor authentication reset required. Scan the attached QR code.',
    ],
  };

  // --- CALL TO ACTIONS BY DIFFICULTY ---
  static const Map<Difficulty, List<String>> phishingCTAs = {
    Difficulty.easy: [
      'Click the secure link below to verify your identity immediately:',
    ],
    Difficulty.medium: [
      'Log into your portal within 24 hours to preserve access:',
    ],
    Difficulty.hard: [
      'Re-enter your credentials at the corporate portal below:',
    ],
    Difficulty.expert: [
      'Review the requested details here:',
    ],
  };

  static const Map<Difficulty, List<String>> legitimateCTAs = {
    Difficulty.easy: ['If this was you, no further action is required.'],
    Difficulty.medium: ['You can view the full activity log in your account settings.'],
    Difficulty.hard: ['Check your dashboard for complete details on this release.'],
    Difficulty.expert: ['Details available on internal wiki.'],
  };

  // --- SIGNATURES ---
  static const Map<Difficulty, List<String>> phishingSignatures = {
    Difficulty.easy: ['Automated System Administrator'],
    Difficulty.medium: ['Best regards,\nAccounts Department'],
    Difficulty.hard: ['Sincerely,\nIT Support Desk'],
    Difficulty.expert: ['Best, \nMark Suckenberg'],
  };

  static const Map<Difficulty, List<String>> legitimateSignatures = {
    Difficulty.easy: ['Cheers,\nSlack Automated Bot'],
    Difficulty.medium: ['Thanks,\nThe GitHub Security Team'],
    Difficulty.hard: ['Best,\nYour IT Workspace Team'],
    Difficulty.expert: ['Regards,\nOperations Team'],
  };
}