import '../core/constants.dart';

class EmailComponents {
  // --- GREETINGS ---
  static const List<String> phishingGreetings = [
    'Dear Valued Customer,',
    'Attention Account Holder,',
    'Dear Employee,',
    'Urgent Notice:',
    'Hello,',
  ];

  static const List<String> legitimateGreetings = [
    'Hi $UserFirstName,',
    'Hello $UserFirstName,',
    'Dear $UserFirstName $UserLastName,',
    'Hi there,$UserFirstName!',
  ];

  // --- ISSUES / TRIGGERS ---
  static const List<String> phishingIssues = [
    'We detected an unauthorized sign-in attempt from an unknown device in Moscow, Russia.',
    'Your corporate account password is set to expire in 2 hours.',
    'Your direct deposit details were updated, but verification failed.',
    'An overdue invoice (#88402) requires immediate payment to avoid legal action.',
    'Your cloud storage quota has been exceeded and files will be permanently deleted.',
  ];

  static const List<String> legitimateIssues = [
    'Your monthly team workspace summary is now available to view.',
    'A pull request you were tagged in has been merged into main.',
    'Your scheduled password change was completed successfully.',
    'A new security update (v2.4.1) is ready for deployment.',
  ];

  // --- CALL TO ACTIONS (CTAs) ---
  static const List<String> phishingCTAs = [
    'Click the secure link below to verify your identity immediately:',
    'Open the attached PDF document to review the dispute details:',
    'Log into your portal within 24 hours to prevent account suspension:',
    'Re-enter your credentials at the link below to preserve your access:',
  ];

  static const List<String> legitimateCTAs = [
    'You can view the full activity log in your account settings.',
    'If this was you, no further action is required.',
    'Check your dashboard for complete details on this release.',
  ];

  // --- SIGNATURES ---
  static const List<String> phishingSignatures = [
    'Regards,\nGlobal Security Team',
    'Best regards,\nAccounts Payable Department',
    'Sincerely,\nIT Support Desk',
    'Automated System Administrator',
  ];

  static const List<String> legitimateSignatures = [
    'Thanks,\nThe GitHub Security Team',
    'Best,\nYour IT Workspace Team',
    'Cheers,\nSlack Automated Bot',
  ];
}