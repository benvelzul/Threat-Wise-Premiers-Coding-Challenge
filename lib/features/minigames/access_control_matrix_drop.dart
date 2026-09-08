import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/xp_system/xp_manager.dart';

enum AccessRole { intern, hrManager, sysAdmin }

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

class AccessItem {
  final String id;
  final String name;
  final String description;

  final AccessRole minRole;

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
    explanation:
        'Public content is low-risk — an Intern can safely handle this.',
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
    explanation:
        'Basic org info — commonly available to all staff, including interns.',
  ),
  AccessItem(
    id: 'payroll_data',
    name: 'Payroll Data',
    description: 'Salary and bank details for all employees.',
    minRole: AccessRole.hrManager,
    explanation:
        'Payroll is sensitive personal/financial data — only HR needs it, not Interns or SysAdmins.',
  ),
  AccessItem(
    id: 'performance_reviews',
    name: 'Performance Reviews',
    description: 'Confidential manager notes on employee performance.',
    minRole: AccessRole.hrManager,
    explanation:
        'Personnel records should stay with HR — unrelated to system administration.',
  ),
  AccessItem(
    id: 'medical_leave_forms',
    name: 'Medical Leave Forms',
    description: 'Employee-submitted sick leave documentation.',
    minRole: AccessRole.hrManager,
    explanation:
        'Health-adjacent personal data — HR-only, regardless of technical seniority.',
  ),
  AccessItem(
    id: 'database_root_keys',
    name: 'Database Root Keys',
    description: 'Full read/write credentials for the production database.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Root access can compromise everything — only SysAdmins should hold this.',
  ),
  AccessItem(
    id: 'server_ssh_keys',
    name: 'Server SSH Keys',
    description: 'Private keys granting shell access to production servers.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Infrastructure access is a SysAdmin responsibility — never HR or Intern-level.',
  ),
  AccessItem(
    id: 'firewall_config',
    name: 'Firewall Configuration',
    description: 'Rules controlling network traffic in/out of the company.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Misconfiguring this can expose the whole network — SysAdmin-only.',
  ),
  AccessItem(
    id: 'company_newsletter',
    name: 'Company Newsletter',
    description: 'Monthly internal update on team events and announcements.',
    minRole: AccessRole.intern,
    explanation:
        'General company updates — intended for broad distribution across all roles.',
  ),
  AccessItem(
    id: 'kitchen_snack_list',
    name: 'Kitchen Snack Requests',
    description: 'Shared spreadsheet to request office snacks and drinks.',
    minRole: AccessRole.intern,
    explanation:
        'Non-sensitive social utility — available to everyone in the office.',
  ),
  AccessItem(
    id: 'design_brand_assets',
    name: 'Brand Guidelines & Logos',
    description: 'Vector logos, color palettes, and public slide templates.',
    minRole: AccessRole.intern,
    explanation:
        'Marketing assets meant to be used broadly across external communications.',
  ),
  AccessItem(
    id: 'training_videos',
    name: 'Onboarding Video Library',
    description: 'Recorded tutorials covering common workflow tools.',
    minRole: AccessRole.intern,
    explanation:
        'Standard educational materials — crucial for new hires and interns.',
  ),
  AccessItem(
    id: 'kb_articles',
    name: 'Internal Knowledge Base',
    description: 'How-to guides for printer setup and booking meeting rooms.',
    minRole: AccessRole.intern,
    explanation:
        'Routine operational documentation designed for general staff self-service.',
  ),
  AccessItem(
    id: 'customer_support_faqs',
    name: 'Customer Support Documentation',
    description: 'Standard responses for common customer inquiries.',
    minRole: AccessRole.intern,
    explanation:
        'Public-facing support knowledge — safe for entry-level team members.',
  ),
  AccessItem(
    id: 'hardware_inventory',
    name: 'IT Hardware Asset List',
    description: 'List of monitor and laptop serial numbers assigned to desks.',
    minRole: AccessRole.intern,
    explanation:
        'Basic physical inventory tracking without sensitive operational access.',
  ),
  AccessItem(
    id: 'termination_notices',
    name: 'Termination Notices',
    description: 'Offboarding timelines and exit interview documentation.',
    minRole: AccessRole.hrManager,
    explanation:
        'Extremely sensitive HR proceedings — restricted strictly to personnel management.',
  ),
  AccessItem(
    id: 'background_checks',
    name: 'Background Check Reports',
    description: 'Third-party criminal and credit checks for incoming staff.',
    minRole: AccessRole.hrManager,
    explanation:
        'Contains highly confidential personal identifying information for HR eyes only.',
  ),
  AccessItem(
    id: 'benefits_enrollment',
    name: 'Health Insurance Records',
    description: 'Employee coverage selections and dependent details.',
    minRole: AccessRole.hrManager,
    explanation:
        'Private healthcare and dependent data managed exclusively by HR.',
  ),
  AccessItem(
    id: 'salary_benchmarks',
    name: 'Compensation Strategy Data',
    description: 'Market rate models and planned salary band updates.',
    minRole: AccessRole.hrManager,
    explanation:
        'Strategic financial planning for personnel — restricted to HR leadership.',
  ),
  AccessItem(
    id: 'incident_reports_hr',
    name: 'Workplace Grievance Logs',
    description: 'Formal complaints filed with human resources.',
    minRole: AccessRole.hrManager,
    explanation:
        'Legal and personal sensitivity requires high confidentiality within HR.',
  ),
  AccessItem(
    id: 'direct_deposit_forms',
    name: 'Employee Direct Deposit Info',
    description: 'Routing numbers and banking details for payroll runs.',
    minRole: AccessRole.hrManager,
    explanation:
        'Financial PII requires strict compliance and HR-only administrative access.',
  ),
  AccessItem(
    id: 'dns_records',
    name: 'DNS Zone Manager',
    description: 'Domain name routing for production and staging environments.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Incorrect DNS changes cause site-wide outages — requires administrator privileges.',
  ),
  AccessItem(
    id: 'tls_certificates',
    name: 'SSL/TLS Private Keys',
    description: 'Cryptographic keys securing web traffic and endpoints.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Key compromise risks man-in-the-middle attacks — strictly infrastructure level.',
  ),
  AccessItem(
    id: 'vpn_concentrator_config',
    name: 'Corporate VPN Gateway Config',
    description: 'Authentication rules and subnet routes for remote access.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Governs external entry into the private network — managed by network admins.',
  ),
  AccessItem(
    id: 'backup_encryption_keys',
    name: 'Disaster Recovery Vault Keys',
    description: 'Primary keys needed to decrypt production database backups.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Critical for business continuity — strictly restricted to system infrastructure leads.',
  ),
  AccessItem(
    id: 'cloud_iam_policies',
    name: 'AWS/GCP Master IAM Roles',
    description:
        'Root permissions policies governing cloud infrastructure access.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Controls identity and access across all cloud systems — highest technical priority.',
  ),
  AccessItem(
    id: 'load_balancer_rules',
    name: 'Load Balancer Control Panel',
    description: 'Traffic distribution and rate-limiting configurations.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Operational setting directly impacting system uptime and DDoS mitigation.',
  ),
  AccessItem(
    id: 'siem_audit_logs',
    name: 'Security Incident & Event Logs',
    description: 'Centralized system and access security logs.',
    minRole: AccessRole.sysAdmin,
    explanation:
        'Critical infrastructure security data requiring system admin access to monitor and protect.',
  ),
];

