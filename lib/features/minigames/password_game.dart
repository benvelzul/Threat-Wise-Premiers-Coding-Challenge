import 'package:flutter/material.dart';


class PasswordGameScreen extends StatefulWidget {
  const PasswordGameScreen({Key? key}) : super(key: key);

  @override
  State<PasswordGameScreen> createState() => _PasswordGameScreenState();
}

class _PasswordGameScreenState extends State<PasswordGameScreen> {
  final TextEditingController _passwordController = TextEditingController();
  
  // Game Rules / Requirements
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _checkPassword() {
    final val = _passwordController.text;
    setState(() {
      _hasMinLength = val.length >= 12;
      _hasUppercase = val.contains(RegExp(r'[A-Z]'));
      _hasLowercase = val.contains(RegExp(r'[a-z]'));
      _hasDigit = val.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = val.contains(RegExp(r'[!@#\$&*~_=+.-]'));
    });
  }

  double get _strengthScore {
    int score = 0;
    if (_hasMinLength) score++;
    if (_hasUppercase) score++;
    if (_hasLowercase) score++;
    if (_hasDigit) score++;
    if (_hasSpecialChar) score++;
    return score / 5.0; // Normalizes score between 0.0 and 1.0
  }

  Color _strengthColor(ColorScheme colorScheme) {
    double score = _strengthScore;
    if (score <= 0.2) return colorScheme.error;
    if (score <= 0.6) return colorScheme.tertiary;
    if (score <= 0.8) return colorScheme.secondary;
    return colorScheme.primary;
  }

  String get _strengthText {
    double score = _strengthScore;
    if (score == 0) return "Empty";
    if (score <= 0.2) return "Very Weak ❌";
    if (score <= 0.6) return "Weak ⚠️";
    if (score <= 0.8) return "Medium 👍";
    if (score < 1.0) return "Strong 💪";
    return "Hacker-Proof! 🏆";
  }

  @override
  Widget build(BuildContext context) {
    bool gameWon = _strengthScore == 1.0;
    final colorScheme = Theme.of(context).colorScheme;
    final strengthColor = _strengthColor(colorScheme);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔐 Password Quest'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Your Mission:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                "Craft a password strong enough to withstand brute-force attacks. Satisfy all the rules below!",
                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Input Field
              TextField(
                controller: _passwordController,
                obscureText: false, // Set to true if you want to hide it, but false is fun for the game aspect!
                style: TextStyle(fontSize: 18, color: colorScheme.onSurface, letterSpacing: 1.5),
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  labelStyle: TextStyle(color: colorScheme.secondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock_outline, color: colorScheme.secondary),
                ),
              ),
              const SizedBox(height: 24),

              // Strength Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Security Status:", style: TextStyle(fontSize: 16)),
                  Text(
                    _strengthText,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: strengthColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _strengthScore,
                  backgroundColor: colorScheme.onSurface.withValues(alpha: 0.16),
                  valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 32),

              // Rules List
                      Text(
                "Requirements:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildRuleTile("At least 12 characters long", _hasMinLength),
              _buildRuleTile("Contains an uppercase letter (A-Z)", _hasUppercase),
              _buildRuleTile("Contains a lowercase letter (a-z)", _hasLowercase),
              _buildRuleTile("Contains a number (0-9)", _hasDigit),
              _buildRuleTile("Contains a special character (!@#\$&*~_=+.-)", _hasSpecialChar),

              const SizedBox(height: 40),

              // Success Message
              AnimatedOpacity(
                opacity: gameWon ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    border: Border.all(color: colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.verified, color: colorScheme.primary, size: 48),
                      SizedBox(height: 8),
                      Text(
                        "Access Granted!",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.primary),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "You created an incredibly secure password.",
                        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleTile(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isMet ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                decoration: isMet ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}