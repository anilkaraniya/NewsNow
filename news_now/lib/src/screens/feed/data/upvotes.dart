// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';

class ArticleUpvotes {
  String id;
  UserInformation userUpVoted;
  DateTime upvotedTime;
  NewsArticle? article;

  ArticleUpvotes({
    required this.id,
    required this.userUpVoted,
    required this.upvotedTime,
    required this.article,
  });

  ArticleUpvotes copyWith({
    String? id,
    UserInformation? userUpVoted,
    DateTime? upvotedTime,
    NewsArticle? article,
  }) {
    return ArticleUpvotes(
      id: id ?? this.id,
      userUpVoted: userUpVoted ?? this.userUpVoted,
      upvotedTime: upvotedTime ?? this.upvotedTime,
      article: article ?? this.article,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userUpVoted': userUpVoted.toMap(),
      'upvotedTime': upvotedTime.millisecondsSinceEpoch,
      'article': article!.toMap(),
    };
  }

  factory ArticleUpvotes.fromMap(Map<String, dynamic> map) {
    return ArticleUpvotes(
      id: map['\$id'] as String,
      userUpVoted: UserInformation.fromMap(map['userUpVoted']),
      upvotedTime: DateTime.parse(map['\$createdAt']),
      article: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleUpvotes.fromJson(String source) =>
      ArticleUpvotes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArticleUpvotes(id: $id, userUpVoted: $userUpVoted, upvotedTime: $upvotedTime, article: $article)';
  }

  @override
  bool operator ==(covariant ArticleUpvotes other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userUpVoted == userUpVoted &&
        other.upvotedTime == upvotedTime &&
        other.article == article;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userUpVoted.hashCode ^
        upvotedTime.hashCode ^
        article.hashCode;
  }
}
