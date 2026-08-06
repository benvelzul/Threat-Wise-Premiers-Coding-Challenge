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
  // Start with a initial random scenario
  late EmailScenario currentScenario;

  @override
  void initState() {
    super.initState();
    final currentScenario = generateScenario(
      difficulty: Difficulty.hard,
      category: ScenarioCategory.phishing,
      threatType: ThreatType.credentialHarvesting,
    );
  }

  void _remakeScenario() {
    setState(() {
      // Generate a Hard Credential Harvesting Phishing Email
      final currentScenario = generateScenario(
        difficulty: Difficulty.hard,
        category: ScenarioCategory.phishing,
        threatType: ThreatType.credentialHarvesting,
      );

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
          // 🔄 Re-make / Refresh Button in App Bar
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
                  color: currentScenario.isThreat ? const Color.fromARGB(255, 0, 0, 0) : Colors.black12,
                  border: Border.all(
                    color: currentScenario.isThreat ? Colors.red : Colors.green,
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
                        color: currentScenario.isThreat ? Colors.red[900] : Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('From: ${currentScenario.emailData.senderName} <${currentScenario.emailData.senderEmail}>'),
                    Text('Subject: ${currentScenario.emailData.subject}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Generated Email Text
              const Text('Email Content:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const Divider(),
              Text(
                currentScenario.emailData.body,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),

              // Large Re-make Button on Page
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
