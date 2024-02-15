import 'package:flutter/material.dart';
import 'package:historyai/utils/constants.dart';

void showCharacterDialog(BuildContext context, Map<String, dynamic> character) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: colorBlackBkg,
      title: RichText(
        text: TextSpan(
          text: character['name'],
          style: const TextStyle(
            fontWeight: boldFontWeight,
            fontSize: highFontSize,
            color: colorWhite,
          ),
          children: <TextSpan>[
            TextSpan(
              text: " - ${character['period']}",
              style: const TextStyle(
                fontStyle: italicFontStyle,
                fontWeight: normalFontWeight,
                fontSize: titleFontSize,
              ),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: startCrossAxisAlignment,
          children: [
            Center(
              child: SizedBox(
                height: 175,
                child: Image.network(
                  character['image'],
                  fit: coverBoxFit,
                  alignment: Alignment.center,
                ),
              ),
            ),

            const SizedBox(height: 5),
            Center(
              child: Text(
                character['shortDescription'],
                style: const TextStyle(fontStyle: italicFontStyle, color: colorWhite),
                textAlign: centerTextAlign,
              ),
            ),
            const SizedBox(height: 15),
            const Divider(color: colorWhite),
            const SizedBox(height: 15),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: colorWhite,
                ),
                children: [
                  const TextSpan(
                    text: "Description : ",
                    style: TextStyle(
                      fontWeight: boldFontWeight,
                      fontSize: mediumFontSize,
                    ),
                  ),
                  TextSpan(
                    text: character['description'],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
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
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: colorWhite,
                ),
                children: [
                  const TextSpan(
                    text: "Popularité : ",
                    style: TextStyle(
                      fontWeight: boldFontWeight,
                      fontSize: mediumFontSize,
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
          child: const Text("Fermer"),
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
    return sentences.isNotEmpty ? '${sentences[0].trim()}.' : null;
  }
}

String calculatePeriodManyCharacter(int length, int index) {
    if (index >= 0 && index <= 5) {
      return period1;
    } else if (index >= 6 && index <= 17) {
      return period2;
    } else if (index >= 18 && index <= 25) {
      return period3;
    } else {
      return period4;
    }
}

String calculatePeriodFewCharacter(int length, int index) {
    if (index >= 0 && index <= 1) {
      return period1;
    } else if (index >= 2 && index <= 3) {
      return period2;
    } else if (index >= 4 && index <= 5) {
      return period3;
    } else {
      return period4;
    }
}
