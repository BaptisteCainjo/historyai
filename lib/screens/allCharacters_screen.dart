import 'package:flutter/material.dart';
import 'package:historyai/screens/discussion_screen.dart';
import 'package:historyai/utils/constants.dart';
import 'package:historyai/utils/database.dart';

class AllCharacters extends StatelessWidget {
  final String period;
  final List<Map<String, dynamic>> characters;

  AllCharacters({required this.period, required this.characters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildNavigationBar(context),
          _buildListCharacters(),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: colorWhite),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            "Tous les personnages",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorWhite,
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: colorWhite),
            onPressed: () {
              // Add search functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListCharacters() {
  return Expanded(
    child: ListView.builder(
      itemCount: characters.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationPage(characters[index]),
              ),
            );
          },
          child: Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(characters[index]['image']),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      characters[index]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      characters[index]['shortDescription'],
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                Spacer(), // Ajout du Spacer pour occuper tout l'espace disponible
                Icon(
                  Icons.arrow_circle_right,
                  color: colorGold,
                  size: 40,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

}
