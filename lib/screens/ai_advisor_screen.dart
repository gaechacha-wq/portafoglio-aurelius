import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';
import '../services/ai_aurelius_service.dart';

class AiAdvisorScreen extends ConsumerStatefulWidget {
  const AiAdvisorScreen({super.key});

  @override
  ConsumerState<AiAdvisorScreen> createState() => _AiAdvisorScreenState();
}

class _AiAdvisorScreenState extends ConsumerState<AiAdvisorScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoadingGlobalNews = true;

  @override
  void initState() {
    super.initState();
    _fetchGlobalNews();
  }

  Future<void> _fetchGlobalNews() async {
    try {
      final aiService = ref.read(aiAdvisorProvider);
      final globalBriefing = await aiService.fetchGlobalNewsAnalysis();
      
      if (mounted) {
        setState(() {
          _messages.add(Message(text: globalBriefing, isAi: true));
          _messages.add(Message(text: 'Sono Aurelius, il tuo fiduciario AI. Come desideri procedere?', isAi: true));
          _isLoadingGlobalNews = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingGlobalNews = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isAi: false));
      _controller.clear();
      _isLoadingGlobalNews = true; // reusing existing flag for AI typing indicator
    });

    final aiService = ref.read(aiAdvisorProvider);
    final response = await aiService.getAdvice(text, {});

    if (mounted) {
      setState(() {
        _messages.add(Message(text: response, isAi: true));
        _isLoadingGlobalNews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aurelius Intelligence'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _ChatBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isLoadingGlobalNews)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Consultando Global Info...', style: TextStyle(color: AureliusTheme.accentGold, fontStyle: FontStyle.italic)),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                borderRadius: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Chiedi ad Aurelius...',
                          border: InputBorder.none,
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: AureliusTheme.accentGold),
                      onPressed: _sendMessage,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isAi;
  Message({required this.text, required this.isAi});
}

class _ChatBubble extends StatelessWidget {
  final Message message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: message.isAi ? AureliusTheme.cardDark : AureliusTheme.accentGold.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24).copyWith(
            bottomLeft: message.isAi ? const Radius.circular(0) : const Radius.circular(24),
            bottomRight: !message.isAi ? const Radius.circular(0) : const Radius.circular(24),
          ),
          border: Border.all(color: message.isAi ? Colors.white10 : AureliusTheme.accentGold.withOpacity(0.3)),
        ),
        child: Text(
          message.text, 
          style: TextStyle(
            height: 1.5, 
            color: message.isAi ? Colors.white : AureliusTheme.accentGold,
            fontWeight: message.isAi ? FontWeight.normal : FontWeight.w500,
          )
        ),
      ),
    );
  }
}
