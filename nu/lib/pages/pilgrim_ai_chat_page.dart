import 'package:flutter/material.dart';
import '../services/ai_chat_service.dart';
import '../session/user_session.dart';

class PilgrimAIChatPage extends StatefulWidget {
  static const String routeName = '/pilgrim-ai-chat';

  const PilgrimAIChatPage({super.key});

  @override
  State<PilgrimAIChatPage> createState() => _PilgrimAIChatPageState();
}

class _PilgrimAIChatPageState extends State<PilgrimAIChatPage> {
  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color softMint = Color(0xFFEAF4F2);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiChatService _aiChatService = AiChatService();

  bool _isLoading = false;

  final List<String> _quickQuestions = [
    "What meals match my health profile?",
    "Suggest a low-sugar meal.",
    "What is today’s meal schedule?",
    "Show me high-protein options.",
  ];

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          "Assalamu Alaikum 👋 I’m your AI assistant. I can help you choose meals, explain nutrition, and suggest options based on your health profile.",
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? quickMessage]) async {
    final text = (quickMessage ?? _messageController.text).trim();

    if (text.isEmpty || _isLoading) return;

    final pilgrimID = UserSession.userId;

    if (pilgrimID == null || pilgrimID.isEmpty) {
      setState(() {
        _messages.add(
          _ChatMessage(
            text: "User session not found. Please login again.",
            isUser: false,
          ),
        );
      });
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final reply = await _aiChatService.sendMessage(
        message: text,
        pilgrimID: pilgrimID,
      );

      if (!mounted) return;

      setState(() {
        _messages.add(_ChatMessage(text: reply, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          _ChatMessage(
            text: "Sorry, something went wrong. Please try again.",
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        surfaceTintColor: Colors.white,
        titleSpacing: 8,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
        ),
        title: const Text(
          "AI Assistant",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              children: [
                _buildQuickQuestions(),
                const SizedBox(height: 14),
                ..._messages.map((message) => _ChatBubble(message: message)),
                if (_isLoading) const _TypingBubble(),
              ],
            ),
          ),
          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Questions",
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickQuestions
              .map(
                (question) => InkWell(
                  onTap: _isLoading ? null : () => _sendMessage(question),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          color: Colors.black.withOpacity(0.03),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt_rounded,
                          size: 16,
                          color: primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          question,
                          style: const TextStyle(
                            fontSize: 11.8,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black.withOpacity(0.05)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFA),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 4,
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: _isLoading ? "Please wait..." : "Ask something...",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.40),
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: _isLoading ? null : () => _sendMessage(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isLoading
                        ? [
                            Colors.grey.shade500,
                            Colors.grey.shade600,
                            Colors.grey.shade700,
                          ]
                        : const [primaryDark, primary, primaryMid],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF0D4C4A);
    const Color softMint = Color(0xFFEAF4F2);

    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Text("Typing..."),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({required this.text, required this.isUser});
}