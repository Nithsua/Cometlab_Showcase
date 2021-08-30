import 'package:newslife/env/env.dart';
import 'package:newslife/models/news.dart';
import 'package:newslife/services/http.dart';

String host = "newsapi.org";

class NewsAPIService {
  static Future<List<News>> getHeadlines() async {
    Uri url = Uri.https(
        host, "/v2/top-headlines", {"country": "us", "apiKey": apiKey});

    final json;
    try {
      json = await HTTPService.requestData(url);
    } catch (e) {
      return Future.error(e);
    }
    print(json);
    final newsCollection = FeedCollection.fromJSON(json);
    return newsCollection;
  }

  static Future<List<News>> getFeed() async {
    Uri url = Uri.https(host, "/v2/everything",
        {"page": "1", "pageSize": "50", "apiKey": apiKey, "q": "tech"});

    final json;
    try {
      json = await HTTPService.requestData(url);
    } catch (e) {
      return Future.error(e);
    }
    print(json);
    final newsCollection = FeedCollection.fromJSON(json);
    return newsCollection;
  }
}
