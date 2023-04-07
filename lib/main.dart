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
}

// MyHomePage is a StatelessWidget that displays the current word pair
class MyHomePage extends StatelessWidget {
  // Build method returns a widget, creating the home page UI
  @override
  Widget build(BuildContext context) {
    // Access MyAppState provided by the ChangeNotifierProvider
    var appState = context.watch<MyAppState>();

    return Scaffold(
      // Create a Column widget to arrange children vertically
      body: Column(
        children: [
          // Display a label as text
          Text('A random AWESOME idea:'),
          // Display the current word pair as lowercase text
          Text(appState.current.asLowerCase),
          // Create an ElevatedButton with a callback to generate a new word pair
          ElevatedButton(
            onPressed: () {
              // Call getNext method from MyAppState to update the current word pair
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
