import 'dart:convert';
import 'package:historyai/utils/functions.dart';
import 'package:historyai/screens/discussion_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                        onPressed: () {
                          showCharacterDialog(context, characters[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.star_border,
                            color: Colors.red, size: 30.0),
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
