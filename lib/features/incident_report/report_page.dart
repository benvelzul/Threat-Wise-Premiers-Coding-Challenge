import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ReportPage extends StatefulWidget {
  static const routeName = '/incident-report';

  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _additionalController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _additionalController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Report submitted'),
          content: const Text(
            'Your report has been submitted successfully.\n\n'
            'This is a demo and does not actually send an alert or report.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _sendSOS() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send SOS?'),
        content: const Text(
          'Are you sure you want to send an SOS request?\n\n'
          'This is a demo and does not actually contact emergency services or send an alert.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog<void>(
                context: this.context,
                builder: (context) => AlertDialog(
                  title: const Text('SOS request sent'),
                  content: const Text(
                    'This is a demo. No actual alert or emergency request was sent.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primaryContainer,
        elevation: 0,
        title: const Text('Report an Incident'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildInstructionsCard(context),
            const SizedBox(height: 20),
            _buildExamplesCard(context),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: 'What happened?',
                    hintText:
                        'e.g. Someone walked into my office and took my badge',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please describe what happened.';
                      }
                      return null;
                    },
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _locationController,
                    label: 'Where did it happen?',
                    hintText: 'e.g. North wing lobby or online workspace',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please provide a location.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _contactController,
                    label: 'Your name / contact',
                    hintText: 'e.g. Alex Martinez, x2123',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please add contact details.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Details',
                    hintText:
                        'Tell us everything you remember about the incident',
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please provide more details.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _additionalController,
                    label: 'Anything else to note?',
                    hintText: 'e.g. suspicious email, badge number, witnesses',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            minimumSize: const Size.fromHeight(50),
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          icon: const Icon(Icons.send),
                          label: const Text('Submit report'),
                          onPressed: _submitReport,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.secondary,
                            minimumSize: const Size.fromHeight(50),
                            foregroundColor: colorScheme.onSecondary,
                          ),
                          icon: const Icon(Icons.local_police),
                          label: const Text('Send SOS'),
                          onPressed: _sendSOS,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard(BuildContext context) {
    return Card(
      color:
          Theme.of(context).extension<AppColors>()?.cardBackground ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report your incident',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please describe the incident from your perspective. Include what happened, where it happened, and who was involved.',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesCard(BuildContext context) {
    return Card(
      color:
          Theme.of(context).extension<AppColors>()?.cardBackground ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Examples to help you write your report',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleRow(
              '• I noticed an unknown person tailgating into the building after hours.',
            ),
            const SizedBox(height: 10),
            _buildExampleRow(
              '• My badge was declined at the secure door and then used by someone else.',
            ),
            const SizedBox(height: 10),
            _buildExampleRow(
              '• I received a suspicious email asking for login details and clicked a link.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.55),
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor:
            Theme.of(context).extension<AppColors>()?.cardBackground ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
