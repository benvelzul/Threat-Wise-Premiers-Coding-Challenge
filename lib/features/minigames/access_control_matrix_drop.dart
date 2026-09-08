// lib/features/minigames/access_control_matrix_drop.dart

import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────

/// The three roles, ordered from lowest to highest privilege.
/// Using an enum with index order lets us compare privilege levels
/// with simple `.index` comparisons.
enum AccessRole {
  intern,
  hrManager,
  sysAdmin,
}

extension AccessRoleLabel on AccessRole {
  String get label {
    switch (this) {
      case AccessRole.intern:
        return 'Intern';
      case AccessRole.hrManager:
        return 'HR Manager';
      case AccessRole.sysAdmin:
        return 'SysAdmin';
    }
  }
}

/// A single draggable card representing a sensitive item.
class AccessItem {
  final String id;
  final String name;
  final String description;

  /// The lowest role that should legitimately have access.
  final AccessRole minRole;

  /// One-line explanation shown on wrong drop, teaching *why*.
  final String explanation;

  const AccessItem({
    required this.id,
    required this.name,
    required this.description,
    required this.minRole,
    required this.explanation,
  });
}

const List<AccessItem> accessItemDeck = [
  AccessItem(
    id: 'blog_post',
    name: 'Public Blog Post',
    description: 'Draft of a marketing blog post before publishing.',
    minRole: AccessRole.intern,
    explanation: 'Public content is low-risk — an Intern can safely handle this.',
  ),
  AccessItem(
    id: 'office_wifi',
    name: 'Office WiFi Password',
    description: 'Shared password for the guest office network.',
    minRole: AccessRole.intern,
    explanation: 'Low-sensitivity shared resource — no need to restrict this.',
  ),
  AccessItem(
    id: 'employee_directory',
    name: 'Employee Directory',
    description: 'Names, roles, and desk locations of staff.',
    minRole: AccessRole.intern,
    explanation: 'Basic org info — commonly available to all staff, including interns.',
  ),
  AccessItem(
    id: 'payroll_data',
    name: 'Payroll Data',
    description: 'Salary and bank details for all employees.',
    minRole: AccessRole.hrManager,
    explanation: 'Payroll is sensitive personal/financial data — only HR needs it, not Interns or SysAdmins.',
  ),
  AccessItem(
    id: 'performance_reviews',
    name: 'Performance Reviews',
    description: 'Confidential manager notes on employee performance.',
    minRole: AccessRole.hrManager,
    explanation: 'Personnel records should stay with HR — unrelated to system administration.',
  ),
  AccessItem(
    id: 'medical_leave_forms',
    name: 'Medical Leave Forms',
    description: 'Employee-submitted sick leave documentation.',
    minRole: AccessRole.hrManager,
    explanation: 'Health-adjacent personal data — HR-only, regardless of technical seniority.',
  ),
  AccessItem(
    id: 'database_root_keys',
    name: 'Database Root Keys',
    description: 'Full read/write credentials for the production database.',
    minRole: AccessRole.sysAdmin,
    explanation: 'Root access can compromise everything — only SysAdmins should hold this.',
  ),
  AccessItem(
    id: 'server_ssh_keys',
    name: 'Server SSH Keys',
    description: 'Private keys granting shell access to production servers.',
    minRole: AccessRole.sysAdmin,
    explanation: 'Infrastructure access is a SysAdmin responsibility — never HR or Intern-level.',
  ),
  AccessItem(
    id: 'firewall_config',
    name: 'Firewall Configuration',
    description: 'Rules controlling network traffic in/out of the company.',
    minRole: AccessRole.sysAdmin,
    explanation: 'Misconfiguring this can expose the whole network — SysAdmin-only.',
  ),
];


class AccessControlMatrixDropPage extends StatefulWidget {
  static const routeName = '/access-control';
  const AccessControlMatrixDropPage({super.key});

