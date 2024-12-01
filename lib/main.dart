import 'package:flutter/material.dart';
import 'package:jokes_app/controllers/joke_controller.dart';
import 'models/joke_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final JokeController _jokeController = JokeController();
  late Future<String> _jokes;

  @override
  void initState() {
    super.initState();
    _loadJokes();
  }

  // Function to load jokes
  void _loadJokes() {
    setState(() {
      _jokes = _jokeController.getJokes();
    });
  }

  // Function to handle refresh action
  Future<void> _onRefresh() async {
    _loadJokes(); // Reload jokes
    await Future.delayed(
        const Duration(seconds: 0)); // Optional: Simulate loading delay
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jokes App",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.tealAccent,
          elevation: 4,
          centerTitle: true,
          title: Text(
            'Jokes App',
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              letterSpacing: 10,
            ),
          ),
        ),
        body: RefreshIndicator(
          color: Colors.teal,
          onRefresh: _onRefresh, // Trigger refresh when pulled down
          child: FutureBuilder<String>(
            future: _jokes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error occurred: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final jokes = snapshot.data!;
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        jokes,
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text('No jokes available'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
