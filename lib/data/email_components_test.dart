import '../core/constants.dart';
import '../models/enums.dart';
import '../models/email_component.dart';

class EmailComponents {
  // --- GREETINGS BY DIFFICULTY ---
  static const Map<Difficulty, List<String>> phishingGreetings = {
    Difficulty.easy: [
      'Dear Valued Customer,',
      'Attention Account Holder,',
      'Dear Customer,',
      'Important Notice,',
      'Dear Sir or Madam,',
      'To Our Valued User,',
      'Account Security Alert,',
    ],
    Difficulty.medium: [
      'Dear Employee,',
      'Hello,',
      'Hi Team Member,',
      'Dear Staff Member,',
      'Hello Colleague,',
      'Attention Team Member,',
      'Dear Department Member,',
    ],
    Difficulty.hard: [
      'Hi $UserFirstName,',
      'Hello $UserFirstName,',
      'Good morning, $UserFirstName,',
      'Hey $UserFirstName,',
      'A quick note for you, $UserFirstName,',
      'Hope you are well, $UserFirstName,',
    ],
    Difficulty.expert: [
      'Quick request $UserFirstName,',
      'Could you help me with this, $UserFirstName?',
      'A quick favour, $UserFirstName,',
      'Following up with you, $UserFirstName,',
      'Do you have a moment, $UserFirstName?',
      'Can I ask you something, $UserFirstName?',
    ],
  };

  static const Map<Difficulty, List<String>> legitimateGreetings = {
    Difficulty.easy: [
      'Hi $UserFirstName,',
      'Hello $UserFirstName,',
      'Hey $UserFirstName,',
      'Good morning, $UserFirstName,',
      'Hope you are doing well, $UserFirstName,',
      'Welcome, $UserFirstName,',
    ],
    Difficulty.medium: [
      'Dear $UserFirstName $UserLastName,',
      'Hello $UserFirstName $UserLastName,',
      'Good morning, $UserFirstName $UserLastName,',
      'Dear Mr./Ms. $UserLastName,',
      'Greetings, $UserFirstName $UserLastName,',
      'Hello there, $UserFirstName $UserLastName,',
    ],
    Difficulty.hard: [
      'Hi there, $UserFirstName!',
      'Hello there, $UserFirstName!',
      'Good to hear from you, $UserFirstName!',
      'Hope your day is going well, $UserFirstName!',
      'Welcome back, $UserFirstName!',
      'Thanks for getting in touch, $UserFirstName!',
    ],
    Difficulty.expert: [
      'Hey $UserFirstName,',
      'Hiya $UserFirstName,',
      'Morning, $UserFirstName,',
      'Hey there, $UserFirstName,',
      'Good to see you, $UserFirstName,',
      'Thanks for your message, $UserFirstName,',
    ],
  };
  // --- ISSUES BY THREAT TYPE ---
  // Tip: You can group issues by ThreatType to match the exact attack vector!
  static const Map<ThreatType, List<String>> threatIssues = {
    ThreatType.credentialHarvesting: [
      'Your password is set to expire in 2 hours. Please reset it immediately.',
      'An unauthorized sign-in attempt was detected from Moscow, Russia.',
      'Your account will be locked unless you verify your identity today.',
      'We detected unusual activity and need you to confirm your login details.',
      'Your security verification is incomplete. Please update your account information.',
      'A new device was added to your account. Confirm whether this activity was authorized.',
      'Your access token has expired. Sign in again to restore account access.',
    ],
    ThreatType.malware: [
      'Please see the attached document for the required workspace setup steps.',
      'The latest staff schedule is included in the attached file.',
      'Please open the attached security update before your next login.',
      'The attached document contains the revised project requirements.',
      'Your device compatibility report is available in the attached file.',
      'Please review the attached delivery notice and confirm the information.',
    ],
    ThreatType.invoiceFraud: [
      'Overdue invoice (#88402) requires immediate payment to avoid penalty.',
      'Invoice #91736 is awaiting approval and must be processed today.',
      'Your account has an outstanding balance that requires urgent review.',
      'Please confirm the updated payment details for the attached invoice.',
      'A late payment fee may be applied unless invoice #56219 is resolved promptly.',
      'The finance department has flagged an unpaid invoice for immediate attention.',
    ],
    ThreatType.businessEmailCompromise: [
      'I am currently in a meeting and need you to handle an urgent wire request.',
      'Please keep this request confidential until the transaction is complete.',
      'I need you to purchase several gift cards for an important client meeting.',
      'Can you urgently send the updated banking information to our supplier?',
      'Please approve this payment on my behalf while I am unavailable.',
      'The usual approval process is delayed, so please complete this transfer immediately.',
    ],
  };

