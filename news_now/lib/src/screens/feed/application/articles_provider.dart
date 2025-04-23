// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print
import 'package:flutter/widgets.dart';
import 'package:appwrite/appwrite.dart';

import 'package:news_now/src/screens/feed/data/comment.dart';
import 'package:news_now/src/screens/feed/data/upvotes.dart';
import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
import 'package:news_now/src/uitils/server/appwrite.dart';

class ArticlesProvider with ChangeNotifier {
  int _rawSizeOfArticles = 0;
  List<NewsArticle> _newsArticles = [];
  final int articlesPerPage = 5;
  String? _lastDocumentId;
  String? _lastCreatedAt;

  bool _isLoading = false;
  bool _moreArticlesAvailable = true;

  int get rawSizeOfArticles => _rawSizeOfArticles;
  List<NewsArticle> get newsArticles => [..._newsArticles];
  bool get isLoading => _isLoading;
  bool get moreArticlesAvailable => _moreArticlesAvailable;

  void resetFetchingState() {
    _isLoading = false;
    _moreArticlesAvailable = true;
    _lastDocumentId = null;
    _lastCreatedAt = null;
    _newsArticles = [];
  }

  Future<void> fetchAndSetInitArticles() async {
    resetFetchingState();
    _isLoading = true;
    notifyListeners();

    try {
      final documentsResponse = await database.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: APPWRITE_COLLECTION_ID_articles,
        queries: [
          Query.orderDesc('\$createdAt'),
          Query.limit(articlesPerPage),
        ],
      );

      final allArticles = documentsResponse.documents;
      _rawSizeOfArticles = allArticles.length;

      if (allArticles.isEmpty) {
        _moreArticlesAvailable = false;
      } else {
        _lastDocumentId = allArticles.last.$id;
        _lastCreatedAt = allArticles.last.$createdAt; // Store $createdAt value
        _newsArticles = allArticles
            .map((article) => NewsArticle.fromMap(article.data))
            .toList();
      }
    } catch (e) {
      print('Error fetching initial articles: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAndSetMoreArticles() async {
    if (!_moreArticlesAvailable || _isLoading || _lastCreatedAt == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final documentsResponse = await database.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: APPWRITE_COLLECTION_ID_articles,
        queries: [
          Query.orderDesc('\$createdAt'),
          Query.lessThan('\$createdAt', _lastCreatedAt!),
          Query.limit(articlesPerPage),
        ],
      );

      final allArticles = documentsResponse.documents;

      if (allArticles.isEmpty) {
        _moreArticlesAvailable = false;
      } else {
        _lastDocumentId = allArticles.last.$id;
        _lastCreatedAt = allArticles.last.$createdAt;

        final newArticles = allArticles
            .map((article) => NewsArticle.fromMap(article.data))
            .toList();

        _newsArticles.addAll(newArticles);

        if (allArticles.length < articlesPerPage) {
          _moreArticlesAvailable = false;
        }
      }
    } catch (e) {
      print('Error fetching more articles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshArticle(String articleId) async {
    try {
      final refreshedArticle = await fetchAndSetSpecificArticle(articleId);

      if (refreshedArticle != null) {
        // Update the article in our local list if it exists there
        final articleIndex = _newsArticles
            .indexWhere((article) => article.articleId == articleId);

        if (articleIndex != -1) {
          _newsArticles[articleIndex] = refreshedArticle;
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error refreshing article: $e');
    }
  }

  Future<Comments> addComment(
    String articleId,
    UserInformation user,
    Comments comment,
  ) async {
    final commentData = {
      'articles': articleId,
      'commentWritten': comment.commentWritten,
      'users': user.userId,
    };

    try {
      final comment = await database.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: APPWRITE_COLLECTION_ID_comments,
        documentId: ID.unique(),
        data: commentData,
      );

      await refreshArticle(articleId);
      return Comments.fromMap(comment.data, articleId);
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  Future<void> removeComment(
    String articleId,
    UserInformation user,
    Comments comment,
  ) async {
    try {
      await database.deleteDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: APPWRITE_COLLECTION_ID_comments,
        documentId: comment.commentId,
      );

      // Refresh the article to get the updated comments
      await refreshArticle(articleId);
    } catch (e) {
      print('Error removing comment: $e');
      rethrow;
    }
    notifyListeners();
  }

  Future<void> toggleUpvote(String articleId, UserInformation user) async {
    try {
      // Check if user has already upvoted this article
      final upvotesResponse = await database.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: APPWRITE_COLLECTION_ID_upVoted,
        queries: [
          Query.equal('articles', articleId),
          Query.equal('users', user.userId),
        ],
      );

      if (upvotesResponse.documents.isEmpty) {
        // Create upvote if it doesn't exist
        await database.createDocument(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: APPWRITE_COLLECTION_ID_upVoted,
          documentId: ID.unique(),
          data: {
            'articles': articleId,
            'users': user.userId,
          },
        );
      } else {
        // Remove upvote if it exists
        await database.deleteDocument(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: APPWRITE_COLLECTION_ID_upVoted,
          documentId: upvotesResponse.documents.first.$id,
        );
      }

      // Refresh the article to update UI
      await refreshArticle(articleId);
    } catch (e) {
      print('Error toggling upvote: $e');
      rethrow;
    }
  }

  Future<NewsArticle?> fetchAndSetSpecificArticle(String articleId) async {
    try {
      // Get the specific article
      final article = await database.getDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: APPWRITE_COLLECTION_ID_articles,
        documentId: articleId,
      );

      return NewsArticle.fromMap(article.data);
    } catch (e) {
      print('Error fetching specific article: $e');
      return null;
    } finally {
      notifyListeners();
    }
  }
}
