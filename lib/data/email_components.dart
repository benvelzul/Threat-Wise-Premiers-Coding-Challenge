import '../core/constants.dart';
import '../models/enums.dart';
import '../models/email_component.dart';

class EmailComponents {
  // Greeting
  static const Map<Difficulty, List<EmailComponent>> phishingGreetings = {
    Difficulty.easy: [
      EmailComponent(
        text: 'Dear Valued Customer,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Attention Account Holder,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Dear Customer,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Important Notice,',
        indicators: [Indicator.genericGreeting, Indicator.urgency],
      ),
      EmailComponent(
        text: 'Dear Sir or Madam,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'To Our Valued User,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Account Security Alert,',
        indicators: [Indicator.genericGreeting, Indicator.urgency],
      ),
    ],
    Difficulty.medium: [
      EmailComponent(
        text: 'Dear Employee,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Hello,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Hi Team Member,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Dear Staff Member,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Hello Colleague,',
        indicators: [Indicator.genericGreeting],
      ),
      EmailComponent(
        text: 'Attention Team Member,',
        indicators: [Indicator.genericGreeting, Indicator.urgency],
      ),
      EmailComponent(
        text: 'Dear Department Member,',
        indicators: [Indicator.genericGreeting],
      ),
    ],
    Difficulty.hard: [
      EmailComponent(
        text: 'Hi $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hello $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Good morning, $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hey $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'A quick note for you, $userFirstName,',
        indicators: [Indicator.urgency],
      ),
      EmailComponent(
        text: 'Hope you are well, $userFirstName,',
        indicators: [],
      ),
    ],
    Difficulty.expert: [
      EmailComponent(
        text: 'Quick request $userFirstName,',
        indicators: [Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Could you help me with this, $userFirstName?',
        indicators: [Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'A quick favour, $userFirstName,',
        indicators: [Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Following up with you, $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Do you have a moment, $userFirstName?',
        indicators: [Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Can I ask you something, $userFirstName?',
        indicators: [Indicator.unusualRequest],
      ),
    ],
  };

  static const Map<Difficulty, List<EmailComponent>> legitimateGreetings = {
    Difficulty.easy: [
      EmailComponent(
        text: 'Hi $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hello $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hey $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Good morning, $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hope you are doing well, $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Welcome, $userFirstName,',
        indicators: [],
      ),
    ],
    Difficulty.medium: [
      EmailComponent(
        text: 'Dear $userFirstName $userLastName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hello $userFirstName $userLastName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Good morning, $userFirstName $userLastName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Dear Mr./Ms. $userLastName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Greetings, $userFirstName $userLastName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hello there, $userFirstName $userLastName,',
        indicators: [],
      ),
    ],
    Difficulty.hard: [
      EmailComponent(
        text: 'Hi there, $userFirstName!',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hello there, $userFirstName!',
        indicators: [],
      ),
      EmailComponent(
        text: 'Good to hear from you, $userFirstName!',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hope your day is going well, $userFirstName!',
        indicators: [],
      ),
      EmailComponent(
        text: 'Welcome back, $userFirstName!',
        indicators: [],
      ),
      EmailComponent(
        text: 'Thanks for getting in touch, $userFirstName!',
        indicators: [],
      ),
    ],
    Difficulty.expert: [
      EmailComponent(
        text: 'Hey $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hiya $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Morning, $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Hey there, $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Good to see you, $userFirstName,',
        indicators: [],
      ),
      EmailComponent(
        text: 'Thanks for your message, $userFirstName,',
        indicators: [],
      ),
    ],
  };
  
  // Issues 
  static const Map<ThreatType, List<EmailComponent>> threatIssues = {
    ThreatType.credentialHarvesting: [
      EmailComponent(
        text: 'Your password is set to expire in 2 hours. Please reset it immediately.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'An unauthorized sign-in attempt was detected from Moscow, Russia.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'Your account will be locked unless you verify your identity today.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'We detected unusual activity and need you to confirm your login details.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'Your security verification is incomplete. Please update your account information.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'A new device was added to your account. Confirm whether this activity was authorized.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'Your access token has expired. Sign in again to restore account access.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
    ],
    ThreatType.malware: [
      EmailComponent(
        text: 'Please see the attached document for the required workspace setup steps.',
        indicators: [Indicator.attachment, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'The latest staff schedule is included in the attached file.',
        indicators: [Indicator.attachment],
      ),
      EmailComponent(
        text: 'Please open the attached security update before your next login.',
        indicators: [Indicator.attachment, Indicator.urgency],
      ),
      EmailComponent(
        text: 'The attached document contains the revised project requirements.',
        indicators: [Indicator.attachment],
      ),
      EmailComponent(
        text: 'Your device compatibility report is available in the attached file.',
        indicators: [Indicator.attachment],
      ),
      EmailComponent(
        text: 'Please review the attached delivery notice and confirm the information.',
        indicators: [Indicator.attachment, Indicator.credentialRequest],
      ),
    ],
    ThreatType.invoiceFraud: [
      EmailComponent(
        text: 'Overdue invoice (#88402) requires immediate payment to avoid penalty.',
        indicators: [Indicator.urgency, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Invoice #91736 is awaiting approval and must be processed today.',
        indicators: [Indicator.urgency, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Your account has an outstanding balance that requires urgent review.',
        indicators: [Indicator.urgency],
      ),
      EmailComponent(
        text: 'Please confirm the updated payment details for the attached invoice.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'A late payment fee may be applied unless invoice #56219 is resolved promptly.',
        indicators: [Indicator.urgency, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'The finance department has flagged an unpaid invoice for immediate attention.',
        indicators: [Indicator.urgency, Indicator.unusualRequest],
      ),
    ],
    ThreatType.businessEmailCompromise: [
      EmailComponent(
        text: 'I am currently in a meeting and need you to handle an urgent wire request.',
        indicators: [Indicator.urgency, Indicator.unusualRequest, Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Please keep this request confidential until the transaction is complete.',
        indicators: [Indicator.unusualRequest, Indicator.impersonation],
      ),
      EmailComponent(
        text: 'I need you to purchase several gift cards for an important client meeting.',
        indicators: [Indicator.urgency, Indicator.unusualRequest, Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Can you urgently send the updated banking information to our supplier?',
        indicators: [Indicator.urgency, Indicator.unusualRequest, Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Please approve this payment on my behalf while I am unavailable.',
        indicators: [Indicator.unusualRequest, Indicator.impersonation],
      ),
      EmailComponent(
        text: 'The usual approval process is delayed, so please complete this transfer immediately.',
        indicators: [Indicator.urgency, Indicator.unusualRequest, Indicator.impersonation],
      ),
    ],
    ThreatType.deliveryScams: [
      EmailComponent(
        text: 'Your package delivery failed. Click here to reschedule for a small fee.',
        indicators: [Indicator.urgency, Indicator.suspiciousLink],
      ),
      EmailComponent(
        text: 'A delivery attempt was made but no one was home. Pay \$2.99 to redeliver.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'Your shipment is being held at customs. Confirm your address to release it.',
        indicators: [Indicator.urgency, Indicator.suspiciousDomain],
      ),
      EmailComponent(
        text: 'Delivery notification: Sign in to view your tracking details and delivery options.',
        indicators: [Indicator.credentialRequest, Indicator.suspiciousLink],
      ),
      EmailComponent(
        text: 'Your parcel could not be delivered. Update payment information to complete delivery.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
    ],
    ThreatType.fakePasswordResets: [
      EmailComponent(
        text: 'Did you request a password reset? If not, your account may be compromised.',
        indicators: [Indicator.urgency, Indicator.suspiciousLink],
      ),
      EmailComponent(
        text: 'Your password was successfully changed. If this was not you, click here immediately.',
        indicators: [Indicator.urgency, Indicator.suspiciousLink],
      ),
      EmailComponent(
        text: 'Password reset requested for your account. Click the link below to cancel this change.',
        indicators: [Indicator.urgency, Indicator.suspiciousLink],
      ),
      EmailComponent(
        text: 'We noticed a login from a new device. Reset your password to secure your account.',
        indicators: [Indicator.urgency, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'Your account security alert: Password reset link expires in 1 hour.',
        indicators: [Indicator.urgency, Indicator.suspiciousLink],
      ),
    ],
    ThreatType.fakeSharedDocuments: [
      EmailComponent(
        text: 'John has shared a document with you. Click to view: Q4_Financial_Report.pdf',
        indicators: [Indicator.suspiciousLink, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'You have been granted access to a shared folder. Sign in to view the contents.',
        indicators: [Indicator.credentialRequest, Indicator.suspiciousLink],
      ),
      EmailComponent(
        text: 'Important: Your manager shared a confidential document. Review required by EOD.',
        indicators: [Indicator.urgency, Indicator.suspiciousLink],
      ),
      EmailComponent(
        text: 'New comment on your shared document. Click here to respond to feedback.',
        indicators: [Indicator.suspiciousLink, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Document sharing notification: Accept the invitation to access the file.',
        indicators: [Indicator.suspiciousLink, Indicator.credentialRequest],
      ),
    ],
    ThreatType.impersonatedServices: [
      EmailComponent(
        text: 'Netflix: Your payment method was declined. Update billing to avoid service interruption.',
        indicators: [Indicator.urgency, Indicator.impersonation, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'Microsoft 365: Your subscription expires today. Renew now to keep your data.',
        indicators: [Indicator.urgency, Indicator.impersonation, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'Amazon: Suspicious activity detected on your account. Verify your identity now.',
        indicators: [Indicator.urgency, Indicator.impersonation, Indicator.credentialRequest],
      ),
      EmailComponent(
        text: 'PayPal: A payment of \$499.99 was sent from your account. Dispute if unauthorized.',
        indicators: [Indicator.urgency, Indicator.impersonation, Indicator.suspiciousLink],
      ),
      EmailComponent(
        text: 'Apple ID: Your account has been locked. Sign in to unlock and restore access.',
        indicators: [Indicator.urgency, Indicator.impersonation, Indicator.credentialRequest],
      ),
    ],
    ThreatType.techSupportScams: [
      EmailComponent(
        text: 'WARNING: Your computer is infected with 5 viruses. Call 1-800-XXX-XXXX immediately.',
        indicators: [Indicator.urgency, Indicator.unusualRequest, Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Microsoft Security Alert: Unauthorized access detected. Contact support now.',
        indicators: [Indicator.urgency, Indicator.impersonation, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Your subscription has expired. Renew within 24 hours to avoid permanent data loss.',
        indicators: [Indicator.urgency, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Critical system error. Download the security patch to fix this issue immediately.',
        indicators: [Indicator.urgency, Indicator.suspiciousLink, Indicator.unusualRequest],
      ),
      EmailComponent(
        text: 'Your device warranty is expiring. Call our technical team to extend coverage.',
        indicators: [Indicator.urgency, Indicator.impersonation, Indicator.unusualRequest],
      ),
    ],
  };

  // CTAs
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

  static const Map<Difficulty, List<EmailComponent>> legitimateCTAs = {
    Difficulty.easy: [
      EmailComponent(
        text: 'If this was you, no further action is required.',
        indicators: [],
      ),
      EmailComponent(
        text: 'If you recognise this activity, you can safely ignore this message.',
        indicators: [],
      ),
      EmailComponent(
        text: 'No action is needed if you made this change.',
        indicators: [],
      ),
      EmailComponent(
        text: 'You do not need to respond if everything looks correct.',
        indicators: [],
      ),
      EmailComponent(
        text: 'If this notification is expected, you can dismiss it.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Please continue using your account normally if this was your activity.',
        indicators: [],
      ),
    ],
    Difficulty.medium: [
      EmailComponent(
        text: 'You can view the full activity log in your account settings.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Review your recent sign-in history from the security section.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Open your account settings to see more information about this event.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Your notification preferences can be managed from the account menu.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Check the security page for a complete record of recent activity.',
        indicators: [],
      ),
      EmailComponent(
        text: 'You can update your account settings whenever convenient.',
        indicators: [],
      ),
    ],
    Difficulty.hard: [
      EmailComponent(
        text: 'Check your dashboard for complete details on this release.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Review the release notes from your usual project dashboard.',
        indicators: [],
      ),
      EmailComponent(
        text: 'The latest changes are listed in the team workspace.',
        indicators: [],
      ),
      EmailComponent(
        text: 'You can find the complete update history in the project console.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Open the dashboard to review the affected features and changes.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Additional information is available in the standard project tools.',
        indicators: [],
      ),
    ],
    Difficulty.expert: [
      EmailComponent(
        text: 'Details available on internal wiki.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Additional context is documented in the team knowledge base.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Please refer to the usual internal documentation for more information.',
        indicators: [],
      ),
      EmailComponent(
        text: 'The relevant change notes are available in the project repository.',
        indicators: [],
      ),
      EmailComponent(
        text: 'You can review the implementation details in the team workspace.',
        indicators: [],
      ),
      EmailComponent(
        text: 'Further information is recorded in the standard engineering documentation.',
        indicators: [],
      ),
    ],
  };

  // Signatures
  static const Map<Difficulty, List<EmailComponent>> phishingSignatures = {
    Difficulty.easy: [
      EmailComponent(
        text: 'Automated System Administrator',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Account Security Team',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Online Services Department',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'System Notification Service',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Customer Support Centre',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Automated Verification Team',
        indicators: [Indicator.impersonation],
      ),
    ],
    Difficulty.medium: [
      EmailComponent(
        text: 'Best regards,\nAccounts Department',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Kind regards,\nCustomer Accounts Team',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Regards,\nBilling Support',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Sincerely,\nFinance Operations',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Best wishes,\nAccount Services',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Regards,\nAdministrative Support',
        indicators: [Indicator.impersonation],
      ),
    ],
    Difficulty.hard: [
      EmailComponent(
        text: 'Sincerely,\nIT Support Desk',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Kind regards,\nInformation Technology Services',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Best regards,\nCorporate Helpdesk',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Regards,\nNetwork Administration Team',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Sincerely,\nTechnical Support Services',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Best,\nEnterprise Systems Team',
        indicators: [Indicator.impersonation],
      ),
    ],
    Difficulty.expert: [
      EmailComponent(
        text: 'Best, \nMark Suckenberg',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Cheers,\nAlex Richardson',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Thanks,\nJordan Williams',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Regards,\nTaylor Morgan',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Best wishes,\nChris Anderson',
        indicators: [Indicator.impersonation],
      ),
      EmailComponent(
        text: 'Thanks again,\nSam Thompson',
        indicators: [Indicator.impersonation],
      ),
    ],
  };

  static const Map<Difficulty, List<EmailComponent>> legitimateSignatures = {
    Difficulty.easy: [
      EmailComponent(
        text: 'Cheers,\nSlack Automated Bot',
        indicators: [],
      ),
      EmailComponent(
        text: 'Thanks,\nAutomated Notifications',
        indicators: [],
      ),
      EmailComponent(
        text: 'Best,\nWorkspace Assistant',
        indicators: [],
      ),
      EmailComponent(
        text: 'Regards,\nAccount Notification Service',
        indicators: [],
      ),
      EmailComponent(
        text: 'Cheers,\nTeam Updates Bot',
        indicators: [],
      ),
      EmailComponent(
        text: 'Thanks,\nSystem Alerts',
        indicators: [],
      ),
    ],
    Difficulty.medium: [
      EmailComponent(
        text: 'Thanks,\nThe GitHub Security Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Best regards,\nThe Account Security Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Regards,\nThe Platform Support Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Thanks,\nThe Service Administration Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Sincerely,\nThe Security Operations Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Best,\nThe Customer Support Team',
        indicators: [],
      ),
    ],
    Difficulty.hard: [
      EmailComponent(
        text: 'Best,\nYour IT Workspace Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Regards,\nThe Workplace Technology Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Thanks,\nYour Internal Systems Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Best regards,\nThe Corporate IT Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Sincerely,\nThe Digital Services Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Best,\nThe Technology Operations Team',
        indicators: [],
      ),
    ],
    Difficulty.expert: [
      EmailComponent(
        text: 'Regards,\nOperations Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Best,\nPlatform Operations',
        indicators: [],
      ),
      EmailComponent(
        text: 'Thanks,\nThe Project Operations Team',
        indicators: [],
      ),
      EmailComponent(
        text: 'Kind regards,\nBusiness Operations',
        indicators: [],
      ),
      EmailComponent(
        text: 'Best wishes,\nService Operations',
        indicators: [],
      ),
      EmailComponent(
        text: 'Regards,\nThe Delivery Team',
        indicators: [],
      ),
    ],
  };
}