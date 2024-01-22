import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:wikipedia/wikipedia.dart'; // Remplacer par une requette avec l'api openia au lieu d'utiliser le package...

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
DateTime now = DateTime.now();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();
  runApp(const MyApp());
  await dotenv.load(fileName: ".env");
}

Future initSharedPreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String otziId = uuid.v4();
  String toumaiId = uuid.v4();

  await preferences.setStringList('data', [
    '{"id": "$otziId", "name": "Ötzi", "period": "Préhistoire", "lifeDate": "-3300", "shortDescription": "Ötzi est une momie préhistorique découverte dans les Alpes italiennes en 1991.", "description": "Ötzi a été découvert par des randonneurs dans les Alpes de l\'Ötztal, d\'où il tire son nom. Sa préservation exceptionnelle est due aux conditions climatiques et à la couche de glace dans laquelle il était enfoui. Ötzi était équipé d\'outils, d\'armes, et de vêtements, offrant un aperçu fascinant de la vie quotidienne à cette époque. Des analyses ont révélé des tatouages, des parasites intestinaux, et d\'autres détails sur sa santé.", "image": "", "schoolProgram": "", "popularity": "1", "favorite": "0", "creationDate": `${now.toIso8601String()}`, "lastModifiedDate": `${now.toIso8601String()}`}',
    '{"id": "$toumaiId", "name": "Toumaï", "period": "Préhistoire", "lifeDate": "-7 000 000", "shortDescription": "Toumaï est le nom donné à un fossile de primate découvert au Tchad en 2001.", "description": "Le fossile de Toumaï est considéré comme l\'un des plus anciens ancêtres connus de l\'homme. Il a été daté d\'environ 7 millions d\'années et présente des caractéristiques similaires à celles des premiers hominidés. Sa découverte a permis de mieux comprendre l\'évolution de l\'espèce humaine.", "image": "", "schoolProgram": "", "popularity": "1", "favorite": "0", "creationDate": `${now.toIso8601String()}`, "lastModifiedDate": `${now.toIso8601String()}`}',
  ]);

  print(preferences.getStringList('data'));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'History.ai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFE83E80)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'History.ai'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  // late TextEditingController _controllerWikipedia;
  List<String> chatHistory = [];
  List<Map<String, dynamic>> characters = [];

  bool _loading = false;
  // List<WikipediaSearch> _data = [];
  List<Map<String, dynamic>> nameCharacters = [];

  List<String> justnameCharacters = [];

  @override
  void initState() {
    super.initState();
    nameCharacters.forEach((nameCharacter) {
      justnameCharacters.add(nameCharacter["name"]);
    });

    justnameCharacters.forEach((justnameCharacter) {
      // _controllerWikipedia = TextEditingController(text: justnameCharacter);
    });
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
              // controller: _controllerWikipedia,
              decoration: InputDecoration(
                  hintText: "Search...",
                  suffixIcon: InkWell(
                    child: const Icon(Icons.search, color: Colors.black),
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();

                      initSharedPreferences();
                    },
                  )),
            ),
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
                padding: const EdgeInsets.all(8),

                itemBuilder: (context, index) => InkWell(
                  child: ListTile(
                    title: Text('Item $index', style: TextStyle(color: const Color.fromARGB(255, 170, 4, 4))),
                    subtitle: Text('Subtitle $index'),
                    leading: Icon(Icons.circle),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  onTap: () async {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> getLandingData() async {
  //   try {
  //     setState(() {
  //       _loading = true;
  //     });

  //     Wikipedia instance = Wikipedia();
  //     var result = await instance.searchQuery(
  //       searchQuery: _controllerWikipedia.text,
  //       limit: 1,
  //     );

  //     setState(() async {
  //       _loading = false;

  //       for (int i = 0; i < result!.query!.search!.length; i++) {
  //         if (!(result.query!.search![i].pageid == null)) {
  //           var resultDescription = await instance.searchSummaryWithPageId(
  //             pageId: result.query!.search![i].pageid!,
  //           );

  //           if (result != null &&
  //               result.query != null &&
  //               result.query!.search != null) {
  //             _data = result.query!.search!;

  //             for (var name in justnameCharacters) {
  //               _data.forEach((e) {
  //                 characters.add({
  //                   'pageid': e.pageid,
  //                   'title': name,
  //                   'description': resultDescription!.description,
  //                   'snippet': e.snippet,
  //                   'timestamp': e.timestamp,
  //                 });
  //               });
  //             }
  //           } else {
  //             _data = [];
  //             characters = [];
  //           }
  //         }r
  //       }
  //       print(characters);
  //     });
  //   } catch (e) {
  //     print('Erreur lors de la recherche Wikipedia : $e');
  //     setState(() {
  //       _loading = false;
  //       _data = [];
  //       characters = [];
  //     });
  //   }
  // }
}
