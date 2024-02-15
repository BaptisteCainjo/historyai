import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historyai/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:slugify/slugify.dart';
import 'package:uuid/uuid.dart';

Future initSharedPreferences(database) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Uuid uuid = Uuid();

  await preferences.remove('data');

  List<String> characters = database;
  List<String> characterSlugify = characters.map((name) => slugify(name)).toList();

  String? GOOGLE_API_KEY = dotenv.env['GOOGLE_API_KEY'];

  try {
    for (int i = 0; i < characterSlugify.length; i++) {
      String period;
      int divisor = characters.length ~/ 4;
      (i < divisor)
          ? period = "Préhistoire"
          : (i < divisor * 2)
              ? period = "Antiquité"
              : i < divisor * 3
                  ? period = "Moyen Age"
                  : period = "Époque contemporaine";

      String reqGoogle =
          'https://kgsearch.googleapis.com/v1/entities:search?query=${characterSlugify[i]}&key=${GOOGLE_API_KEY}&limit=1&indent=True&languages=fr';

      http.Response response = await http.get(Uri.parse(reqGoogle));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseAllData = json.decode(response.body);

        if (responseAllData.containsKey('itemListElement') && responseAllData['itemListElement'].isNotEmpty) {
          Map<String, dynamic>? data = responseAllData['itemListElement'][0]['result'];
          double dataResultScore = responseAllData['itemListElement'][0]['resultScore'];
          print(data?['name']);
          print(dataResultScore);

          String description = data?['detailedDescription']['articleBody'];

          String? shortDescription = data?['description'];
          if (shortDescription == null) {
            String? detailedDescription = data?['detailedDescription']?['articleBody'];
            if (detailedDescription != null) {
              List<String> sentences = detailedDescription.split('.');
              shortDescription = sentences.isNotEmpty ? sentences[0].trim() + '.' : null;
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
                "period": period,
                "lifeDate": "",
                "shortDescription": shortDescription,
                "description": description,
                "image": imageUrl,
                "popularity": popularity,
                "rate": "0",
                "creationDate": DateTime.now().toIso8601String(),
                "lastModifiedDate": DateTime.now().toIso8601String()
              },
            ];

            await preferences.setStringList(
                'data', [...?preferences.getStringList('data'), ...db.map((e) => json.encode(e)).toList()]);
          } else {
            print('No detailed description found for ${characterSlugify[i]}.');
          }
        } else {
          print('No itemListElement found for ${characterSlugify[i]}.');
        }
      } else {
        print('Failed to load data for ${characterSlugify[i]}. Status Code: ${response.statusCode}');
      }
    }
  } catch (error) {
    print('Error making API request: $error');
  }
}
