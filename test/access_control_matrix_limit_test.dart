import 'package:flutter_test/flutter_test.dart';
import 'package:threat_wise/features/minigames/access_control_matrix_drop.dart';

void main() {
  test('buildAccessDeck caps the game at nine questions', () {
    final deck = buildAccessDeck();
    expect(deck.length, equals(9));
    expect(deck, isNotEmpty);
  });
}
