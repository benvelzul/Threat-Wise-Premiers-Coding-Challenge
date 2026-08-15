import 'package:flutter/material.dart';
import '../models/email_scenario.dart';
import '../data/mock_scenarios.dart';
import '../models/enums.dart';

class ScenarioTestScreen extends StatefulWidget {
  const ScenarioTestScreen({super.key});
  static const String routeName = '/tests';

  @override
  State<ScenarioTestScreen> createState() => _ScenarioTestScreenState();
}

class _ScenarioTestScreenState extends State<ScenarioTestScreen> {
  late EmailScenario currentScenario;

  // Generate a completely random scenario
  EmailScenario _makeRandomScenario() {
    return generateScenario();
  }

  @override
  void initState() {
    super.initState();
    // Initialize with a random scenario
    currentScenario = _makeRandomScenario();
  }

  void _remakeScenario() {
    setState(() {
      // Re-assign with a brand new random scenario
      currentScenario = _makeRandomScenario();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scenario Sandbox'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metadata Badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: currentScenario.isThreat 
                      ? const Color.fromARGB(255, 35, 35, 35) 
                      : Colors.grey[200],
                  border: Border.all(
                    color: currentScenario.isThreat ? Colors.red : Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${currentScenario.id} | Threat: ${currentScenario.isThreat ? "YES ⚠️" : "NO ✅"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: currentScenario.isThreat ? Colors.redAccent : Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Category: ${currentScenario.category.name} | Difficulty: ${currentScenario.difficulty.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: currentScenario.isThreat ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    if (currentScenario.threatType != null)
                      Text(
                        'Type: ${currentScenario.threatType!.name}',
                        style: const TextStyle(color: Colors.orangeAccent),
                      ),
                    const Divider(height: 16),
                    Text(
                      'From: ${currentScenario.emailData.senderName} <${currentScenario.emailData.senderEmail}>',
                      style: TextStyle(color: currentScenario.isThreat ? Colors.white : Colors.black),
                    ),
                    Text(
                      'Subject: ${currentScenario.emailData.subject}',
                      style: TextStyle(color: currentScenario.isThreat ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Generated Email Content
              const Text('Email Content:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const Divider(),
              Text(
                currentScenario.emailData.body,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),

              // Explanation Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: currentScenario.isThreat 
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  border: Border.all(
                    color: currentScenario.isThreat ? Colors.red : Colors.green,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explanation:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: currentScenario.isThreat ? Colors.red[700] : Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentScenario.explanation,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Indicators Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Red Flags (${currentScenario.indicators.length} indicator${currentScenario.indicators.length != 1 ? 's' : ''}):',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
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
              const SizedBox(height: 30),

              // Re-make Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _remakeScenario,
                  icon: const Icon(Icons.autorenew),
                  label: const Text('Re-make Random Email'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}