import 'dart:convert';
import 'package:historyai/screens/allCharacters_screen.dart';
import 'package:historyai/utils/constants.dart';
import 'package:historyai/utils/functions.dart';
import 'package:historyai/screens/discussion_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
      characterData.sort((a, b) {
        Map<String, dynamic> characterMapA = jsonDecode(a);
        Map<String, dynamic> characterMapB = jsonDecode(b);
        String periodA = characterMapA['period'];
        String periodB = characterMapB['period'];

        List<String> periodOrder = ['Préhistoire', 'Antiquité', 'Moyen Age', 'Époque contemporaine'];

        int indexA = periodOrder.indexOf(periodA);
        int indexB = periodOrder.indexOf(periodB);

        return indexA.compareTo(indexB);
      });

      setState(() {
        characterCount = characterData.length;
        characters = characterData.map((character) => jsonDecode(character) as Map<String, dynamic>).toList();
      });
    }
  }

  Widget _buildNavigationBar(BuildContext context, String period) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorPrimary,
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
            icon: Icon(Icons.arrow_back, color: colorWhite),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                "History AI",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTitle(String period) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllCharacters(period: period, characters: characters),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.calendar_today,
              color: colorWhite,
              size: 24,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorWhite,
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              child: Row(
                children: [
                  Text(
                    "Voir tout",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorWhite,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: colorWhite,
                    size: 24,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      characters[index]['name'],
                      style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 20),
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
                        color: colorPrimary,
                        onPressed: () {
                          showCharacterDialog(context, characters[index]);
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.star_border, color: Colors.red, size: 30.0),
                      //   onPressed: () async {
                      //     showDialog(
                      //         context: context,
                      //         builder: (context) => AlertDialog(
                      //               title: Text("Noter ce personnage"),
                      //               content: TextField(
                      //                 controller: _textFieldController,
                      //                 keyboardType: TextInputType.number,
                      //                 inputFormatters: [
                      //                   FilteringTextInputFormatter.allow(RegExp('[1-5]')),
                      //                 ],
                      //                 maxLength: 1,
                      //                 decoration: InputDecoration(
                      //                   hintText: "Entre ta note (1-5)",
                      //                 ),
                      //               ),
                      //               actions: [
                      //                 TextButton(
                      //                     onPressed: () {
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: Text("Annuler")),
                      //                 TextButton(
                      //                     onPressed: () {
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: Text("Valider")),
                      //               ],
                      //             ));
                      //   },
                      // ),
                    ],
                  ),
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildNavigationBar(context, ""),
            Expanded(
              child: ListView.builder(
                itemCount: characterCount,
                itemBuilder: (context, index) {
                  Map<String, dynamic> character = characters[index];
                  String period = character['period'];

                  if (index == 0 || characters[index - 1]['period'] != period) {
                    return Column(
                      children: [
                        _buildPeriodTitle(period),
                        _buildCharacterList(index),
                      ],
                    );
                  } else {
                    return _buildCharacterList(index);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
