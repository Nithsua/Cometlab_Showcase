import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newslife/models/news.dart';
import 'package:newslife/services/firebase.dart';
import 'package:newslife/services/getnews.dart';
import 'package:newslife/views/expanded_view.dart';
import 'package:newslife/views/login_view.dart';

import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final User user;
  HomeView({Key? key, required this.user}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // final List<Map<String, dynamic> navigationRoutes = [{
  //   "name": "World"
  //   "route":
  // }];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/images/????"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CircleAvatar(
                      radius: 25.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: FadeInImage(
                            image: NetworkImage(widget.user.photoURL ?? ""),
                            placeholder:
                                AssetImage("assets/images/avatar.jpeg"),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(widget.user.displayName ?? "",
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(widget.user.email ?? "",
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                firebaseAuthServices.signOutFromGoogle();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                    (route) => false);
              },
              title: Text(
                "Sign Out",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.apply(color: Colors.red),
              ),
            )
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: true,
            snap: true,
            floating: true,
            title: Text("NewsLife"),
            actions: [
              IconButton(
                  onPressed: () => showSearch(
                      context: context, delegate: CustomSearchDelegate()),
                  icon: Icon(Icons.search))
            ],
          )
        ],
        body: FutureBuilder(
            future: initFetch(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final headlines =
                    (snapshot.data as Map<String, List<News>>)["headlines"]!;
                final feed =
                    (snapshot.data as Map<String, List<News>>)["feed"]!;
                return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) =>
                            HeadlineCollection(newsCollection: headlines),
                      ),
                      ChangeNotifierProvider(
                        create: (context) =>
                            FeedCollection(newsCollection: feed),
                      ),
                    ],
                    builder: (context, _) {
                      return RefreshIndicator(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: "Discover ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                        children: [
                                          TextSpan(
                                            text: "Trending News ",
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) =>
                                          Container(
                                        height: constraints.maxWidth + 150,
                                        child: PageView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                Provider.of<HeadlineCollection>(
                                                        context)
                                                    .newsCollection
                                                    .length,
                                            itemBuilder: (context, position) {
                                              final News article = Provider.of<
                                                          HeadlineCollection>(
                                                      context)
                                                  .newsCollection[position];
                                              return Card(
                                                elevation: 0.0,
                                                child: InkWell(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExpandedView(
                                                                  article:
                                                                      article,
                                                                  color: [
                                                                    (Colors.pink[
                                                                        50])!,
                                                                    (Colors.blue[
                                                                        50])!,
                                                                    (Colors.brown[
                                                                        50])!,
                                                                    (Colors.cyan[
                                                                        50])!,
                                                                    (Colors.orange[
                                                                        50])!
                                                                  ][Random.secure()
                                                                      .nextInt(
                                                                          5)]))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: constraints
                                                              .maxWidth,
                                                          child: Hero(
                                                            tag: article,
                                                            child: FadeInImage
                                                                .assetNetwork(
                                                              placeholder:
                                                                  "assets/images/placeholder.jpg",
                                                              image: article.urlToImage !=
                                                                          null &&
                                                                      article.urlToImage !=
                                                                          ""
                                                                  ? article
                                                                      .urlToImage!
                                                                  : "https://i.pinimg.com/736x/53/ca/5f/53ca5f055ec0e2fc171dc1097aaacd3d.jpg",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      16.0),
                                                          child: Text(
                                                            article.title ?? "",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: Text(
                                                                article.publishedAt !=
                                                                        null
                                                                    ? DateFormat
                                                                            .MMMd()
                                                                        .format(article
                                                                            .publishedAt!)
                                                                    : DateFormat
                                                                            .MMMd()
                                                                        .format(
                                                                            DateTime.now()),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: Icon(
                                                                Icons.circle,
                                                                size: 5,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: Text(
                                                                article.source
                                                                        .name ??
                                                                    "",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Your Feed",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          Provider.of<FeedCollection>(context)
                                              .newsCollection
                                              .length,
                                      itemBuilder: (context, position) {
                                        final article =
                                            Provider.of<FeedCollection>(context)
                                                .newsCollection[position];
                                        return Container(
                                          height: 300,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) =>
                                                Card(
                                              elevation: 0.0,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExpandedView(
                                                                  article:
                                                                      article,
                                                                  color: [
                                                                    (Colors.pink[
                                                                        50])!,
                                                                    (Colors.blue[
                                                                        50])!,
                                                                    (Colors.brown[
                                                                        50])!,
                                                                    (Colors.cyan[
                                                                        50])!,
                                                                    (Colors.cyan[
                                                                        50])!
                                                                  ][Random.secure()
                                                                      .nextInt(
                                                                          5)])));
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          constraints.maxWidth,
                                                      height: constraints
                                                              .maxHeight *
                                                          0.6,
                                                      child: Hero(
                                                        tag: article,
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              "assets/images/placeholder.jpg",
                                                          image: article.urlToImage !=
                                                                      null &&
                                                                  article.urlToImage !=
                                                                      ""
                                                              ? article
                                                                  .urlToImage!
                                                              : "https://i.pinimg.com/736x/53/ca/5f/53ca5f055ec0e2fc171dc1097aaacd3d.jpg",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            article.title ?? "",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .subtitle1,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8.0),
                                                            child: Container(
                                                              width: constraints
                                                                      .maxWidth -
                                                                  constraints
                                                                          .maxWidth *
                                                                      0.3 -
                                                                  60,
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child: Text(
                                                                      article.publishedAt !=
                                                                              null
                                                                          ? DateFormat.MMMd().format(article
                                                                              .publishedAt!)
                                                                          : DateFormat.MMMd()
                                                                              .format(DateTime.now()),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .caption,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .circle,
                                                                      size: 5,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child:
                                                                        SizedBox(
                                                                      width: constraints
                                                                              .maxWidth *
                                                                          0.2,
                                                                      child:
                                                                          Text(
                                                                        article.source.name ??
                                                                            "",
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .caption,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          onRefresh: () async {
                            await Provider.of<HeadlineCollection>(context,
                                    listen: false)
                                .refreshNews();
                            await Provider.of<FeedCollection>(context,
                                    listen: false)
                                .refreshNews();
                          });
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                );
              }
            }),
      ),
    );
  }
}

Future<Map<String, List<News>>> initFetch(BuildContext context) async {
  return <String, List<News>>{
    "headlines":
        await NewsAPIService.getHeadlines().onError((error, stackTrace) {
      pushDialog(context);
      return <News>[];
    }),
    "feed": await NewsAPIService.getFeed().onError((error, stackTrace) {
      return <News>[];
    })
  };
}

pushDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Looks like you are not connected to the internet"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Ok",
              style: Theme.of(context).textTheme.headline6,
            ))
      ],
    ),
  );
}

