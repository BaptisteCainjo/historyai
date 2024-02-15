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
        title: Text(widget.title, style: TextStyle(color: colorWhite)),
        backgroundColor: colorPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton('Version Lite', colorPrimary, databaseHome, "10 secondes"),
            SizedBox(height: 20),
            _buildButton('Version Complète', colorGold, databaseAllCharacters, "1 minute"),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, List<String> database, String time) {
    return ElevatedButton(
      onPressed: () async {
        await _handleButtonPress(database);
      },
      child: Text.rich(
        TextSpan(
          text: text,
          style: TextStyle(color: colorWhite),
          children: [
            TextSpan(
              text: ' (Temps de chargement : <' + time + ')',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: colorWhite,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: TextStyle(fontSize: 18),
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
