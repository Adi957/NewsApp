import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/Models/categories_new_model.dart';
import 'package:newsapp/Models/news_channel_headlines_model.dart';

class NewsRepository {
//
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=47437ce92f43479382285b8bd335d87f';

// its asking about the URI but we have URL so we converted our URL into URI by uri.parse(url)
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      //above data came in response so we have to pull out the body
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=47437ce92f43479382285b8bd335d87f';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
