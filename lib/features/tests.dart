import 'dart:math'; // 1. Added import for Random()
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

  // 2. Helper method to pick a random value from any Enum list
  T _getRandomEnum<T>(List<T> values) {
    final random = Random();
    return values[random.nextInt(values.length)];
  }

  // 3. Helper method to build a completely random scenario
  EmailScenario _makeRandomScenario() {
    final randomCategory = _getRandomEnum(ScenarioCategory.values);
    final randomDifficulty = _getRandomEnum(Difficulty.values);
    final randomThreatType = _getRandomEnum(ThreatType.values);

    return generateScenario(
      difficulty: randomDifficulty,
      category: randomCategory,
      // Pass threatType if phishing, or null if legitimate
      threatType: randomCategory == ScenarioCategory.phishing ? randomThreatType : null,
    );
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