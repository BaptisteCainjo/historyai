import 'package:flutter/material.dart';
import 'package:historyai/screens/discussion_screen.dart';
import 'package:historyai/utils/constants.dart';

class AllCharacters extends StatefulWidget {
  final String period;
  final List<Map<String, dynamic>> characters;

  AllCharacters({required this.period, required this.characters});

  @override
  AllCharactersState createState() => AllCharactersState();
}

class AllCharactersState extends State<AllCharacters> {
  late List<Map<String, dynamic>> filteredCharacters;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    filteredCharacters = widget.characters;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      padding: normalPadding,
      decoration: BoxDecoration(
        color: colorPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: offset3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(iconArrowBack, color: colorWhite),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Text(
            "Tous les personnages",
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: boldFontWeight,
              color: colorWhite,
            ),
          ),
          IconButton(
            icon: const Icon(iconSearch, color: colorWhite),
            onPressed: () {
              showSearch(context: context, delegate: CharacterSearch(widget.characters));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListCharacters() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredCharacters.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationPage(filteredCharacters[index]),
                ),
              );
            },
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: circleBorderRadius,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(filteredCharacters[index]['image']),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: startCrossAxisAlignment,
                    children: [
                      Text(
                        filteredCharacters[index]['name'],
                        style: const TextStyle(
                          fontWeight: boldFontWeight,
                        ),
                      ),
                      Text(
                        filteredCharacters[index]['shortDescription'].length > lengthLimitingDescCharacters
                            ? '${filteredCharacters[index]['shortDescription'].substring(0, lengthLimitingDescCharacters)}...'
                            : filteredCharacters[index]['shortDescription'],
                        style: const TextStyle(
                          fontStyle: italicFontStyle,
                          fontSize: littleFontSize,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_circle_right,
                    color: colorBlackBlock,
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

class CharacterSearch extends SearchDelegate<String> {
  final List<Map<String, dynamic>> characters;

  CharacterSearch(this.characters);

  @override
  String get searchFieldLabel => "Rechercher un personnage";

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: colorPrimary,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: colorWhite),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(
          color: colorBlackBlock,
          fontSize: titleFontSize,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(iconClear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(iconArrowBack),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Map<String, dynamic>> searchResults =
        characters.where((character) => character['name'].toLowerCase().contains(query.toLowerCase())).toList();
    return _buildSearchResults(searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Map<String, dynamic>> suggestionList = query.isEmpty
        ? characters
        : characters.where((character) => character['name'].toLowerCase().contains(query.toLowerCase())).toList();
    return _buildSearchResults(suggestionList);
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationPage(results[index]),
              ),
            );
          },
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: circleBorderRadius,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(results[index]['image']),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: startCrossAxisAlignment,
                  children: [
                    Text(
                      results[index]['name'],
                      style: const TextStyle(
                        fontWeight: boldFontWeight,
                      ),
                    ),
                    Text(
                      results[index]['shortDescription'].length > 35
                          ? '${results[index]['shortDescription'].substring(0, 35)}...'
                          : results[index]['shortDescription'],
                      style: const TextStyle(
                        fontStyle: italicFontStyle,
                        fontSize: littleFontSize,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_circle_right,
                  color: colorBlackBlock,
                  size: 40,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
