import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/theme.dart';

class ChatbotPage extends StatefulWidget {
  static const routeName = '/chatbot';

  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Hi there! I am your security assistant. Ask me anything about cyber safety.',
      isUser: false,
    ),
  ];

  GenerativeModel? _model;
  ChatSession? _chatSession;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initGemini();
  }

  void _initGemini() {
    // Retrieves key passed via --dart-define=GEMINI_API_KEY="YOUR_KEY"
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');

    if (apiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-3.5-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(
          'You are ThreatWise AI, an expert cybersecurity assistant for a cyber safety app. '
          'Keep responses concise, clear, and focused on security tips, threat prevention, and safe habits.',
        ),
      );
      _chatSession = _model!.startChat();
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    _controller.clear();
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    // Handle missing API key case
    if (_chatSession == null) {
      setState(() {
        _messages.add(const _ChatMessage(
          text: 'Error: API key is missing. Please run the app using:\n'
                'flutter run --dart-define=GEMINI_API_KEY=""',
          isUser: false,
        ));
        _isLoading = false;
      });
      return;
    }

    try {
      // 2. Send message to Gemini API
      final response = await _chatSession!.sendMessage(Content.text(text));
      final responseText = response.text ?? 'I could not process that request.';

      // 3. Display Gemini's response
      setState(() {
        _messages.add(_ChatMessage(text: responseText, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(
          text: 'Error connecting to Gemini: $e',
          isUser: false,
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    final cardColor = appColors?.cardBackground ?? colorScheme.surfaceContainerHighest;
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: colorScheme.surface,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading bubble when waiting for Gemini
                    if (index == _messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(color: colorScheme.secondary),
                        ),
                      );
                    }

                    final message = _messages[index];
                    return Align(
                      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: message.isUser ? colorScheme.secondary : cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                              bottomRight: Radius.circular(message.isUser ? 4 : 18),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.isUser ? colorScheme.onSecondary : colorScheme.onSurface,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.55)),
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: colorScheme.onPrimary,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send),
                      color: colorScheme.onPrimary,
                      onPressed: _sendMessage,
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
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}