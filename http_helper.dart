import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:movie_firman/movie.dart';

class HttpHelper {
  final String urlKey = "api_key=0ce75a2aa74d5565ffa2dcea51ce9724";
  final String urlBase = "https://api.themoviedb.org/3/movie";
  final String urlUpcoming = "/upcoming?";
  final String urlLanguage = "&language=id-ID";
  final String urlRegion = "&region=ID";
  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?api_key=0ce75a2aa74d5565ffa2dcea51ce9724&query=';

  Future<List> getUpcoming() async {
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    Response result = await get(Uri.parse(upcoming));

    if (result.statusCode == HttpStatus.ok) {
      final Jsonresponse = json.decode(result.body);
      final List MoviesMap = Jsonresponse['results'];
      List movies = MoviesMap.map((e) => Movie.fromJson(e)).toList();
      return movies;
    } else {
      return [];
    }
  }

  Future<List> findMovies(String title) async {
    final String query = urlSearchBase + title;
    Response resul = await get(Uri.parse(query));

    if (resul.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(resul.body);
      final List moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((e) => Movie.fromJson(e)).toList();
      return movies;
    } else {
      return [];
    }
  }
}
