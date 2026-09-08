import 'package:flutter/material.dart';
import '../../core/xp_system/xp_manager.dart';

class PhishingPair {
  final String term;
  final String definition;

  PhishingPair({required this.term, required this.definition});
}

class GameCard {
  final String id;
  final String pairId;
  final String text;
  final bool isTerm;
  bool isFlipped;
  bool isMatched;

  GameCard({
    required this.id,
    required this.pairId,
    required this.text,
    required this.isTerm,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});
  static const String routeName = '/matching pairs';

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  static const int _roundPairCount = 8;
  static const int _roundXpReward = 5;

  final List<PhishingPair> _pairsData = [
    PhishingPair(
      term: 'Spear Phishing',
      definition: 'Targeted attack using personal info like name or title.',
    ),
    PhishingPair(
      term: 'Whaling',
      definition: 'Phishing aimed specifically at high-level executives.',
    ),
    PhishingPair(
      term: 'Smishing',
      definition: 'A phishing attempt carried out over SMS text messages.',
    ),
    PhishingPair(
      term: 'Vishing',
      definition: 'Voice call scam impersonating a trusted authority.',
    ),
    PhishingPair(
      term: 'Clone Phishing',
      definition: 'Resending a real email with malicious links or attachments.',
    ),
    PhishingPair(
      term: 'Angler Phishing',
      definition:
          'Targeting social media users via fake customer support accounts.',
    ),
    PhishingPair(
      term: 'Barrel Phishing',
      definition:
          'Sending a harmless email first to build trust before attacking.',
    ),
    PhishingPair(
      term: 'Quishing',
      definition: 'Using malicious QR codes to trick users into bad websites.',
    ),
    PhishingPair(
      term: 'Watering Hole',
      definition: 'Infecting a site frequented by a specific targeted group.',
    ),
    PhishingPair(
      term: 'Pretexting',
      definition:
          'Creating a fake scenario to trick targets into sharing data.',
    ),
    PhishingPair(
      term: 'Typosquatting',
      definition:
          'Registering misspelled web domains to fool unsuspecting visitors.',
    ),
    PhishingPair(
      term: 'BEC Scam',
      definition:
          'Impersonating executives to trick employees into sending funds.',
    ),
    PhishingPair(
      term: 'Baiting',
      definition: 'Luring victims with free items or physical media like USBs.',
    ),
    PhishingPair(
      term: 'Domain Spoofing',
      definition:
          'Falsifying an email header or web address to appear legitimate.',
    ),
    PhishingPair(
      term: 'Pharming',
      definition:
          'Redirecting website traffic to a fake site without user knowledge.',
    ),
    PhishingPair(
      term: 'Tabnabbing',
      definition: 'Rewriting unattended browser tabs to mimic login pages.',
    ),
  ];

  List<GameCard> _cards = [];
  GameCard? _firstSelectedCard;
  bool _isProcessing = false;
  int _movesCount = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    List<GameCard> loadedCards = [];
    final selectedPairs = List<PhishingPair>.from(_pairsData)..shuffle();

    for (int i = 0; i < _roundPairCount; i++) {
      final pair = selectedPairs[i];
      final pairId = 'pair_$i';

      loadedCards.add(
        GameCard(
          id: '${pairId}_term',
          pairId: pairId,
          text: pair.term,
          isTerm: true,
        ),
      );

      loadedCards.add(
        GameCard(
          id: '${pairId}_def',
          pairId: pairId,
          text: pair.definition,
          isTerm: false,
        ),
      );
    }

    loadedCards.shuffle();

    setState(() {
      _cards = loadedCards;
      _firstSelectedCard = null;
      _isProcessing = false;
      _movesCount = 0;
    });
  }

  void _onCardTapped(GameCard selectedCard) {
    if (_isProcessing || selectedCard.isFlipped || selectedCard.isMatched) {
      return;
    }

    setState(() {
      selectedCard.isFlipped = true;
    });

    if (_firstSelectedCard == null) {
      _firstSelectedCard = selectedCard;
    } else {
      _movesCount++;
      _isProcessing = true;

      if (_firstSelectedCard!.pairId == selectedCard.pairId) {
        setState(() {
          _firstSelectedCard!.isMatched = true;
          selectedCard.isMatched = true;
          _firstSelectedCard = null;
          _isProcessing = false;
        });
        _checkWinCondition();
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _firstSelectedCard!.isFlipped = false;
              selectedCard.isFlipped = false;
              _firstSelectedCard = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  void _checkWinCondition() {
    if (_cards.every((card) => card.isMatched)) {
      XpManager.instance.addXp(_roundXpReward);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Great Job!'),
          content: Text(
            'You matched all phishing terms in $_movesCount moves.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchedPairsCount = _cards.where((c) => c.isMatched).length ~/ 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phishing Match'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _startNewGame),
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Moves: $_movesCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Matched: $matchedPairsCount / $_roundPairCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 29),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return GestureDetector(
                  onTap: () => _onCardTapped(card),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      color: card.isMatched
                          ? Colors.green.shade100
                          : (card.isFlipped
                                ? Colors.blue.shade50
                                : Colors.indigo),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: card.isMatched
                            ? Colors.green
                            : (card.isFlipped
                                  ? Colors.blue
                                  : Colors.indigoAccent),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: card.isFlipped || card.isMatched
                          ? Text(
                              card.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: card.isTerm ? 16 : 12,
                                fontWeight: card.isTerm
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: card.isMatched
                                    ? Colors.green.shade900
                                    : Colors.black87,
                              ),
                            )
                          : const Icon(
                              Icons.security,
                              color: Colors.white,
                              size: 36,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
