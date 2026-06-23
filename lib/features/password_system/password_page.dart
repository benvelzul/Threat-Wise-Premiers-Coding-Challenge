// Placeholder password page template
// - Replace any `PLACEHOLDER_*` strings with your real values
// - Edit widget structure, labels, validation, and styles as needed
// - This file intentionally contains neutral placeholder text only

import 'package:flutter/material.dart';
class PasswordPage extends StatefulWidget {
  static const routeName = '/password';

  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
	final _formKey = GlobalKey<FormState>();
	final TextEditingController _passwordController = TextEditingController();
	final TextEditingController _confirmController = TextEditingController();

	@override
	void dispose() {
		_passwordController.dispose();
		_confirmController.dispose();
		super.dispose();
	}

	void _onSubmit() {
		if (_formKey.currentState?.validate() ?? false) {
			// Placeholder behavior: close page
			Navigator.of(context).maybePop();
		}
	}

	String? _passwordValidator(String? value) {
		if (value == null || value.isEmpty) return 'Enter password';
		return null;
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

								// Password field
								TextFormField(
									controller: _passwordController,
									obscureText: true,
									decoration: const InputDecoration(
										labelText: 'Password',
										hintText: 'Enter your password',
									),
									validator: _passwordValidator,
								),

								const SizedBox(height: 24),

								// Action buttons
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

