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
  ConversationPageState createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {
  bool _isCharacterResponding = false;

  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
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
      padding: normalPadding,
      decoration: BoxDecoration(
        color: colorBlackBlock,
        boxShadow: [
          BoxShadow(
            color: colorBlackBlock.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: offset3,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(iconArrowBack, color: colorWhitewithLittleOpacity),
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
          const SizedBox(width: 16),
          Text(
            widget.character['name'],
            style: TextStyle(fontSize: highFontSize, fontWeight: boldFontWeight, color: colorWhitewithLittleOpacity),
          ),
        ],
      ),
    );
  }

  Widget _buildInformations() {
    return Container(
      padding: highPadding,
      child: Column(
        children: [
          Text(
            "Vous entrez en discussion avec ${widget.character['name']}.",
            style: TextStyle(
              fontSize: littleFontSize,
              fontStyle: italicFontStyle,
              color: colorWhitewithLittleOpacity,
            ),
            textAlign: centerTextAlign,
          ),
          const SizedBox(height: 8),
            Text(
              "Cette conversation est générée par une intelligence artificielle, elle n'est pas réelle et peut contenir des erreurs. Une question ? Un souci ? Contactez contact@baptistecainjo.fr.",
              style: TextStyle(
                fontSize: littleFontSize,
                fontStyle: italicFontStyle,
                color: colorWhitewithLittleOpacity,
              ),
              textAlign: centerTextAlign,
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
              alignment: index % 2 == 0 ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: index % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        index % 2 == 0 ? const NetworkImage(pictureImage) : NetworkImage(widget.character['image']),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: normalPadding,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: index % 2 == 0 
                                ? const [Color(0xFF405de6), Color(0xFF5851db)]
                                : const [Color(0xFF9E9E9E), Color(0xFF9E9E9E)]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        combinedMessages[index],
                        style: const TextStyle(color: colorWhite),
                      ),
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
      padding: normalPadding,
      decoration: BoxDecoration(
        color: colorBlackBlock,
        boxShadow: [
          BoxShadow(
            color: colorBlackBlock.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: offset3,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Votre message...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: colorWhite.withOpacity(0.75), fontSize: 15),
              ),
              style: const TextStyle(
                color: colorWhite,
              ),
            ),
          ),
          IconButton(
            icon: _isCharacterResponding ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)) : iconSend,
            color: colorWhite,
            onPressed: _isCharacterResponding ? null : sendMessage,
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
        _isCharacterResponding = true;
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
          {
            'role': 'system',
            "content":
                "Tu es l'assistant d'une application de conversations historiques interactives qui vise à fournir une expérience d'apprentissage immersive en permettant aux utilisateurs d'engager des conversations réalistes avec des personnages historiques. Aujourd'hui, tu incarnes le personnage ${widget.character['name']}. Tu dois répondre aux questions de l'utilisateur en te basant sur tes connaissances historiques et ta personnalité. Tu peux aussi poser des questions à l'utilisateur pour mieux comprendre ses besoins. Au niveau du ton à employer, il est important de maintenir une approche respectueuse et authentique, reflétant le contexte historique et la personnalité du personnage incarné. Il convient d'utiliser un langage approprié à l'époque et au statut social du personnage, tout en restant accessible et compréhensible pour l'utilisateur contemporain. Voici une petite description du personnage ${widget.character['name']} : - Courte description : ${widget.character['shortDescription']}. - Description : ${widget.character['description']}. - Période : ${widget.character['period']}."
          },
          {'role': 'user', 'content': message}
        ],
        'model': 'gpt-3.5-turbo',
      }),
    );

    // print(response.body);

    final Map<String, dynamic> data = jsonDecode(utf8.decode(response.body.codeUnits));
    final String chatGPTextGenerate = data['choices'][0]['message']['content'];

    setState(() {
      chatHistory.add(chatGPTextGenerate);
      _isCharacterResponding = false;
    });
  }
}
