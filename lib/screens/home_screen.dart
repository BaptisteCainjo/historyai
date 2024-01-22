import 'dart:convert';
import 'package:historyai/screens/discussion_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> chatHistory = [];
  bool _loading = false;
  List<Map<String, dynamic>> characters = [];
  int characterCount = 0;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataFromSharedPreferences();
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? characterData = preferences.getStringList('data');

    if (characterData != null) {
      characterCount = characterData.length;

      for (String character in characterData) {
        Map<String, dynamic> characterMap = jsonDecode(character);
        setState(() {
          characters.add(characterMap);
        });
      }
    }
  }

  Future<void> _sendRequest(String message) async {
    setState(() {
      chatHistory.add('Message de l\'utilisateur : $message');
    });

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
      chatHistory.add('Message de l\'assistant : $chatGPTextGenerate');
    });
  }

  final String textForCommunicate = "Communique avec l'assistant textuel !";
  final String textInputDecorationHintText = "Entre ton message !";
  final iconSend = Icons.send;

  Widget _buildCharacterList(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationPage(characters[index]),
          ),
        );
      },
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.network(
                    characters[index]['image'],
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          characters[index]['name'],
                          style: TextStyle(
                              color: const Color.fromARGB(255, 170, 4, 4),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          characters[index]['shortDescription'],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ])),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.info_outline, size: 30.0),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: RichText(
                                text: TextSpan(
                                  text: characters[index]['period'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: " - " + characters[index]['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Image.network(
                                        characters[index]['image'],
                                        height: 400,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        characters[index]['shortDescription'],
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    Divider(),
                                    SizedBox(height: 25),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 700.0,
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Description : ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: characters[index]
                                                  ['description'],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Naissance : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: characters[index]['lifeDate'],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Programme scolaire : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: characters[index]
                                                ['schoolProgram'],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Popularité : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: characters[index]
                                                ['popularity'],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Note : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: characters[index]['rate'],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Fermer"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.star_border, color: Colors.red, size: 30.0),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Noter ce personnage"),
                                    content: TextField(
                                      controller: _textFieldController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[1-5]')),
                                      ],
                                      maxLength: 1,
                                      decoration: InputDecoration(
                                        hintText: "Entre ta note (1-5)",
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Annuler")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Valider")),
                                    ],
                                  ));
                        },
                      ),
                    ],
                  ),
                ],
              ))

          // trailing: Icon(Icons.arrow_back),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(textForCommunicate),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: textInputDecorationHintText,
              ),
            ),
            TextField(
                decoration: InputDecoration(
                    hintText: "Search...",
                    suffixIcon: InkWell(
                      child: const Icon(Icons.search, color: Colors.black),
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                      },
                    ))),
            IconButton(
              icon: Icon(iconSend),
              onPressed: () {
                _sendRequest(_controller.text);
              },
            ),
            Text(
              chatHistory.toString(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: characterCount,
                itemBuilder: (context, index) => _buildCharacterList(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
