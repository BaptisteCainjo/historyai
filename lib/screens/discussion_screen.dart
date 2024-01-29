import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:historyai/utils/constants.dart';
import 'package:historyai/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConversationPage extends StatefulWidget {
  final Map<String, dynamic> character;

  ConversationPage(this.character);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  // TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];
  TextEditingController _controller = TextEditingController();
  List<String> chatHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildNavigationDiscussion(),
          _buildInformations(),
          _buildDiscussion(),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildNavigationDiscussion() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          GestureDetector(
            onTap: () async {
              showCharacterDialog(context, widget.character);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.character['image']),
            ),
          ),
          SizedBox(width: 16),
          Text(
            widget.character['name'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInformations() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Vous entrez en discussion avec ${widget.character['name']}.",
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Text(
              "Cette conversation est générée par une intelligence artificielle, elle n'est pas réelle et des erreurs peuvent être présentes. Pour toute question ou soucis, veuillez contacter contact.baptistecainjo.fr.",
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussion() {
    List<String> combinedMessages = [];

    for (int i = 0; i < _messages.length + chatHistory.length; i++) {
      if (i < _messages.length) {
        combinedMessages.add(_messages[i]);
      }
      if (i < chatHistory.length) {
        combinedMessages.add(chatHistory[i]);
      }
    }

    return Expanded(
      child: ListView.builder(
        itemCount: combinedMessages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment:
                  index % 2 == 0 ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: index % 2 == 0
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: index % 2 == 0
                        ? NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                        : NetworkImage(widget.character['image']),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: index % 2 == 0
                              ? [Color(0xFF405de6), Color(0xFF5851db)]
                              : [Color(0xFF9E9E9E), Color(0xFF9E9E9E)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      combinedMessages[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: iconSend,
            onPressed: () {
              sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);
      });
      _controller.clear();
      _sendRequest(message);
    }
  }

  Future<void> _sendRequest(String message) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${dotenv.env['OPENAI_API_KEY']}",
      },
      body: jsonEncode({
        'messages': [
          {'role': 'system', 'content': 'Traduis moi ça en anglais'},
          {'role': 'user', 'content': '$message'}
        ],
        'model': 'gpt-3.5-turbo',
        'max_tokens': 20,
      }),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    final String chatGPTextGenerate = data['choices'][0]['message']['content'];

    setState(() {
      chatHistory.add(chatGPTextGenerate);
    });
  }
}
