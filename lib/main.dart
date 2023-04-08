// Import required packages
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Entry point of the application
void main() {
  runApp(MyApp());
}

// MyApp is the root widget of the application, extending StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Build method returns a widget, creating the app structure and theme
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provide an instance of MyAppState to the widget tree
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          // Configure app theme color scheme
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // Set MyHomePage as the home page of the app
        home: MyHomePage(),
      ),
    );
  }
}

// MyAppState extends ChangeNotifier to manage app state and notify listeners
class MyAppState extends ChangeNotifier {
  // Initialize current with a random WordPair
  var current = WordPair.random();

  // Method to update current with a new random WordPair and notify listeners
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // List of favorite WordPairs
  var favorites = <WordPair>[];

  // Method to toggle favorite status of the current WordPair and notify listeners
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// MyHomePage is a StatefulWidget that manages the navigation and page content
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Index of the selected page
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Determine the widget to display based on the selectedIndex
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    // Create the Scaffold with a NavigationRail and the selected page
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              // Update the selectedIndex when the navigation destination is selected
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          // Display the selected page
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

// GeneratorPage is a StatelessWidget that displays the current word pair
// and provides controls to like the word pair or generate a new one
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // Determine the icon based on whether the current word pair is a favorite
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    // Create the GeneratorPage layout with a BigCard and control buttons
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Create a button to toggle the favorite status of the current word pair
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              // Create a button to generate a new word pair
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// BigCard is a StatelessWidget that displays a word pair in a styled Card
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    // Create a Card widget with padding and a Text widget for the word pair
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}

// FavoritesPage is a StatelessWidget that displays a list of favorite word pairs
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // Display a message if there are no favorites
    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    // Create a ListView with ListTile widgets for each favorite word pair
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