class CustomSearchDelegate extends SearchDelegate {
  List<News> results = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  // @override
  // InputDecorationTheme? get searchFieldDecorationTheme => InputDecorationTheme(
  //     border: InputBorder.none,
  //     enabledBorder: InputBorder.none,
  //     focusedBorder: InputBorder.none,
  //     floatingLabelBehavior: FloatingLabelBehavior.never);

  // @override
  // TextStyle? get searchFieldStyle =>
  //     TextStyle(fontSize: 20, fontFamily: "Roboto");

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        // Navigator.pop(context);
        close(context, results);
      },
      icon: Icon(Icons.arrow_back));

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(onPressed: () => query = "", icon: Icon(Icons.close))];

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: NewsAPIService.search(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<News> articles = snapshot.data as List<News>;
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: articles.length,
                itemBuilder: (context, position) {
                  final article = articles[position];
                  return Container(
                    height: 120,
                    child: LayoutBuilder(
                      builder: (context, constraints) => Card(
                        elevation: 0.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExpandedView(
                                        article: article,
                                        color: [
                                          (Colors.pink[50])!,
                                          (Colors.blue[50])!,
                                          (Colors.brown[50])!,
                                          (Colors.cyan[50])!,
                                          (Colors.cyan[50])!
                                        ][Random.secure().nextInt(5)])));
                          },
                          child: Row(
                            children: [
                              Container(
                                width: constraints.maxWidth * 0.3,
                                height: 120,
                                child: Hero(
                                  tag: article,
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/placeholder.jpg",
                                    image: article.urlToImage != null &&
                                            article.urlToImage != ""
                                        ? article.urlToImage!
                                        : "https://i.pinimg.com/736x/53/ca/5f/53ca5f055ec0e2fc171dc1097aaacd3d.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: constraints.maxWidth -
                                      constraints.maxWidth * 0.3 -
                                      50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Container(
                                          width: constraints.maxWidth -
                                              constraints.maxWidth * 0.3 -
                                              60,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  article.publishedAt != null
                                                      ? DateFormat.MMMd()
                                                          .format(article
                                                              .publishedAt!)
                                                      : DateFormat.MMMd()
                                                          .format(
                                                              DateTime.now()),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 5,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: SizedBox(
                                                  width: constraints.maxWidth *
                                                      0.2,
                                                  child: Text(
                                                    article.source.name ?? "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
