import 'package:newslife/models/news.dart';
import 'package:newslife/services/http.dart';

String host = "newsapi.org";
String excludeDomains = "";
String language = "en";
String country = "us";
// String excludeDomains = "informationweek.com";

class NewsAPIService {
  static Future<List<News>> getHeadlines() async {
    Uri url = Uri.https(host, "/v2/top-headlines", {
      "page": "1",
      "pageSize": "10",
      "sortBy": "publishedAt",
      "excludeDomains": excludeDomains,
      "language": language,
      "country": country
    });

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
    Uri url = Uri.https(host, "/v2/everything", {
      "page": "1",
      "pageSize": "50",
      "q": "tech",
      "sortBy": "publishedAt",
      "excludeDomains": excludeDomains,
      "language": language,
      // "country": country
    });

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

  static Future<List<News>> search(String searchQuery) async {
    Uri url = Uri.https(host, "/v2/everything", {
      "page": "1",
      "pageSize": "100",
      "q": searchQuery,
      "sortBy": "publishedAt",
      "language": language,
      "excludeDomains": excludeDomains
    });

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
