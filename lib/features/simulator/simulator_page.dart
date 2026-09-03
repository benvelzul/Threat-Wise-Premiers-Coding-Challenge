import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/email_scenario.dart';
import '../../data/mock_scenarios.dart';
import '../../models/enums.dart';
import '../../core/xp_system/xp_manager.dart';
import 'grading_engine.dart';
import '../widgets/cinematic_band_anim.dart';

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
  int? _xpReward;
  bool _xpCollected = false;
  int _correctStreak = 0;
  Timer? _emailTimer;
  int _elapsedSeconds = 0;

  final Set<ThreatType> _selectedThreatTypes = <ThreatType>{};
  final Set<Indicator> _selectedIndicators = <Indicator>{};
  int _transitionGeneration = 0;

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
    } else if (points <= 40) {
      xp += 15;
    } else if (points <= 60) {
      xp += 30;
    } else if (points <= 80) {
      xp += 45;
    } else {
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

  void _resetQuiz() async {
    _emailTimer?.cancel();
    _transitionCompleter?.complete();
    _transitionCompleter = null;
    _transitionOverlay?.remove();
    _transitionOverlay = null;
    final transitionGeneration = ++_transitionGeneration;
    setState(() {
      currentScenario = _makeRandomScenario();
      _elapsedSeconds = 0;
      _userAnswered = false;
      _showAnswer = false;
      _userAnswer = null;
      _xpReward = null;
      _xpCollected = false;
      _selectedThreatTypes.clear();
      _selectedIndicators.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_runSceneTransition(transitionGeneration));
      }
    });
  }

  void _submitAnswer({
    required bool isThreat,
    required List<ThreatType> selectedThreatTypes,
    required List<Indicator> selectedIndicators,
  }) async {
    _emailTimer?.cancel();
    bool actualIsPhishing = currentScenario.isThreat;
    Difficulty scenarioDifficulty = currentScenario.difficulty;
    final List<ThreatType> actualThreatTypes =
        currentScenario.threatType == null
        ? <ThreatType>[]
        : <ThreatType>[currentScenario.threatType!];

    final (score, percentage, message) = gradeAnswer(
      phishing: isThreat,
      phishingAns: actualIsPhishing,
      difficulty: scenarioDifficulty,
      threatTypes: selectedThreatTypes,
      threatTypesAns: actualThreatTypes,
      indicators: selectedIndicators,
      indicatorsAns: currentScenario.indicators,
      timeTaken: _elapsedSeconds,
    );
    final answerWasSuccessful = percentage > 70;
    setState(() {
      _userAnswer = isThreat;
      _feedbackMsg = message;
      _xpReward = _xpConversion(score, scenarioDifficulty);
      _xpCollected = false;
      _correctStreak = answerWasSuccessful ? _correctStreak + 1 : 0;
      _userAnswered = true;
      _showAnswer = true;
    });
  }

  Future<void> _collectXp() async {
    final xpReward = _xpReward;
    if (xpReward == null || _xpCollected) return;

    await XpManager.instance.addXp(xpReward);
    if (!mounted) return;
    setState(() {
      _xpCollected = true;
    });
  }

  OverlayEntry? _transitionOverlay;
  Completer<void>? _transitionCompleter;

  Future<void> _runSceneTransition(int generation) async {
    for (int i = 3; i >= 1; i--) {
      if (!mounted || generation != _transitionGeneration) return;
      await _triggerSceneTransition('$i', 950);
    }
    if (!mounted || generation != _transitionGeneration) return;
    await _triggerSceneTransition('Start', 2000);
    if (!mounted || generation != _transitionGeneration) return;
    _emailTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSeconds++);
    });
  }

  Future<void> _triggerSceneTransition(String message, int duration) {
    final completer = Completer<void>();
    _transitionCompleter = completer;

    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => AngledBandTransition(
        message: message,
        onComplete: () {
          if (identical(_transitionOverlay, overlayEntry)) {
            _transitionOverlay?.remove();
            _transitionOverlay = null;
            _transitionCompleter = null;
          }
          if (!completer.isCompleted) completer.complete();
        },
        duration: duration,
      ),
    );
    _transitionOverlay = overlayEntry;

    Overlay.of(context).insert(_transitionOverlay!);
    return completer.future;
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
    _collectXp();
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

  String _formatElapsedTime() {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _emailTimer?.cancel();
    _transitionCompleter?.complete();
    _transitionOverlay?.remove();
    _transitionOverlay = null;
    super.dispose();
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, size: 20),
              const SizedBox(width: 4),
              Text(_formatElapsedTime()),
              const SizedBox(width: 8),
            ],
          ),
          IconButton(onPressed: _resetQuiz, icon: const Icon(Icons.refresh)),
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
        Container(
          width: 1,
          color: colorScheme.onSurface.withValues(alpha: 0.12),
        ),
        Expanded(flex: 4, child: _buildAnswerPanel()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(child: _buildEmailPanel()),
        Container(
          height: 1,
          color: colorScheme.onSurface.withValues(alpha: 0.12),
        ),
        _buildAnswerPanel(),
      ],
    );
  }

  Widget _buildEmailPanel() {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final cardColor =
        appColors?.cardBackground ?? colorScheme.surfaceContainerHighest;

    final senderName = currentScenario.emailData.senderName;
    final senderEmail = currentScenario.emailData.senderEmail;
    final initial = senderName.isNotEmpty ? senderName[0].toUpperCase() : '?';

    return Container(
      color: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.12),
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Email Subject (Header)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  currentScenario.emailData.subject.isEmpty
                      ? '(No Subject)'
                      : currentScenario.emailData.subject,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),
              ),

              // 2. Sender / Recipient Metadata Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Sender Avatar / Monogram
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        initial,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Sender Name & Address
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  senderName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '<$senderEmail>',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'to me',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Icon (e.g. Reply or Star)
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      onPressed: () {},
                      tooltip: 'More options',
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),

              // 3. Email Body Text
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SelectableText(
                  currentScenario.emailData.body.trim().isEmpty
                      ? 'This email has no body content.'
                      : currentScenario.emailData.body,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: colorScheme.onSurface.withValues(alpha: 0.87),
                  ),
                ),
              ),
            ],
          ),
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
            if (_userAnswered) ...[
              _buildXpRewardPanel(xpAmount: _xpReward ?? 0),
              const SizedBox(height: 24),
            ],
            if (!_userAnswered) ...[
              Text(
                'Is this email legitimate or phishing?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Analyse the email carefully before answering.',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 8),
            ],

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
                    onPressed: _userAnswer != null ? null : _beginThreatAnswer,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
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
                  onPressed:
                      _selectedIndicators.isEmpty ||
                          _selectedThreatTypes.isEmpty
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
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
                    color: currentScenario.isThreat
                        ? colorScheme.error
                        : colorScheme.primary,
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
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: colorScheme.onSurface,
                      ),
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
                  border: Border.all(
                    color: colorScheme.secondary.withValues(alpha: 0.4),
                  ),
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

  Widget _buildXpRewardPanel({required int xpAmount}) {
    final appColors = Theme.of(context).extension<AppColors>();
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = appColors?.xpText ?? colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Reward unlocked',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.auto_awesome, color: accentColor, size: 48),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRewardStat(
                  icon: Icons.bolt,
                  label: 'XP',
                  value: '+$xpAmount',
                  color: accentColor,
                ),
              ),
              Expanded(
                child: _buildRewardStat(
                  icon: Icons.timer_outlined,
                  label: 'Time',
                  value: _formatElapsedTime(),
                  color: colorScheme.secondary,
                ),
              ),
              Expanded(
                child: _buildRewardStat(
                  icon: Icons.local_fire_department_outlined,
                  label: 'Streak',
                  value: '$_correctStreak',
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.65),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
