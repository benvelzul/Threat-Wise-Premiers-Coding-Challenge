import 'package:flutter/material.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully.')),
      );
    }
  }

  void _sendSOS() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SOS request sent. Help is on the way.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A0CA3),
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
                    hintText: 'e.g. Someone walked into my office and took my badge',
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
                    hintText: 'Tell us everything you remember about the incident',
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
                            backgroundColor: const Color(0xFF3A0CA3),
                            minimumSize: const Size.fromHeight(50),
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
                            backgroundColor: const Color.fromARGB(255, 105, 0, 0),
                            minimumSize: const Size.fromHeight(50),
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
      color: const Color(0xFF141B2D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report your incident',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please describe the incident from your perspective. Include what happened, where it happened, and who was involved.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesCard(BuildContext context) {
    return Card(
      color: const Color(0xFF141B2D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Examples to help you write your report',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleRow('• I noticed an unknown person tailgating into the building after hours.'),
            const SizedBox(height: 10),
            _buildExampleRow('• My badge was declined at the secure door and then used by someone else.'),
            const SizedBox(height: 10),
            _buildExampleRow('• I received a suspicious email asking for login details and clicked a link.'),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, size: 18, color: Colors.greenAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey, height: 1.4),
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF141B2D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