List<AccessItem> buildAccessDeck({int maxQuestions = 9}) {
  final pool = accessItemDeck.length > maxQuestions
      ? accessItemDeck.take(maxQuestions).toList()
      : List<AccessItem>.from(accessItemDeck);

  return List<AccessItem>.from(pool)..shuffle(Random());
}

class AccessControlMatrixDropPage extends StatefulWidget {
  static const routeName = '/access-control';
  const AccessControlMatrixDropPage({super.key});

  @override
  State<AccessControlMatrixDropPage> createState() =>
      _AccessControlMatrixDropPageState();
}

class _AccessControlMatrixDropPageState
    extends State<AccessControlMatrixDropPage>
    with TickerProviderStateMixin {
  static const int _roundXpReward = 25;

  late List<AccessItem> _deck;
  int _currentIndex = 0;
  int _score = 0;
  int _perfectStreak = 0;

  String? _feedbackMessage;
  bool? _wasCorrect;
  bool _showConfetti = false;
  AnimationController? _confettiController;
  late final List<_ConfettiPiece> _confettiPieces;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _confettiPieces = List.generate(28, (index) {
      final random = Random();
      final colors = <Color>[
        const Color(0xFF46C200),
        const Color(0xFF0099FF),
        const Color(0xFF8A2BE2),
        const Color(0xFFFFD166),
        const Color(0xFFFF0055),
      ];

      return _ConfettiPiece(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.4,
        dx: (random.nextDouble() - 0.5) * 2.4,
        dy: 0.5 + random.nextDouble() * 1.0,
        rotation: (random.nextDouble() - 0.5) * 2.5,
        size: 6 + random.nextDouble() * 8,
        color: colors[random.nextInt(colors.length)],
      );
    });
    _deck = buildAccessDeck();
  }

  @override
  void dispose() {
    _confettiController?.dispose();
    super.dispose();
  }

  AccessItem? get _currentItem =>
      _currentIndex < _deck.length ? _deck[_currentIndex] : null;

  void _triggerConfetti() {
    final controller = _confettiController;
    if (!mounted || controller == null) return;

    setState(() => _showConfetti = true);
    controller.stop();
    controller.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      setState(() => _showConfetti = false);
    });
  }

  void _handleDrop(AccessItem item, AccessRole droppedRole) {
    final isExactMatch = droppedRole == item.minRole;
    final isOverPrivileged = droppedRole.index > item.minRole.index;

    setState(() {
      if (isExactMatch) {
        _score += 10;
        _perfectStreak += 1;
        _wasCorrect = true;
        _feedbackMessage = 'Correct — least privilege achieved!';
        XpManager.instance.addXp(_roundXpReward, streak: _perfectStreak);
        _triggerConfetti();
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
      _deck = buildAccessDeck();
      _currentIndex = 0;
      _score = 0;
      _perfectStreak = 0;
      _feedbackMessage = null;
      _wasCorrect = null;
    });
  }

  Color _roleColor(AccessRole role) {
    switch (role) {
      case AccessRole.intern:
        return const Color(0xFF16A34A);
      case AccessRole.hrManager:
        return const Color(0xFFF59E0B);
      case AccessRole.sysAdmin:
        return const Color(0xFF7C3AED);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = _currentItem;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Control Matrix'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.08),
                  colorScheme.surface,
                  colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: item == null
                    ? _buildGameOver()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 12),
                          if (_feedbackMessage != null) _buildFeedbackBanner(),
                          const SizedBox(height: 16),
                          _buildCard(item),
                          const SizedBox(height: 18),
                          _buildBins(),
                        ],
                      ),
              ),
            ),
          ),
          if (_showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation:
                      _confettiController ?? const AlwaysStoppedAnimation(0.0),
                  builder: (context, child) {
                    final controller = _confettiController;
                    return CustomPaint(
                      painter: controller == null
                          ? null
                          : _ConfettiPainter(
                              animation: controller,
                              pieces: _confettiPieces,
                            ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appColors?.cardBackground ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Score: $_score',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentIndex + 1} / ${_deck.length}',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (_perfectStreak >= 3) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '🔥 x$_perfectStreak',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB45309),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeedbackBanner() {
    final color = _wasCorrect == true
        ? const Color(0xFF16A34A)
        : const Color(0xFFF59E0B);
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          _feedbackMessage!,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCard(AccessItem item) {
    final appColors = Theme.of(context).extension<AppColors>();
    final cardColor =
        appColors?.cardBackground ?? Theme.of(context).colorScheme.surface;

    return Draggable<AccessItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 260,
          child: Transform.rotate(
            angle: -0.03,
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _ItemCard(item: item),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: _ItemCard(item: item)),
      child: _ItemCard(item: item),
    );
  }

  Widget _buildBins() {
    return Row(
      children: AccessRole.values.map((role) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DragTarget<AccessItem>(
              onWillAcceptWithDetails: (details) => true,
              onAcceptWithDetails: (details) => _handleDrop(details.data, role),
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                final accent = _roleColor(role);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 120,
                  decoration: BoxDecoration(
                    color: isHovering
                        ? accent.withValues(alpha: 0.12)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isHovering
                          ? accent
                          : Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.32),
                      width: isHovering ? 2 : 1,
                    ),
                    boxShadow: [
                      if (isHovering)
                        BoxShadow(
                          color: accent.withValues(alpha: 0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          color: accent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        role.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: appColors?.cardBackground ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.verified_user,
                size: 42,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Final Score: $_score / $maxScore',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Least privilege means giving access to exactly what\'s needed — nothing more.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _restart,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Play Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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

class _ConfettiPiece {
  final double x;
  final double y;
  final double dx;
  final double dy;
  final double rotation;
  final double size;
  final Color color;

  const _ConfettiPiece({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.rotation,
    required this.size,
    required this.color,
  });
}

class _ConfettiPainter extends CustomPainter {
  final Animation<double> animation;
  final List<_ConfettiPiece> pieces;

  _ConfettiPainter({required this.animation, required this.pieces});

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;

    for (final piece in pieces) {
      final x = size.width * piece.x + piece.dx * progress * size.width * 0.9;
      final y = size.height * piece.y + piece.dy * progress * size.height * 1.2;
      final rotation = piece.rotation + progress * 12;

      final paint = Paint()..color = piece.color;
      final rect = Rect.fromCenter(
        center: Offset(x, y),
        width: piece.size,
        height: piece.size * 1.8,
      );

      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(rotation);
      canvas.translate(-rect.center.dx, -rect.center.dy);
      canvas.drawRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

class _ItemCard extends StatelessWidget {
  final AccessItem item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: appColors?.cardBackground ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              color: colorScheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