  // --- CALL TO ACTIONS BY DIFFICULTY ---
  static const Map<Difficulty, List<EmailComponent>> phishingCTAs = {
    Difficulty.easy: [
      EmailComponent(
        text: 'Click the secure link below to verify your identity immediately:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),

      EmailComponent(
        text: 'Tap here now to prevent your account from being suspended:',
        indicators: [
          Indicator.urgency,
        ],
      ),
      EmailComponent(
        text: 'Verify your account using the button below:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Click below to confirm your personal information:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Open the secure verification page to restore access:',
        indicators: [
          Indicator.urgency,
          Indicator.suspiciousLink, 
        ],
      ),
      EmailComponent(
        text: 'Use the link below to complete your security check:',
        indicators: [
          Indicator.urgency,
        ],
      ),
    ],
    Difficulty.medium: [
      EmailComponent(
        text: 'Log into your portal within 24 hours to preserve access:',
        indicators: [
          Indicator.urgency,
        ],
      ),
      EmailComponent(
        text: 'Confirm your account details before the deadline expires:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Sign in to review the recent security notification:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest
        ],
      ),
      EmailComponent(
        text: 'Complete the required verification step from your dashboard:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Access the employee portal to resolve this account issue:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Review and approve the pending security request:',
        indicators: [
          Indicator.urgency,
        ],
      ),
    ],
    Difficulty.hard: [
      EmailComponent(
        text: 'Re-enter your credentials at the corporate portal below:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Authenticate through the company sign-in page to continue:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Use the internal access page to confirm your session:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Sign in again to synchronise your account permissions:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Verify your identity through the organisation’s access portal:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
      EmailComponent(
        text: 'Update your authentication details using the page below:',
        indicators: [
          Indicator.urgency,
          Indicator.credentialRequest,
        ],
      ),
    ],
    Difficulty.expert: [
      EmailComponent(
        text: 'Review the requested details here:',
        indicators: [
          Indicator.urgency,
        ],
      ),
      EmailComponent(
        text: 'Could you take a moment to confirm the information below?',
        indicators: [
          Indicator.urgency,
        ],
      ),
      EmailComponent(
        text: 'Please check the latest account activity when convenient:',
        indicators: [
          Indicator.urgency,
        ],
      ),
      EmailComponent(
        text: 'When you have a moment, review the attached request:',
        indicators: [
          Indicator.urgency,
        ],
      ),
      EmailComponent(
        text: 'Take a quick look at the pending request:',
        indicators: [
          Indicator.urgency,
        ],
      ),
      EmailComponent(
        text: 'Please verify that the details shown are correct:',
        indicators: [
          Indicator.urgency,
        ],
      ),
      EmailComponent(
        text: 'Could you take a moment to confirm the information below?',
        indicators: [
          Indicator.urgency,
        ],
      ),
    ],
  };

  static const Map<Difficulty, List<String>> legitimateCTAs = {
    Difficulty.easy: [
      'If this was you, no further action is required.',
      'If you recognise this activity, you can safely ignore this message.',
      'No action is needed if you made this change.',
      'You do not need to respond if everything looks correct.',
      'If this notification is expected, you can dismiss it.',
      'Please continue using your account normally if this was your activity.',
    ],
    Difficulty.medium: [
      'You can view the full activity log in your account settings.',
      'Review your recent sign-in history from the security section.',
      'Open your account settings to see more information about this event.',
      'Your notification preferences can be managed from the account menu.',
      'Check the security page for a complete record of recent activity.',
      'You can update your account settings whenever convenient.',
    ],
    Difficulty.hard: [
      'Check your dashboard for complete details on this release.',
      'Review the release notes from your usual project dashboard.',
      'The latest changes are listed in the team workspace.',
      'You can find the complete update history in the project console.',
      'Open the dashboard to review the affected features and changes.',
      'Additional information is available in the standard project tools.',
    ],
    Difficulty.expert: [
      'Details available on internal wiki.',
      'Additional context is documented in the team knowledge base.',
      'Please refer to the usual internal documentation for more information.',
      'The relevant change notes are available in the project repository.',
      'You can review the implementation details in the team workspace.',
      'Further information is recorded in the standard engineering documentation.',
    ],
  };

  // --- SIGNATURES ---
  static const Map<Difficulty, List<String>> phishingSignatures = {
    Difficulty.easy: [
      'Automated System Administrator',
      'Account Security Team',
      'Online Services Department',
      'System Notification Service',
      'Customer Support Centre',
      'Automated Verification Team',
    ],
    Difficulty.medium: [
      'Best regards,\nAccounts Department',
      'Kind regards,\nCustomer Accounts Team',
      'Regards,\nBilling Support',
      'Sincerely,\nFinance Operations',
      'Best wishes,\nAccount Services',
      'Regards,\nAdministrative Support',
    ],
    Difficulty.hard: [
      'Sincerely,\nIT Support Desk',
      'Kind regards,\nInformation Technology Services',
      'Best regards,\nCorporate Helpdesk',
      'Regards,\nNetwork Administration Team',
      'Sincerely,\nTechnical Support Services',
      'Best,\nEnterprise Systems Team',
    ],
    Difficulty.expert: [
      'Best, \nMark Suckenberg',
      'Cheers,\nAlex Richardson',
      'Thanks,\nJordan Williams',
      'Regards,\nTaylor Morgan',
      'Best wishes,\nChris Anderson',
      'Thanks again,\nSam Thompson',
    ],
  };

  static const Map<Difficulty, List<String>> legitimateSignatures = {
    Difficulty.easy: [
      'Cheers,\nSlack Automated Bot',
      'Thanks,\nAutomated Notifications',
      'Best,\nWorkspace Assistant',
      'Regards,\nAccount Notification Service',
      'Cheers,\nTeam Updates Bot',
      'Thanks,\nSystem Alerts',
    ],
    Difficulty.medium: [
      'Thanks,\nThe GitHub Security Team',
      'Best regards,\nThe Account Security Team',
      'Regards,\nThe Platform Support Team',
      'Thanks,\nThe Service Administration Team',
      'Sincerely,\nThe Security Operations Team',
      'Best,\nThe Customer Support Team',
    ],
    Difficulty.hard: [
      'Best,\nYour IT Workspace Team',
      'Regards,\nThe Workplace Technology Team',
      'Thanks,\nYour Internal Systems Team',
      'Best regards,\nThe Corporate IT Team',
      'Sincerely,\nThe Digital Services Team',
      'Best,\nThe Technology Operations Team',
    ],
    Difficulty.expert: [
      'Regards,\nOperations Team',
      'Best,\nPlatform Operations',
      'Thanks,\nThe Project Operations Team',
      'Kind regards,\nBusiness Operations',
      'Best wishes,\nService Operations',
      'Regards,\nThe Delivery Team',
    ],
  };
}