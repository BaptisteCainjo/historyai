import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historyai/screens/prehome_screen.dart';
import 'package:historyai/utils/constants.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
DateTime now = DateTime.now();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: poppinsFontFamily,
        primaryColor: colorBlackBlock,
        scaffoldBackgroundColor: colorBlackBkg,
      ),
      home: const PreHomePage(title: 'History.ai'),
    );
  }
}