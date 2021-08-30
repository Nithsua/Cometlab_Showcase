import 'package:newslife/env/env.dart';
import 'package:newslife/models/news.dart';
import 'package:newslife/services/http.dart';

String host = "newsapi.org";

class NewsAPIService {
  static Future<List<News>> getHeadlines() async {
    Uri url = Uri.https(
        host, "/v2/top-headlines", {"country": "us", "apiKey": apiKey});

    final json = await HTTPService.requestData(url);
    final newsCollection = NewsCollection.fromJSON(json);
    return newsCollection;
  }
}
