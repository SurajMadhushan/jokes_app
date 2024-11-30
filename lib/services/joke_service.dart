import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jokes_app/models/joke_model.dart';

class JokeService{
  final Dio _dio = Dio();

  Future<String> getJokes() async {
    try {
      final response = await _dio.get('https://v2.jokeapi.dev/joke/Any');

      if (response.statusCode == 200) {
        final data = response.data;
        print(data['type']);

        if (data['type'] == 'twopart') {
          return '${data['setup']} - ${data['delivery']}'; // Two-part joke
        }
        else if(data['type'] == 'single') {
          return '${data['joke']}';
        }
        else {
          throw Exception('Unexpected joke format');
        }
      } else {
        throw Exception('Failed to fetch jokes: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred2: $error');
    }
  }
}