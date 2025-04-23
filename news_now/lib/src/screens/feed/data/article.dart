import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:news_now/src/screens/feed/data/comment.dart';
import 'package:news_now/src/screens/feed/data/upvotes.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';

class NewsArticle {
  final String articleId;
  final String? title;
  final String? newsImageURL;
  final String? discription;
  final UserInformation? user;
  final DateTime? publishedDate;
  final List<Comments>? comments;
  final List<ArticleUpvotes>? upVotes;

  NewsArticle({
    required this.articleId,
    required this.title,
    required this.newsImageURL,
    required this.discription,
    required this.user,
    required this.publishedDate,
    required this.comments,
    required this.upVotes,
  });

  NewsArticle copyWith({
    String? articleId,
    String? title,
    String? newsImageURL,
    String? discription,
    UserInformation? user,
    DateTime? publishedDate,
    List<Comments>? comments,
    List<ArticleUpvotes>? upVotes,
  }) {
    return NewsArticle(
      articleId: articleId ?? this.articleId,
      title: title ?? this.title,
      newsImageURL: newsImageURL ?? this.newsImageURL,
      discription: discription ?? this.discription,
      user: user ?? this.user,
      publishedDate: publishedDate ?? this.publishedDate,
      comments: comments ?? this.comments,
      upVotes: upVotes ?? this.upVotes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'articleId': articleId,
      'title': title,
      'newsImageURL': newsImageURL,
      'discription': discription,
      'user': user?.toMap(),
      'publishedDate': publishedDate?.toIso8601String(),
      'comments': comments?.map((x) => x.toMap()).toList(),
      'upVotes': upVotes?.map((x) => x.toMap()).toList(),
    };
  }

  factory NewsArticle.fromMap(Map<String, dynamic> map) {
    return NewsArticle(
      articleId: map['\$id']?.toString() ?? map['articleId']?.toString() ?? '',
      title: map['title']?.toString(),
      newsImageURL: map['newsImageURL']?.toString(),
      discription: map['discription']?.toString(),
      user: map['user'] != null
          ? UserInformation.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      publishedDate: map['\$createdAt'] != null
          ? DateTime.parse(map['\$createdAt'].toString())
          : map['publishedDate'] != null
              ? DateTime.parse(map['publishedDate'].toString())
              : null,
      comments: map['comments'] != null
          ? List<Comments>.from(
              (map['comments'] as List).map<Comments>(
                (x) => Comments.fromMap(x as Map<String, dynamic>, map['\$id']),
              ),
            )
          : [],
      upVotes: map['upVotes'] != null
          ? List<ArticleUpvotes>.from(
              (map['upVotes'] as List).map<ArticleUpvotes>(
                (x) => ArticleUpvotes.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsArticle.fromJson(String source) =>
      NewsArticle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewsArticle(articleId: $articleId, title: $title, newsImageURL: $newsImageURL, discription: $discription, user: $user, publishedDate: $publishedDate, comments: $comments, upVotes: $upVotes)';
  }

  @override
  bool operator ==(covariant NewsArticle other) {
    if (identical(this, other)) return true;

    return other.articleId == articleId &&
        other.title == title &&
        other.newsImageURL == newsImageURL &&
        other.discription == discription &&
        other.user == user &&
        other.publishedDate == publishedDate &&
        listEquals(other.comments, comments) &&
        listEquals(other.upVotes, upVotes);
  }

  @override
  int get hashCode {
    return articleId.hashCode ^
        title.hashCode ^
        newsImageURL.hashCode ^
        discription.hashCode ^
        user.hashCode ^
        publishedDate.hashCode ^
        comments.hashCode ^
        upVotes.hashCode;
  }
}
