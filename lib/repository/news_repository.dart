import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/model/news_model.dart';

class NewsRepository {
  Future<List<ArticleModel>> fetchArticles({@required String? country}) async {
    // final String apiKey = 'YOUR_NEWS_API_KEY';
    // final String baseUrl = 'https://newsapi.org/v2/top-headlines';
    final String requestUrl = 'https://newsapi.org/v2/top-headlines?country=$country&apiKey=85940a4d7b23488ba7ecd9e9e7c6533e';

    final response = await http.get(Uri.parse(requestUrl));
    List<ArticleModel> newsList = [];

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        for (var item in jsonResponse['articles']) {
          final article = ArticleModel.fromJson(item);
          newsList.add(article);
        }

        return newsList;
      }

      return newsList;
    } catch (e) {
      return newsList;
    }
  }
}
