import 'package:flutter/material.dart';

class UrlItem {
  final String url;
  final bool isLegit;
  final String explanation;

  UrlItem({
    required this.url,
    required this.isLegit,
    required this.explanation,
  });
}

class UrlSafetySwipeScreen extends StatefulWidget {
  const UrlSafetySwipeScreen({Key? key}) : super(key: key);
  static const String routeName = '/url-safety-swipe';

  @override
  State<UrlSafetySwipeScreen> createState() => _UrlSafetySwipeScreenState();
}

class _UrlSafetySwipeScreenState extends State<UrlSafetySwipeScreen> {
  final List<UrlItem> _urlList = [
    UrlItem(
      url: 'https://accounts.google.com/signin',
      isLegit: true,
      explanation: '✅ Official Google login domain using HTTPS.',
    ),
    UrlItem(
      url: 'http://security-update-google.net/login',
      isLegit: false,
      explanation:
          '❌ Phishing! Google uses google.com, not google.net or HTTP.',
    ),
    UrlItem(
      url: 'https://www.paypal.com/myaccount/transfer',
      isLegit: true,
      explanation: '✅ Genuine PayPal address.',
    ),
    UrlItem(
      url: 'https://paypa1.com-security-check.info',
      isLegit: false,
      explanation:
          '❌ Typosquatting! Notice the "1" instead of "l" and extra subdomains.',
    ),
    UrlItem(
      url: 'https://www.amazon.com/gp/css/homepage.html',
      isLegit: true,
      explanation: '✅ Official Amazon account management page.',
    ),
    UrlItem(
      url: 'http://amazon-prime-refund-claim.org',
      isLegit: false,
      explanation:
          '❌ Suspicious domain attempting to trick users expecting a refund.',
    ),
  ];

  int _currentIndex = 0;
  int _score = 0;
  String? _feedback;
  bool? _lastAnswerCorrect;

  void _answer(bool userThoughtLegit) {
    if (_feedback != null)
      return; // Prevent double taps during feedback display

    final currentUrl = _urlList[_currentIndex];
    final isCorrect = userThoughtLegit == currentUrl.isLegit;

    setState(() {
      _lastAnswerCorrect = isCorrect;
      _feedback = currentUrl.explanation;
      if (isCorrect) {
        _score += 10;
      }
    });

    // Pause briefly so the player can read the feedback before moving to the next URL
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      if (_currentIndex < _urlList.length - 1) {
        setState(() {
          _currentIndex++;
          _feedback = null;
          _lastAnswerCorrect = null;
        });
      } else {
        _showEndDialog();
      }
    });
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Game Complete!'),
        content: Text('Your Score: $_score / ${_urlList.length * 10}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _feedback = null;
                _lastAnswerCorrect = null;
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _urlList[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Safety Check'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $_score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'URL ${_currentIndex + 1} of ${_urlList.length}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // URL Display Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.language,
                        size: 48,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentItem.url,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Feedback Container
              SizedBox(
                height: 70,
                child: _feedback != null
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _lastAnswerCorrect == true
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _lastAnswerCorrect == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _feedback!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _lastAnswerCorrect == true
                                  ? Colors.green.shade900
                                  : Colors.red.shade900,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _feedback == null
                          ? () => _answer(false)
                          : null,
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        'FAKE / PHISHING',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _feedback == null ? () => _answer(true) : null,
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        'LEGIT / SAFE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
