import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'screens/home_screen.dart';

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

  List<Map<String, dynamic>> data = [
    {
      "id": otziId,
      "name": "Ötzi",
      "period": "Préhistoire",
      "lifeDate": "-3 300",
      "shortDescription":
          "Ötzi est une momie préhistorique découverte dans les Alpes italiennes en 1991.",
      "description":
          "Ötzi a été découvert par des randonneurs dans les Alpes de l'Ötztal, d'où il tire son nom. Sa préservation exceptionnelle est due aux conditions climatiques et à la couche de glace dans laquelle il était enfoui. Ötzi était équipé d'outils, d'armes, et de vêtements, offrant un aperçu fascinant de la vie quotidienne à cette époque. Des analyses ont révélé des tatouages, des parasites intestinaux, et d'autres détails sur sa santé.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/e/ee/Otzi-Quinson.jpg?uselang=fr",
      "schoolProgram": "",
      "popularity": "1",
      "rate": "0",
      "creationDate": DateTime.now().toIso8601String(),
      "lastModifiedDate": DateTime.now().toIso8601String()
    },
    {
      "id": toumaiId,
      "name": "Toumaï",
      "period": "Préhistoire",
      "lifeDate": "-7 000 000",
      "shortDescription":
          "Toumaï est le nom donné à un fossile de primate découvert au Tchad en 2001.",
      "description":
          "Le fossile de Toumaï est considéré comme l'un des plus anciens ancêtres connus de l'homme. Il a été daté d'environ 7 millions d'années et présente des caractéristiques similaires à celles des premiers hominidés. Sa découverte a permis de mieux comprendre l'évolution de l'espèce humaine.",
      "image":
          "https://medias.pourlascience.fr/api/v1/images/view/5a82ac5b8fe56f7c1c01b80e/wide_1300/image.jpg",
      "schoolProgram": "",
      "popularity": "1",
      "rate": "0",
      "creationDate": DateTime.now().toIso8601String(),
      "lastModifiedDate": DateTime.now().toIso8601String()
    }
  ];

  await preferences.setStringList(
      'data', data.map((e) => json.encode(e)).toList());

  print(preferences.getStringList('data'));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'History.ai',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'History.ai'),
    );
  }
}
