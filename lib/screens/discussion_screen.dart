import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final Map<String, dynamic> character;

  ConversationPage(this.character);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildNavigationDiscussion(),
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
          CircleAvatar(
            backgroundImage: NetworkImage(widget.character['image']),
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

  Widget _buildDiscussion() {
    return Expanded(
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: _messages[index].startsWith('You:')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: _messages[index].startsWith('You:')
                      ? LinearGradient(
                          colors: [Color(0xFF405de6), Color(0xFF5851db)],
                        )
                      : LinearGradient(
                          colors: [Colors.grey],
                        ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _messages[index],
                  style: TextStyle(color: Colors.white),
                ),
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
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add('You: $message');
        // Ajoutez ici la logique pour obtenir la réponse du personnage
        // Par exemple, vous pourriez utiliser une fonction asynchrone ou appeler une API
        // et ajouter la réponse du personnage à la liste `_messages`.
      });
      _messageController.clear();
    }
  }
}
