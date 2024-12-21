import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class JokeService{
  final Dio _dio = Dio();
  final String _cacheKey = 'cached_jokes';


  // fetching one joke
  Future<String> getJokes() async {
    try {

      final response = await _dio.get('https://v2.jokeapi.dev/joke/Any');
      final response2 = await _dio.get("https://v2.jokeapi.dev/joke/Any?amount=5");
      print(response2.data['jokes'][0]);

      if (response.statusCode == 200) {
        final data = response.data;
        //print(data['type']);

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


  // Function to fetch or retrieve cached jokes
  Future<List<String>> getMultipleJokes() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    // If connected to the internet
    if (connectivityResult != ConnectivityResult.none) {
      try {
        // Fetch jokes from API
        final response =
        await _dio.get('https://v2.jokeapi.dev/joke/Any?amount=5');


        if (response.statusCode == 200) {
          // Extract jokes from response
          final jokes = response.data['jokes'] as List;

          // Transform jokes into a list of strings
          final jokesList = jokes.map<String>((joke) {
            if (joke['type'] == 'single') {
              return joke['joke']; // Single-line joke
            } else {
              return '${joke['setup']} - ${joke['delivery']}'; // Two-part joke
            }
          }).toList();

          // Cache the jokes

          final prefs = await SharedPreferences.getInstance();
          await prefs.setStringList(_cacheKey, jokesList);

          return jokesList; // Return freshly fetched jokes
        } else {
          throw Exception('Failed to fetch jokes: ${response.statusCode}');
        }
      }
      catch (error) {
        throw Exception('Error occurred: $error');
      }
    } else {
      // If offline, retrieve jokes from cache
      final prefs = await SharedPreferences.getInstance();
      final cachedJokes = prefs.getStringList(_cacheKey);

      if (cachedJokes != null && cachedJokes.isNotEmpty) {
        return cachedJokes; // Return cached jokes
      } else {
        throw Exception('No internet and no cached jokes available.');
      }
    }
  }
}