import 'package:flutter/material.dart';
import '../../models/email_scenario.dart';
import '../../data/mock_scenarios.dart';
import '../../models/enums.dart';

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});
  static const String routeName = '/simulator';

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  late EmailScenario currentScenario;
  bool _showAnswer = false;
  bool _userAnswered = false;
  bool? _userAnswer; // true = threat, false = not threat

  // Generate a completely random scenario
  EmailScenario _makeRandomScenario() {
    return generateScenario();
  }

  @override
  void initState() {
    super.initState();
    currentScenario = _makeRandomScenario();
  }

  void _remakeScenario() {
    setState(() {
      currentScenario = _makeRandomScenario();
      _showAnswer = false;
      _userAnswered = false;
      _userAnswer = null;
    });
  }

  void _submitAnswer(bool isThreat) {
    setState(() {
      _userAnswer = isThreat;
      _userAnswered = true;
      _showAnswer = true;
    });
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = _userAnswered && _userAnswer == currentScenario.isThreat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Threat Quiz'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Generate New Email',
            onPressed: _remakeScenario,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use side-by-side layout on wide screens, stacked on narrow
          if (constraints.maxWidth > 800) {
            return _buildQuizLayout(constraints);
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildQuizLayout(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left side - Email content (60% width)
        Expanded(
          flex: 6,
          child: _buildEmailPanel(),
        ),
        // Divider
        Container(
          width: 1,
          color: Colors.grey[300],
        ),
        // Right side - Answer bar (40% width)
        Expanded(
          flex: 4,
          child: _buildAnswerPanel(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: _buildEmailPanel(),
        ),
        Container(
          height: 1,
          color: Colors.grey[300],
        ),
        _buildAnswerPanel(),
      ],
    );
  }

  Widget _buildEmailPanel() {
    return Container(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email header metadata
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'From: ${currentScenario.emailData.senderName}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      currentScenario.emailData.senderEmail,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.subject, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Subject: ${currentScenario.emailData.subject}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Email body
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email Content:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentScenario.emailData.body,
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerPanel() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz question
            const Text(
              'Is this email a threat?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Analyze the email carefully before answering.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // The answer button is supposed to be here
      
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Show/Hide explanation toggle
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _userAnswered ? _toggleAnswer : null,
                icon: Icon(_showAnswer ? Icons.visibility_off : Icons.visibility),
                label: Text(_showAnswer ? 'Hide Explanation' : 'Show Explanation'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Explanation section
            if (_showAnswer && _userAnswered) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: currentScenario.isThreat 
                    ? Colors.red.withOpacity(0.05)
                    : Colors.green.withOpacity(0.05),
                  border: Border.all(
                    color: currentScenario.isThreat ? Colors.red : Colors.green,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explanation:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: currentScenario.isThreat ? Colors.red[700] : Colors.green[700],
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentScenario.explanation,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Indicators section
            if (_showAnswer && _userAnswered) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Red Flags (${currentScenario.indicators.length}):',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (currentScenario.indicators.isEmpty)
                      const Text(
                        'No suspicious indicators detected.',
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: currentScenario.indicators.map((indicator) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              indicator.name
                                  .replaceAllMapped(
                                    RegExp(r'_'),
                                    (match) => ' ',
                                  )
                                  .replaceAllMapped(
                                    RegExp(r'\b(\w)'),
                                    (match) => match.group(1)!.toUpperCase(),
                                  ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Next question button
            if (_userAnswered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _remakeScenario,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next Email'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}