import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/email_scenario.dart';
import '../../data/mock_scenarios.dart';
import '../../models/enums.dart';
import '../../core/xp_system/xp_manager.dart';
import 'grading_engine.dart';

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
  bool? _userAnswer;
  String _feedbackMsg = '';
  
  final Set<ThreatType> _selectedThreatTypes = <ThreatType>{};
  final Set<Indicator> _selectedIndicators = <Indicator>{};

  @override
  void initState() {
    super.initState();
    _resetQuiz();
  }

  int _xpConversion(double points, Difficulty difficulty) {
    int xp = 0;
    if (points <= 0) return 0;

    if (points <= 20) {
      xp += 5;
    }else if (points <= 40) {
      xp += 15;
    }else if (points <= 60){
      xp += 30;
    }else if (points <= 80){
      xp += 45;
    }else {
      xp += 60;
    }
    final difficultyBonus = switch (difficulty) {
      Difficulty.easy => 0,
      Difficulty.medium => 10,
      Difficulty.hard => 20,
      Difficulty.expert => 35,
    };
    
    xp += difficultyBonus;

    return xp; 
  }
  
  void _resetQuiz() {
    setState(() {
      currentScenario = _makeRandomScenario();
      _userAnswered = false;
      _showAnswer = false;
      _userAnswer = null;
      _selectedThreatTypes.clear();
      _selectedIndicators.clear();
    });
  }

  void _submitAnswer( {
    required bool isThreat,
    required List<ThreatType> selectedThreatTypes,
    required List<Indicator> selectedIndicators,
  }) async {
    bool actualIsPhishing = currentScenario.isThreat;
    Difficulty scenarioDifficulty = currentScenario.difficulty;
    final List<ThreatType> actualThreatTypes = currentScenario.threatType == null
      ? <ThreatType>[]
      : <ThreatType>[currentScenario.threatType!];

    final (score, message) = gradeAnswer(
      phishing: isThreat,
      phishingAns: actualIsPhishing,
      difficulty: scenarioDifficulty,
      threatTypes: selectedThreatTypes,
      threatTypesAns: actualThreatTypes,
      indicators: selectedIndicators,
      indicatorsAns: currentScenario.indicators,
    );
    await XpManager.instance.addXp(_xpConversion(score, scenarioDifficulty));

    setState(() {
      _userAnswer = isThreat;
      _feedbackMsg = message;
      _userAnswered = true;
      _showAnswer = true; 
    });
  }

  void _beginThreatAnswer() {
    setState(() {
      _userAnswer = true;
      _userAnswered = false;
      _showAnswer = false;
    });
  }

  void _confirmThreatTypeAndIndicator() {
    _submitAnswer(
      isThreat: true,
      selectedThreatTypes: _selectedThreatTypes.toList(),
      selectedIndicators: _selectedIndicators.toList(),
    );
  }

  void _toggleThreatType(ThreatType threatType) {
    setState(() {
      if (_selectedThreatTypes.contains(threatType)) {
        _selectedThreatTypes.remove(threatType);
      } else {
        _selectedThreatTypes.clear();
        _selectedThreatTypes.add(threatType);
      }
    });
  }

  void _toggleIndicators(Indicator indicator) {
    setState(() {
      if (_selectedIndicators.contains(indicator)) {
        _selectedIndicators.remove(indicator);
      } else {
        _selectedIndicators.add(indicator);
      }
    });
  }
  
  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  EmailScenario _makeRandomScenario() {
    return generateScenario();
  }

  String _formatEnumLabel(String value) {
    return value
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .replaceFirst(value[0], value[0].toUpperCase());
  }

  @override
  Widget build(BuildContext context) {    
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Threat Quiz'),
        backgroundColor: colorScheme.tertiary,
        foregroundColor: colorScheme.onTertiary,
        actions: [
          IconButton(
            onPressed: _resetQuiz,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 6, child: _buildEmailPanel()),
        Container(width: 1, color: colorScheme.onSurface.withValues(alpha: 0.12)),
        Expanded(flex: 4, child: _buildAnswerPanel()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(child: _buildEmailPanel()),
        Container(height: 1, color: colorScheme.onSurface.withValues(alpha: 0.12)),
        _buildAnswerPanel(),
      ],
    );
  }

  Widget _buildEmailPanel() {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final cardColor = appColors?.cardBackground ?? colorScheme.surfaceContainerHighest;
    return Container(
      color: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.12)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.2),
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
                      Icon(Icons.email_outlined, color: colorScheme.onSurface.withValues(alpha: 0.65)),
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
                      style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.65), fontSize: 13),
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Icon(Icons.subject, color: colorScheme.onSurface.withValues(alpha: 0.65), size: 18),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.12)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email Content:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withValues(alpha: 0.65),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    currentScenario.emailData.body.trim().isEmpty
                        ? 'This email has no body content.'
                        : currentScenario.emailData.body,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: colorScheme.onSurface,
                    ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Is this email legitimate or phishing?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Analyse the email carefully before answering.',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.65)),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _userAnswer != null
                        ? null
                        : () => _submitAnswer(
                            isThreat: false,
                            selectedThreatTypes: const <ThreatType>[],
                            selectedIndicators: const <Indicator>[],
                          ),
                    icon: const Icon(Icons.verified_outlined),
                    label: const Text('Legitimate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _userAnswer != null
                        ? null
                      : _beginThreatAnswer,
                    icon: const Icon(Icons.warning_amber_outlined),
                    label: const Text('Phishing'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),

            if (_userAnswer == true && !_userAnswered) ...[
              const SizedBox(height: 24),
              Text(
                'What type of phishing is this?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ThreatType.values.map((threatType) {
                  final isSelected = _selectedThreatTypes.contains(threatType);
                  return FilterChip(
                    selected: isSelected,
                    label: Text(_formatEnumLabel(threatType.name)),
                    selectedColor: colorScheme.error.withValues(alpha: 0.25),
                    checkmarkColor: colorScheme.error,
                    onSelected: (_) => _toggleThreatType(threatType),
                  );
                }).toList(),
              ),
              
              // Indicator selection 
              const SizedBox(height: 24),
              Text(
                'How did you get to this answer?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Indicator.values.map((indicator) {
                  final isSelected = _selectedIndicators.contains(indicator);
                  return FilterChip(
                    selected: isSelected,
                    label: Text(_formatEnumLabel(indicator.name)),
                    selectedColor: colorScheme.error.withValues(alpha: 0.25),
                    checkmarkColor: colorScheme.error,
                    onSelected: (_) => _toggleIndicators(indicator),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedIndicators.isEmpty
                      ? null
                      : _confirmThreatTypeAndIndicator,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.tertiary,
                    foregroundColor: colorScheme.onTertiary,
                  ),
                  child: const Text('Submit Indicator and Threat Type(s)'),
                ),
              ),
            ],

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _userAnswered ? _toggleAnswer : null,
                icon: Icon(
                  _showAnswer ? Icons.visibility_off : Icons.visibility,
                ),
                label: Text(
                  _showAnswer ? 'Hide Explanation' : 'Show Explanation',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_showAnswer && _userAnswered) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withValues(alpha: 0.12),
                  border: Border.all(
                    color: colorScheme.tertiary.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _feedbackMsg,
                      style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: currentScenario.isThreat
                      ? colorScheme.error.withValues(alpha: 0.12)
                      : colorScheme.primary.withValues(alpha: 0.12),
                  border: Border.all(
                    color: currentScenario.isThreat ? colorScheme.error : colorScheme.primary,
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
                        color: colorScheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentScenario.explanation,
                      style: TextStyle(fontSize: 14, height: 1.5, color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.12),
                  border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Red Flags (${currentScenario.indicators.length}):',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (currentScenario.indicators.isEmpty)
                      Text(
                        'No suspicious indicators detected.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurface.withValues(alpha: 0.65),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: currentScenario.indicators.map((indicator) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
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
                              style: TextStyle(
                                color: colorScheme.onSecondary,
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

            if (_userAnswered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _resetQuiz,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next Email'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.tertiary,
                    foregroundColor: colorScheme.onTertiary,
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