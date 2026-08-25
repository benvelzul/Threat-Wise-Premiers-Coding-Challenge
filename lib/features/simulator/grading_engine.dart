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

    for (final userThreat in threatTypesAns) {
      if (threatTypes.contains(userThreat)) {
        msg.writeln('You correctly identified ${userThreat.name}.\n+5 pts');
        score += 5;
      } else {
        msg.writeln('You missed ${userThreat.name}.\n -2 pts');
        score -= 2;
      }
    }

    for (final actualThreat in threatTypes) {
      if (!threatTypesAns.contains(actualThreat)) {
        msg.writeln('Incorrect choice: ${actualThreat.name} was not a threat.\n-5 pts');
        score -= 5;
      }
    }

    for (final userIndicator in indicatorsAns) {
      if (indicators.contains(userIndicator)) {
        msg.writeln('You correctly identified ${userIndicator.name}.\n+7 pts');
        score += 7;
      } else {
        msg.writeln('You missed ${userIndicator.name}.\n-2 pts');
        score -= 2;
      }
    }

    for (final actualIndicator in indicators) {
      if (!indicatorsAns.contains(actualIndicator)) {
        msg.writeln('Incorrect choice: ${actualIndicator.name} is not an indicator.\n-7 pts');
        score -= 7;
      }
    }

  } else if (!phishingAns && phishing) {
    msg.writeln('Incorrect, this scenario was legitimate.');
  } else if (phishingAns && !phishing) {
    msg.writeln('Incorrect, this scenario was a phishing attempt.');
  } else {
    msg.writeln('Correct, this scenario was legitimate.\n+20 pts');
    score += 20;
  }

  if (score < 0) score = 0;

  if (difficulty != Difficulty.easy) {
    msg.writeln('Difficulty multiplier: ${scoreMultiplier}x');
  }
  msg.writeln('-----------------------------------');
  msg.writeln('Total: $score x $scoreMultiplier = ${score * scoreMultiplier} points');

  final double finalScore = score * scoreMultiplier;
  return (finalScore, msg.toString());
}