  @override
  State<AccessControlMatrixDropPage> createState() => _AccessControlMatrixDropPageState();
}

class _AccessControlMatrixDropPageState extends State<AccessControlMatrixDropPage> {
  late List<AccessItem> _deck;
  int _currentIndex = 0;
  int _score = 0;
  int _perfectStreak = 0;

  String? _feedbackMessage;
  bool? _wasCorrect;

  @override
  void initState() {
    super.initState();
    _deck = List<AccessItem>.from(accessItemDeck)..shuffle(Random());
  }

  AccessItem? get _currentItem =>
      _currentIndex < _deck.length ? _deck[_currentIndex] : null;

  /// Scoring: exact-role match = full points, higher-privilege bin = partial
  /// credit (safe but wasteful), lower-privilege bin = 0 (an actual
  /// security violation).
  void _handleDrop(AccessItem item, AccessRole droppedRole) {
    final isExactMatch = droppedRole == item.minRole;
    final isOverPrivileged = droppedRole.index > item.minRole.index;

    setState(() {
      if (isExactMatch) {
        _score += 10;
        _perfectStreak += 1;
        _wasCorrect = true;
        _feedbackMessage = 'Correct — least privilege achieved!';
      } else if (isOverPrivileged) {
        _score += 3;
        _perfectStreak = 0;
        _wasCorrect = false;
        _feedbackMessage =
            'Too broad. ${item.explanation} (Least-privilege answer: ${item.minRole.label})';
      } else {
        _perfectStreak = 0;
        _wasCorrect = false;
        _feedbackMessage = 'Risky! ${item.explanation}';
      }
      _currentIndex += 1;
    });
  }

  void _restart() {
    setState(() {
      _deck = List<AccessItem>.from(accessItemDeck)..shuffle(Random());
      _currentIndex = 0;
      _score = 0;
      _perfectStreak = 0;
      _feedbackMessage = null;
      _wasCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = _currentItem;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Control Matrix Drop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: item == null
            ? _buildGameOver()
            : Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  if (_feedbackMessage != null) _buildFeedbackBanner(),
                  const Spacer(),
                  _buildCard(item),
                  const Spacer(),
                  _buildBins(item),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Score: $_score',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('${_currentIndex + 1} / ${_deck.length}'),
        if (_perfectStreak >= 3)
          Text('🔥 x$_perfectStreak',
              style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFeedbackBanner() {
    final color = _wasCorrect == true ? Colors.green : Colors.orange;
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Text(
          _feedbackMessage!,
          style: TextStyle(color: color.shade900),
        ),
      ),
    );
  }

  /// The draggable sensitive-item card.
  Widget _buildCard(AccessItem item) {
    return Draggable<AccessItem>(
      data: item,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(width: 260, child: _ItemCard(item: item)),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _ItemCard(item: item),
      ),
      child: _ItemCard(item: item),
    );
  }

  /// The three role bins, each a DragTarget.
  Widget _buildBins(AccessItem item) {
    return Row(
      children: AccessRole.values.map((role) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DragTarget<AccessItem>(
              onWillAcceptWithDetails: (details) => true,
              onAcceptWithDetails: (details) =>
                  _handleDrop(details.data, role),
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: isHovering
                        ? Colors.blue.withOpacity(0.15)
                        : Colors.grey.withOpacity(0.08),
                    border: Border.all(
                      color: isHovering ? Colors.blue : Colors.grey,
                      width: isHovering ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    role.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGameOver() {
    final maxScore = _deck.length * 10;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_user, size: 64, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            'Final Score: $_score / $maxScore',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Least privilege means giving access to exactly\nwhat\'s needed — nothing more.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _restart,
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}

/// Visual representation of an AccessItem card, reused for both the
/// static card and the drag feedback overlay.
class _ItemCard extends StatelessWidget {
  final AccessItem item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 28, color: Colors.blueGrey.shade700),
            const SizedBox(height: 8),
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}