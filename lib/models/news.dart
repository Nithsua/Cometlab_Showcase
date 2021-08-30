import 'package:flutter/material.dart';
import 'package:newslife/services/getnews.dart';

class NewsCollection extends ChangeNotifier {
  late List<News> newsCollection;

  NewsCollection({required this.newsCollection});

  refreshNews() async {
    newsCollection = await NewsAPIService.getHeadlines();
    notifyListeners();
  }

  static List<News> fromJSON(Map<String, dynamic> json) {
    final List<Map<String, dynamic>> articles = json["articles"];
    return articles.map((article) => News.fromJSON(article)).toList();
  }
}

class News {
  late Source source;
  late String author;
  late String title;
  late String description;
  late String url;
  late String urlToImage;
  late DateTime? publishedAt;
  late String content;

  News(
      {required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.publishedAt,
      required this.content,
      required this.urlToImage,
      required this.url});

  factory News.fromJSON(Map<String, dynamic> json) {
    Source source = Source.fromJSON(json["source"]);
    final author = json["author"] ?? "Anonymous";
    final publishedAt = DateTime.tryParse(json["publishedAt"]);
    return News(
        source: source,
        author: author,
        title: json["title"],
        description: json["description"],
        publishedAt: publishedAt,
        content: json["content"],
        urlToImage: json["urlToImage"],
        url: json["url"]);
  }
}

class Source {
  String? id;
  late String name;

  Source({this.id, required this.name});

  factory Source.fromJSON(Map<String, dynamic> json) {
    return Source(id: json["id"], name: json["name"]);
  }
}
