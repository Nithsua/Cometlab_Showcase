import 'package:flutter/material.dart';
import 'package:newslife/services/getnews.dart';

class HeadlineCollection extends ChangeNotifier {
  late List<News> newsCollection;

  HeadlineCollection({required this.newsCollection});

  Future<void> refreshNews() async {
    try {
      newsCollection = await NewsAPIService.getHeadlines();
    } catch (e) {
      print("Unable to reach probably no internet");
      return;
    }
    notifyListeners();
  }

  static List<News> fromJSON(Map<String, dynamic> json) {
    final List<dynamic> articles = json["articles"];
    return articles.map((article) => News.fromJSON(article)).toList();
  }
}

class FeedCollection extends ChangeNotifier {
  late List<News> newsCollection;

  FeedCollection({required this.newsCollection});

  Future<void> refreshNews() async {
    try {
      newsCollection = await NewsAPIService.getFeed();
    } catch (e) {
      print("Unable to reach probably no internet");
      return;
    }
    notifyListeners();
  }

  static List<News> fromJSON(Map<String, dynamic> json) {
    final List<dynamic> articles = json["articles"];
    return articles.map((article) => News.fromJSON(article)).toList();
  }
}

class News {
  Source source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

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
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        publishedAt: publishedAt,
        content: json["content"] ?? "",
        urlToImage: json["urlToImage"] ?? "",
        url: json["url"] ?? "");
  }
}

class Source {
  String? id;
  String? name;

  Source({this.id, required this.name});

  factory Source.fromJSON(Map<String, dynamic> json) {
    return Source(id: json["id"], name: json["name"]);
  }
}
