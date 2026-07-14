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

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Show a success notification rather than popping the page.
      // This prevents browser password managers from trying to "save" the test input.
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

  Color _getStrengthColor() {
    switch (_currentStrength) {
      case StrengthChecker.weak:
        return Colors.red;
      case StrengthChecker.medium:
        return Colors.orange;
      case StrengthChecker.strong:
        return Colors.green;
      case null:
        return Colors.grey.shade300;
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

  @override
  Widget build(BuildContext context) {
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
                  
                  // Blocks auto-save password popups on Chrome, iOS, and Android
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
                          color: _getStrengthColor(),
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
                    color: _getStrengthColor(),
                    fontWeight: FontWeight.bold,
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