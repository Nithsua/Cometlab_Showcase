import 'package:flutter/material.dart';
import 'package:newslife/models/news.dart';
import 'package:newslife/services/getnews.dart';
import 'package:provider/provider.dart';

void main() => runApp(MainView());

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.black as MaterialColor,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 1.0),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.white as MaterialColor,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade800),
        scaffoldBackgroundColor: Colors.white,
      ),
      themeMode: ThemeMode.system,
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) => [
          SliverAppBar(
            snap: true,
            floating: true,
            title: Text("BlogLife"),
          )
        ],
        body: FutureBuilder(
            future: NewsAPIService.getHeadlines(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final newsCollection = snapshot.data as List<News>;
                return ChangeNotifierProvider(
                    create: (context) =>
                        NewsCollection(newsCollection: newsCollection),
                    builder: (context, _) {
                      return RefreshIndicator(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: "Discover",
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      children: [
                                        TextSpan(
                                          text: "Trending News",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.apply(fontWeightDelta: 2),
                                        ),
                                        TextSpan(
                                          text: "Daily",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        )
                                      ]),
                                ),
                                Column(
                                  children: [],
                                )
                              ],
                            ),
                          ),
                          onRefresh: () => Provider.of<NewsCollection>(context,
                                  listen: false)
                              .refreshNews());
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
            }),
      ),
    );
  }
}
