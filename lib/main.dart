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
    _jokes = _jokeController.getJokes();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jokes App",
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
                  'Jokes App',
                style: TextStyle(fontSize: 26,
                color: Colors.white,
                letterSpacing: 10),
          )),
          backgroundColor: Colors.tealAccent,
        ),
        body: FutureBuilder<String>(
          future: _jokes,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.hasError) {
              return Center(
                child: Text('Error occured: ${snapshot.error}'),
              );
            }
            else if(snapshot.hasData){
              final jokes = snapshot.data!;
              return Text(
                jokes
              );


            }
            else{
              return Center(
                child: Text('No jokes available'),
              );
            }
          },
        )
      ),
    );
  }
}

