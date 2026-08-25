// Password page template
// - Displays dynamic password strength (weak/medium/strong)
// - Prevents native browser/OS password manager autofill popups

import 'package:flutter/material.dart';

enum StrengthChecker { weak, medium, strong }

StrengthChecker checkPasswordStrength(String password) {
  int score = 0;

  if (password.length >= 8) score++;
  if (password.length >= 12) score++;

  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'[a-z]').hasMatch(password)) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

  if (score <= 2) {
    return StrengthChecker.weak;
  } else if (score <= 4) {
    return StrengthChecker.medium;
  } else {
    return StrengthChecker.strong;
  }
}

class PasswordPage extends StatefulWidget {
  static const routeName = '/password';

  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  StrengthChecker? _currentStrength;
  String _currentPassword = '';

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password logic validated successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    return null;
  }

  Color _getStrengthColor(ColorScheme colorScheme) {
    switch (_currentStrength) {
      case StrengthChecker.weak:
        return colorScheme.error;
      case StrengthChecker.medium:
        return colorScheme.tertiary;
      case StrengthChecker.strong:
        return colorScheme.primary;
      case null:
        return colorScheme.onSurface.withValues(alpha: 0.3);
    }
  }

  String _getStrengthText() {
    switch (_currentStrength) {
      case StrengthChecker.weak:
        return 'Weak Password';
      case StrengthChecker.medium:
        return 'Medium Password';
      case StrengthChecker.strong:
        return 'Strong Password';
      case null:
        return 'Enter password to check strength';
    }
  }

  String _getHackTimeText(String password) {
    if (password.isEmpty) return '';

    int poolSize = 0;
    if (RegExp(r'[a-z]').hasMatch(password)) poolSize += 26;
    if (RegExp(r'[A-Z]').hasMatch(password)) poolSize += 26;
    if (RegExp(r'[0-9]').hasMatch(password)) poolSize += 10;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) poolSize += 32;

    if (poolSize == 0) poolSize = 26;

    const double hashesPerSecond = 10000000000; // 10 billion

    final double combinations = BigInt.from(poolSize)
        .pow(password.length)
        .toDouble();

    final double seconds = combinations / hashesPerSecond;

    if (seconds < 1) return 'It would take a computer under 1 second to hack';
    if (seconds < 60) return 'It would take a computer about ${seconds.round()} seconds to hack';
    if (seconds < 3600) return 'It would take a computer about ${(seconds / 60).round()} minutes to hack';
    if (seconds < 86400) return 'It would take a computer about ${(seconds / 3600).round()} hours to hack';
    if (seconds < 31536000) return 'It would take a computer about ${(seconds / 86400).round()} days to hack';

    final double years = seconds / 31536000;
    if (years < 1000) return 'It would take a computer about ${years.round()} years to hack';
    if (years < 1000000) return 'It would take a computer about ${(years / 1000).toStringAsFixed(1)} thousand years to hack';
    if (years < 1000000000) return 'It would take a computer about ${(years / 1000000).toStringAsFixed(1)} million years to hack';

    return 'It would take a computer billions of years to hack';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Checker'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Enter your password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Password input field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  autofillHints: null,
                  enableIMEPersonalizedLearning: false,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  validator: _passwordValidator,
                  onChanged: (value) {
                    setState(() {
                      _currentPassword = value;
                      if (value.isEmpty) {
                        _currentStrength = null;
                      } else {
                        _currentStrength = checkPasswordStrength(value);
                      }
                    });
                  },
                ),

                const SizedBox(height: 16),

                // 1. Visual Colored Strength Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: _getStrengthColor(colorScheme),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 2. Matching Strength Status Text
                Text(
                  _getStrengthText(),
                  style: TextStyle(
                    color: _getStrengthColor(colorScheme),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // 3. Dynamic Hack Time Text (Bright white text for dark mode visibility)
                Text(
                  _getHackTimeText(_currentPassword),
                  style: TextStyle(
                    fontSize: 15,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                // Submission/Action button
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Check Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}