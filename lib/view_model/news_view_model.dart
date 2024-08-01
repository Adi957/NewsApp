//import 'dart:convert';
//import 'package:flutter/foundation.dart';
import 'package:newsapp/Models/categories_new_model.dart';
import 'package:newsapp/Models/news_channel_headlines_model.dart';
import 'package:newsapp/repository/news_repository.dart';
//import 'package:http/http.dart' as http;

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(
      String channelName) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}
