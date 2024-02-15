import 'package:flutter/material.dart';
import 'package:historyai/utils/constants.dart';

void showCharacterDialog(BuildContext context, Map<String, dynamic> character) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: RichText(
        text: TextSpan(
          text: character['period'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          children: <TextSpan>[
            TextSpan(
              text: " - " + character['name'],
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
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Image.network(
                  character['image'],
                  height: 400,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Center(
              child: Text(
                character['shortDescription'],
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 25),
            Divider(),
            SizedBox(height: 25),
            Container(
              constraints: BoxConstraints(
                maxWidth: 900.0,
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
                      text: character['description'],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: "Naissance : ",
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18,
            //         ),
            //       ),
            //       TextSpan(
            //         text: character['lifeDate'],
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: "Programme scolaire : ",
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18,
            //         ),
            //       ),
            //       TextSpan(
            //         text: character['schoolProgram'],
            //       ),
            //     ],
            //   ),
            // ),
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
                    text: character['popularity'],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: "Note : ",
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18,
            //         ),
            //       ),
            //       TextSpan(
            //         text: character['rate'],
            //       ),
            //     ],
            //   ),
            // ),
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
}



String? getShortDescription(Map<String, dynamic>? data) {
  if (data?['description'] != null) {
    return data?['description'];
  } else {
    List<String> sentences = data?['detailedDescription']['articleBody'].split('.');
    return sentences.isNotEmpty ? sentences[0].trim() + '.' : null;
  }
}