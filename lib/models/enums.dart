enum Difficulty {
  easy,
  medium,
  hard,
  expert,
}
enum ThreatType {
  credentialHarvesting,
  malware,
  invoiceFraud,
  businessEmailCompromise,
  deliveryScams,
  fakePasswordResets,
  fakeSharedDocuments,
  impersonatedServices,
  techSupportScams,
}
enum ScenarioCategory {
  phishing,
  legitimate,
}
enum Indicator {
  genericGreeting,
  urgency,
  suspiciousDomain,
  suspiciousLink,
  credentialRequest,
  attachment,
  spellingErrors,
  unusualRequest,
  impersonation,
}