import 'package:newslife/models/news.dart';

class User {
  String displayName;
  String photoURL;
  String email;

  Map<String, List<News>> bookmarks;

  User(
      {required this.displayName,
      required this.photoURL,
      required this.email,
      required this.bookmarks});
}
