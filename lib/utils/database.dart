import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historyai/utils/constants.dart';
import 'package:historyai/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:slugify/slugify.dart';
import 'package:uuid/uuid.dart';

Future<void> initSharedPreferences(List<String> database) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Uuid uuid = const Uuid();
  String? googleApiKey = dotenv.env['GOOGLE_API_KEY'];

  await preferences.remove('data');

  try {
    List<Future<void>> requests = [];

    for (int i = 0; i < database.length; i++) {
      String characterSlug = slugify(database[i]);

      String reqGoogle =
          'https://kgsearch.googleapis.com/v1/entities:search?query=$characterSlug&key=$googleApiKey&limit=1&indent=True&languages=fr';

          // print(reqGoogle);

      requests.add(_processRequest(reqGoogle, uuid, preferences, database, i));
    }

    await Future.wait(requests);
  } catch (error) {
    print(error);
  }
}

Future<void> _processRequest(
    String reqGoogle, Uuid uuid, SharedPreferences preferences, List<String> database, int index) async {
  http.Response response = await http.get(Uri.parse(reqGoogle));

  if (response.statusCode == 200) {
    Map<String, dynamic> responseAllData = json.decode(response.body);

    if (responseAllData.containsKey('itemListElement') && responseAllData['itemListElement'].isNotEmpty) {
      Map<String, dynamic>? data = responseAllData['itemListElement'][0]['result'];
      double dataResultScore = responseAllData['itemListElement'][0]['resultScore'];

String description = data?['detailedDescription']?['articleBody'] ?? "";

      String? shortDescription = data?['description'];
      if (shortDescription == null) {
        String? detailedDescription = data?['detailedDescription']?['articleBody'];
        if (detailedDescription != null) {
          List<String> sentences = detailedDescription.split('.');
          shortDescription = sentences.isNotEmpty ? '${sentences[0].trim()}.' : null;
        }
      }
      if (data != null) {
        String imageUrl = data['image'] != null && data['image'].containsKey('contentUrl')
            ? data['image']['contentUrl']
            : pictureImage;

        String popularity = (dataResultScore > 2000)
            ? "5"
            : (dataResultScore < 2000 && dataResultScore > 1000)
                ? "4"
                : (dataResultScore < 1000 && dataResultScore > 500)
                    ? "3"
                    : (dataResultScore < 250 && dataResultScore > 50)
                        ? "2"
                        : "1";

        String uniqueId = uuid.v4();
        List<Map<String, dynamic>> db = [
          {
            "id": uniqueId,
            "name": data['name'],
            "period": database.length >= 25
                ? calculatePeriodManyCharacter(database.length, index)
                : calculatePeriodFewCharacter(database.length, index),
            "shortDescription": shortDescription,
            "description": description,
            "image": imageUrl,
            "popularity": popularity,
            // "lifeDate": "",
            // "rate": "0",
            "creationDate": DateTime.now().toIso8601String(),
            "lastModifiedDate": DateTime.now().toIso8601String()
          },
        ];

        await preferences
            .setStringList('data', [...?preferences.getStringList('data'), ...db.map((e) => json.encode(e)).toList()]);
      }
    }
  }
}
