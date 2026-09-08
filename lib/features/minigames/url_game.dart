import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/xp_system/xp_manager.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

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
  static const int _roundUrlCount = 10;
  static const int _roundXpReward = 5;

  final List<UrlItem> _urlList = [
    UrlItem(
      url: 'https://accounts.google.com/signin',
      isLegit: true,
      explanation: 'Official Google login domain using HTTPS.',
    ),
    UrlItem(
      url: 'http://security-update-google.net/login',
      isLegit: false,
      explanation: 'Phishing! Google uses google.com, not google.net or HTTP.',
    ),
    UrlItem(
      url: 'https://www.paypal.com/myaccount/transfer',
      isLegit: true,
      explanation: 'Genuine PayPal address.',
    ),
    UrlItem(
      url: 'https://paypa1.com-security-check.info',
      isLegit: false,
      explanation:
          'Typosquatting! Notice the "1" instead of "l" and extra subdomains.',
    ),
    UrlItem(
      url: 'https://www.amazon.com/gp/css/homepage.html',
      isLegit: true,
      explanation: 'Official Amazon account management page.',
    ),
    UrlItem(
      url: 'http://amazon-prime-refund-claim.org',
      isLegit: false,
      explanation:
          'Suspicious domain attempting to trick users expecting a refund.',
    ),
    UrlItem(
      url: 'https://login.microsoftonline.com',
      isLegit: true,
      explanation: 'Official Microsoft sign-in domain using HTTPS.',
    ),
    UrlItem(
      url: 'https://microsoft-login-security.co/account',
      isLegit: false,
      explanation: 'Phishing! The domain is not owned by Microsoft.',
    ),
    UrlItem(
      url: 'https://www.apple.com/support',
      isLegit: true,
      explanation: 'Official Apple support page.',
    ),
    UrlItem(
      url: 'http://appleid-verify-account.info',
      isLegit: false,
      explanation: 'Phishing! The domain is not apple.com and uses HTTP.',
    ),
    UrlItem(
      url: 'https://www.apple.com/shop/goto/account',
      isLegit: true,
      explanation: 'Official Apple Store account page.',
    ),
    UrlItem(
      url: 'http://appleid-support-auth.com/verify',
      isLegit: false,
      explanation: 'Phishing! Apple uses apple.com, not third-party domains.',
    ),
    UrlItem(
      url: 'https://www.microsoft.com/en-us/account',
      isLegit: true,
      explanation: 'Official Microsoft account landing page.',
    ),
    UrlItem(
      url: 'https://login-microsoftonline-verify.xyz/login',
      isLegit: false,
      explanation:
          'Suspicious domain using a shady top-level domain (.xyz) to imitate Microsoft.',
    ),
    UrlItem(
      url: 'https://www.netflix.com/youraccount',
      isLegit: true,
      explanation: 'Genuine Netflix account portal.',
    ),
    UrlItem(
      url: 'http://netflix-billing-update-required.net',
      isLegit: false,
      explanation:
          'Unsecure HTTP connection on an unauthorized domain trying to steal billing info.',
    ),
    UrlItem(
      url: 'https://www.facebook.com/login/',
      isLegit: true,
      explanation: 'Official Facebook login URL.',
    ),
    UrlItem(
      url: 'https://faceb00k-security-center.com/checkpoint',
      isLegit: false,
      explanation:
          'Typosquatting! Uses zeros ("00") instead of the letter "o".',
    ),
    UrlItem(
      url: 'https://github.com/login',
      isLegit: true,
      explanation: 'Official GitHub login page.',
    ),
    UrlItem(
      url: 'https://github.com.login-verify.top/auth',
      isLegit: false,
      explanation:
          'Subdomain trickery! The actual domain is login-verify.top, not github.com.',
    ),
    UrlItem(
      url: 'https://www.chase.com/personal/banking',
      isLegit: true,
      explanation: 'Official Chase Bank portal.',
    ),
    UrlItem(
      url: 'http://chasebank-alert-verify-account.com',
      isLegit: false,
      explanation:
          'Phishing scam attempting to mimic Chase banking alerts over unencrypted HTTP.',
    ),
    UrlItem(
      url: 'https://www.wellsfargo.com',
      isLegit: true,
      explanation: 'Legitimate Wells Fargo homepage.',
    ),
    UrlItem(
      url: 'https://wellsfarg0-online.com/auth',
      isLegit: false,
      explanation:
          'Typosquatting using the digit "0" instead of the letter "o".',
    ),
    UrlItem(
      url: 'https://www.instagram.com/accounts/login/',
      isLegit: true,
      explanation: 'Official Instagram login URL.',
    ),
    UrlItem(
      url: 'https://instagram-badge-verify.com',
      isLegit: false,
      explanation: 'Misspelled "instagram" on a fake verification domain.',
    ),
    UrlItem(
      url: 'https://twitter.com/i/flow/login',
      isLegit: true,
      explanation: 'Official Twitter/X login flow.',
    ),
    UrlItem(
      url: 'http://twitter-blue-tick-claim.info',
      isLegit: false,
      explanation:
          'Social engineering scam targeting users looking for account verification.',
    ),
    UrlItem(
      url: 'https://www.dropbox.com/login',
      isLegit: true,
      explanation: 'Genuine Dropbox sign-in domain.',
    ),
    UrlItem(
      url: 'https://dl-dropbox-files-shared.site/login',
      isLegit: false,
      explanation:
          'Unrecognized domain using a cheap TLD (.site) to spoof file sharing.',
    ),
    UrlItem(
      url: 'https://www.linkedin.com/checkpoint/lg/login',
      isLegit: true,
      explanation: 'Official LinkedIn login portal.',
    ),
    UrlItem(
      url: 'https://linkedin-jobs-application.online/auth',
      isLegit: false,
      explanation: 'Fake employment phishing domain imitating LinkedIn.',
    ),
    UrlItem(
      url: 'https://www.spotify.com/us/account/overview/',
      isLegit: true,
      explanation: 'Official Spotify account page.',
    ),
    UrlItem(
      url: 'http://spotify-premium-free-code.com',
      isLegit: false,
      explanation:
          'Classic phishing trap promising free premium subscriptions.',
    ),
    UrlItem(
      url: 'https://www.bankofamerica.com',
      isLegit: true,
      explanation: 'Official Bank of America homepage.',
    ),
    UrlItem(
      url: 'https://bankofamericadefense-alert.com/login',
      isLegit: false,
      explanation:
          'Fake security alert domain designed to panic users into sharing credentials.',
    ),
    UrlItem(
      url: 'https://store.steampowered.com/login/',
      isLegit: true,
      explanation: 'Official Steam Store login page.',
    ),
    UrlItem(
      url: 'https://steamcommimity.com/tradeoffer',
      isLegit: false,
      explanation:
          'Typosquatting! Replaces "community" with "commimity" to steal gaming accounts.',
    ),
    UrlItem(
      url: 'https://www.usps.com',
      isLegit: true,
      explanation: 'Official United States Postal Service site.',
    ),
    UrlItem(
      url: 'http://usps-package-redelivery-notice.com/track',
      isLegit: false,
      explanation:
          'Common SMS/email phishing scam regarding fake package redeliveries.',
    ),
    UrlItem(
      url: 'https://www.adobe.com/account.html',
      isLegit: true,
      explanation: 'Official Adobe account settings page.',
    ),
    UrlItem(
      url: 'https://adobe-pdf-viewer-update.com/download',
      isLegit: false,
      explanation:
          'Malware distribution masquerading as an Adobe software update.',
    ),
    UrlItem(
      url: 'https://discord.com/login',
      isLegit: true,
      explanation: 'Official Discord login page.',
    ),
    UrlItem(
      url: 'https://dlscord-nitro-gift.com/claim',
      isLegit: false,
      explanation:
          'Typosquatting ("dlscord" with an L) tricking users with fake free Nitro offers.',
    ),
    UrlItem(
      url: 'https://www.ebay.com/signin',
      isLegit: true,
      explanation: 'Official eBay sign-in portal.',
    ),
    UrlItem(
      url: 'http://ebay-buyer-protection-dispute.net',
      isLegit: false,
      explanation: 'Unencrypted scam page exploiting buyer trust.',
    ),
    UrlItem(
      url: 'https://www.uber.com/us/en/ride/',
      isLegit: true,
      explanation: 'Official Uber rides homepage.',
    ),
    UrlItem(
      url: 'https://uber-driver-payout-bonus.org/login',
      isLegit: false,
      explanation:
          'Fake driver portal attempting to compromise payout details.',
    ),
    UrlItem(
      url: 'https://www.walmart.com/account/login',
      isLegit: true,
      explanation: 'Official Walmart account sign-in page.',
    ),
    UrlItem(
      url: 'http://walmart-giftcard-winner-2026.com',
      isLegit: false,
      explanation: 'Phishing trap offering fake gift card rewards.',
    ),
  ];

  int _currentIndex = 0;
  int _score = 0;
  String? _feedback;
  bool? _lastAnswerCorrect;

  void _answer(bool userThoughtLegit) {
    if (_feedback != null) return;

    final currentUrl = _urlList[_currentIndex];
    final isCorrect = userThoughtLegit == currentUrl.isLegit;

    setState(() {
      _lastAnswerCorrect = isCorrect;
      _feedback = currentUrl.explanation;
      if (isCorrect) {
        _score += 10;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      if (_currentIndex < _roundUrlCount - 1) {
        setState(() {
          _currentIndex++;
          _feedback = null;
          _lastAnswerCorrect = null;
        });
      } else {
        Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 150,
            spread: 80,
            y: 0.6,
          ),
        );
        _showEndDialog();
      }
    });
  }

  Future<void> _showEndDialog() async {
    await XpManager.instance.addXp(_roundXpReward);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Complete!'),
        content: Text('Your Score: $_score / ${_roundUrlCount * 10}'),
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
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final currentItem = _urlList[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Safety Check'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
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
        child: Container(
          color: colorScheme.surface,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Identify the URL',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_currentIndex + 1} / $_roundUrlCount',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _roundUrlCount,
                minHeight: 7,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: colorScheme.primaryContainer,
                color: appColors?.featureGames ?? colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Card(
                color: appColors?.cardBackground ?? colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.onSurface.withValues(alpha: 0.14),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(Icons.link, size: 46, color: colorScheme.secondary),
                      const SizedBox(height: 16),
                      Text(
                        currentItem.url,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _feedback == null
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _lastAnswerCorrect == true
                              ? colorScheme.primaryContainer
                              : colorScheme.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _lastAnswerCorrect == true
                                ? colorScheme.primary
                                : colorScheme.error,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _feedback!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _lastAnswerCorrect == true
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.error,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _feedback == null
                          ? () => _answer(false)
                          : null,
                      icon: const Icon(Icons.close),
                      label: const Text('Fake / phishing'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _feedback == null ? () => _answer(true) : null,
                      icon: const Icon(Icons.check),
                      label: const Text('Legit / safe'),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
