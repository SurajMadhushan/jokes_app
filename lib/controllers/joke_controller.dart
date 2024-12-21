import 'package:jokes_app/services/joke_service.dart';

class JokeController{
  final JokeService _jokeService = JokeService();

  Future<String> getJokes() async {
    return await _jokeService.getJokes();
  }

  Future<List<String>> getMultipleJokes() async {
    return await _jokeService.getMultipleJokes();
  }
}