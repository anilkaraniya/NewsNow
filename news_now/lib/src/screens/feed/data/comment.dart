// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';

class Comments {
  final String commentId;
  final DateTime? timeOfComment;
  final String? commentWritten;
  final UserInformation? user;
  final String? upVotes;
  final NewsArticle? article;

  Comments({
    required this.commentId,
    required this.timeOfComment,
    required this.commentWritten,
    required this.user,
    required this.upVotes,
    this.article,
  });

  Comments copyWith({
    String? commentId,
    DateTime? timeOfComment,
    String? commentWritten,
    UserInformation? user,
    String? upVotes,
    NewsArticle? article,
  }) {
    return Comments(
      commentId: commentId ?? this.commentId,
      timeOfComment: timeOfComment ?? this.timeOfComment,
      commentWritten: commentWritten ?? this.commentWritten,
      user: user ?? this.user,
      upVotes: upVotes ?? this.upVotes,
      article: article ?? this.article,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'timeOfComment': timeOfComment?.toIso8601String(),
      'commentWritten': commentWritten,
      'user': user?.toMap(),
      'upVotes': upVotes,
      'article': article?.toMap(),
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map, String articleId) {
    return Comments(
      commentId: map['\$id']?.toString() ?? map['commentId']?.toString() ?? '',
      timeOfComment: map['\$createdAt'] != null
          ? DateTime.parse(map['\$createdAt'].toString())
          : map['timeOfComment'] != null
              ? DateTime.parse(map['timeOfComment'].toString())
              : null,
      commentWritten: map['commentWritten']?.toString(),
      user: map['users'] != null
          ? UserInformation.fromMap(map['users'] as Map<String, dynamic>)
          : null,
      upVotes: map['upVotes']?.toString(),
      article: NewsArticle(
        articleId: articleId,
        title: null,
        newsImageURL: null,
        discription: null,
        user: null,
        publishedDate: null,
        comments: null,
        upVotes: null,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comments.fromJson(String source) =>
      Comments.fromMap(json.decode(source) as Map<String, dynamic>, "");

  @override
  String toString() {
    return 'Comments(commentId: $commentId, timeOfComment: $timeOfComment, commentWritten: $commentWritten, user: $user, upVotes: $upVotes, article: $article)';
  }

  @override
  bool operator ==(covariant Comments other) {
    if (identical(this, other)) return true;

    return other.commentId == commentId &&
        other.timeOfComment == timeOfComment &&
        other.commentWritten == commentWritten &&
        other.user == user &&
        other.upVotes == upVotes &&
        other.article == article;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        timeOfComment.hashCode ^
        commentWritten.hashCode ^
        user.hashCode ^
        upVotes.hashCode ^
        article.hashCode;
  }
}
