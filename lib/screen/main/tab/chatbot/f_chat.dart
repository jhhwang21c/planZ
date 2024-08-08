import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';
import 'package:planZ/screen/main/tab/chatbot/chatgpt_service.dart';

class ChatMessage {
  String text;
  bool isUser;
  DateTime timestamp;

  ChatMessage({
    required this.text,
    this.isUser = true,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatbotFragment extends StatefulWidget {
  const ChatbotFragment({super.key});

  @override
  State<ChatbotFragment> createState() => _ChatbotFragmentState();
}

class _ChatbotFragmentState extends State<ChatbotFragment> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _sendMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    _getResponse(message);
  }

  Future<void> _getResponse(String message) async {
    try {
      List<Map<String, String>> history = _messages
          .map((msg) => {
        "role": msg.isUser ? "user" : "assistant",
        "content": msg.text,
      })
          .toList();
      final response = await _apiService.sendMessageGPT(history, message: message);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: "Error: Unable to get response", isUser: false));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!message.isUser)
                        Padding(
                          padding: const EdgeInsets.only(right: 1.0, top: 5),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/image/circleLogo.png'),
                            radius: 20.0,
                          ),
                        ),
                      Expanded(
                        child: BubbleNormal(
                          text: message.text,
                          isSender: message.isUser,
                          tail: false,
                          color: message.isUser
                              ? context.appColors.logoPale.withOpacity(0.7)
                              : context.appColors.baseGrayPale,
                          textStyle: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50.0, // Adjust the height as needed
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "What do you want to know?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: context.appColors.baseGray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: context.appColors.mainGray,
                    ),
                  ),
                  prefixIcon: Icon(Icons.mic),
                  suffixIcon: _isLoading
                      ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(
                      color: context.appColors.selected,
                      strokeWidth: 2,
                    ),
                  )
                      : IconButton(
                    icon: Icon(
                      Icons.arrow_circle_up,
                      color: context.appColors.selected,
                      size: 35,
                    ),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _sendMessage(_controller.text);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}