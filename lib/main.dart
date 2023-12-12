import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wikipedia/wikipedia.dart'; // !!!  https://pub.dev/packages/wikipedia/example

void main() async {
  runApp(const MyApp());
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  late TextEditingController _controllerWikipedia;
  List<String> chatHistory = [];
  List<Map<String, dynamic>> character = [
    {
      'id': 1,
      'name': 'Georges Clemenceau',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/c/c7/Georges_Clemenceau_par_Nadar.jpg',
    }
  ];

  bool _loading = false;
  List<WikipediaSearch> _data = [];

  @override
  void initState() {
    _controllerWikipedia = TextEditingController(text: "What is Flutter");
    getLandingData();
    super.initState();
  }

  Future<void> _sendRequest(message) async {
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
      chatHistory.add('Message de l\'assitant : $chatGPTextGenerate');
    });
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
            Text("Communique avec l'assitant textuel !"),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Entre ton message !',
              ),
            ),
            TextField(
              controller: _controllerWikipedia,
              decoration: InputDecoration(
                  hintText: "Search...",
                  suffixIcon: InkWell(
                    child: const Icon(Icons.search, color: Colors.black),
                    onTap: () {
                      getLandingData();
                    },
                  )),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _sendRequest(_controller.text);
              },
            ),
            Text(
              chatHistory.toString(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _data.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) => InkWell(
                  child: const Icon(Icons.search, color: Colors.black),
                  onTap: () async {
                    Wikipedia instance = Wikipedia();
                    setState(() {
                      _loading = true;
                    });
                    var pageData = await instance.searchSummaryWithPageId(
                        pageId: _data[index].pageid!);
                    setState(() {
                      _loading = false;
                    });
                    print(instance);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getLandingData() async {
    try {
      setState(() {
        _loading = true;
      });
      Wikipedia instance = Wikipedia();
      var result =
          await instance.searchQuery(searchQuery: _controller.text, limit: 10);
      setState(() {
        _loading = false;
        _data = result!.query!.search!;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }
}
