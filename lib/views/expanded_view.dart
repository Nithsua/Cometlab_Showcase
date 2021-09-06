import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newslife/models/news.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandedView extends StatelessWidget {
  late final News article;
  late final Color color;
  ExpandedView({Key? key, required this.article, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(article.urlToImage ?? "" + " " + (article.url ?? ""));
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? color
              : Colors.black,
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, isScrolled) => [
          SliverAppBar(
            backgroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? color
                    : Colors.black,
            snap: true,
            floating: true,
          )
        ],
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    article.title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.apply(fontSizeDelta: 3.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Hero(
                    tag: article,
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/placeholder.jpg",
                      image: article.urlToImage != null &&
                              article.urlToImage != ""
                          ? article.urlToImage!
                          : "https://i.pinimg.com/736x/53/ca/5f/53ca5f055ec0e2fc171dc1097aaacd3d.jpg",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: RichText(
                      text: TextSpan(
                          children: article.description != null
                              ? [
                                  TextSpan(
                                    text: article.description?.substring(0, 1),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.apply(heightFactor: 2),
                                  ),
                                  TextSpan(
                                      text: article.description?.substring(1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ]
                              : [TextSpan(text: "")])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          article.publishedAt != null
                              ? DateFormat.MMMd().format(article.publishedAt!)
                              : DateFormat.MMMd().format(DateTime.now()),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.circle,
                          size: 5,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          article.source.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Container(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                width: 1,
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                              )),
                          onPressed: () {
                            Share.share("Check this article out " +
                                (article.url ?? ""));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.share,
                              size: 23,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: MaterialButton(
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                          onPressed: () async {
                            try {
                              await launch(article.url!);
                              // await launch("");
                            } on PlatformException catch (e) {
                              print(e);
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        title: Text("Oops"),
                                        content: Text(
                                            "Trouble opening the article. please try again later"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text("Ok",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6),
                                              ))
                                        ],
                                      ));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Read Full Story",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
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
  }
}
