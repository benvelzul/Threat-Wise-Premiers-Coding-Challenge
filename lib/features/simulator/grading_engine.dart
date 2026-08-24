import '../../models/enums.dart';

(double, String) gradeAnswer({
  required bool phishing,
  required bool phishingAns,
  required Difficulty difficulty,
  required List<ThreatType> threatTypes,
  required List<ThreatType> threatTypesAns,
  required List<Indicator> indicators,
  required List<Indicator> indicatorsAns,
}) {
  double score = 0;
  StringBuffer msg = StringBuffer('Here is a summary of your performance:\n\n');

  final double scoreMultiplier = switch (difficulty) {
    Difficulty.medium => 1.2,
    Difficulty.hard => 1.5,
    Difficulty.expert => 2.0,
    _ => 1.0,
  };

  if (phishing && phishingAns) {
    msg.writeln('Correct! You correctly identified the email as a phishing attempt.\n+20 pts');
    score += 20;

    for (final threat in threatTypes) {
      if (threatTypesAns.contains(threat)) {
        msg.writeln('You were correct, ${threat.name} was a threat type. \n+5 pts');
        score += 5;
      } else {
        msg.writeln('You missed ${threat.name}.');
      }
    }
 
    for (final indicator in indicators) {
      msg.writeln(indicator.name);
      if (indicatorsAns.contains(indicator)) {
        msg.writeln('You correctly identified ${indicator.name} as a phishing indicator. \n+7 pts');
        score += 7;
      } else {
        msg.writeln('You missed ${indicator.name}.');
      }
    }
  } else if (phishingAns && !phishing) {
    msg.writeln('Incorrect, this scenario was legitimate.');
  } else if (!phishingAns && phishing) {
    msg.writeln('Incorrect, this scenario was a phishing attempt.');
  } else {
    msg.writeln('Correct, this scenario was legitimate.\n+20 pts');
    score += 20;
  }

  if (difficulty != Difficulty.easy) {
    msg.writeln('Difficulty multiplier: ${scoreMultiplier}x');
  }
  msg.writeln('-----------------------------------');
  msg.writeln('Total: $score x $scoreMultiplier = ${score * scoreMultiplier} points');

  final double finalScore = score * scoreMultiplier;
  return (finalScore, msg.toString());
}