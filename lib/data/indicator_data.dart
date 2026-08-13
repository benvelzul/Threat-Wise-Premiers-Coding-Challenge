import '../models/enums.dart';

class IndicatorInfo {
  final String title;
  final String explanation;

  const IndicatorInfo({
    required this.title,
    required this.explanation,
  });
}

const Map<Indicator, IndicatorInfo> indicatorInfo = {
  Indicator.genericGreeting: IndicatorInfo(
    title: 'Generic greeting',
    explanation:
        'Scam emails often use generic greetings instead of addressing you by name.',
  ),

  Indicator.urgency: IndicatorInfo(
    title: 'Artificial urgency',
    explanation:
        'Attackers may create a false deadline to pressure you into acting without checking the message.',
  ),

  Indicator.suspiciousDomain: IndicatorInfo(
    title: 'Suspicious domain',
    explanation:
        'The sender domain does not match the organisation it claims to represent.',
  ),

  Indicator.suspiciousLink: IndicatorInfo(
    title: 'Suspicious link',
    explanation:
        'The link may lead to a website designed to steal information or credentials.',
  ),
};