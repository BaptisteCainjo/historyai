import 'package:flutter/material.dart';
import 'package:historyai/screens/home_screen.dart';
import 'package:historyai/utils/constants.dart';
import 'package:historyai/utils/database.dart';

class PreHomePage extends StatefulWidget {
  const PreHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PreHomePage> createState() => _PreHomePageState();
}

class _PreHomePageState extends State<PreHomePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: colorWhite)),
        backgroundColor: colorPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: centerMainAxisAlignment,
          children: <Widget>[
            _buildButton('Version Complète', colorPrimary, databaseAllCharacters, databaseAllCharacters),
            const SizedBox(height: 20),
            _buildButton('Version Lite', colorBlackBlock, databaseHome, databaseHome),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, List<String> database, List characterCount) {
    int characterCount = database.length;
    return ElevatedButton(
      onPressed: () async {
        await _handleButtonPress(database);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: colorWhite,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: const TextStyle(fontSize: titleFontSize, fontFamily: poppinsFontFamily),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(color: colorWhite, fontFamily: poppinsFontFamily),
          ),
          if (characterCount != 0)
            Text.rich(
              TextSpan(
                text: '($characterCount personnages disponibles)',
                style: const TextStyle(fontSize: littleFontSize, fontFamily: poppinsFontFamily),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleButtonPress(List<String> database) async {
    setState(() {
      isLoading = true;
    });
    await initSharedPreferences(database);
    setState(() {
      isLoading = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(),
      ),
    );
  }
}
