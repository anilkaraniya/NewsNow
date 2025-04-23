import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:news_now/src/uitils/server/appwrite.dart';
import 'package:provider/provider.dart';

import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/constants/screen_enums.dart';
import 'package:news_now/src/package_service/locator_service.dart';
import 'package:news_now/src/repository/auth_repo.dart';
import 'package:news_now/src/screens/feed/application/articles_provider.dart';
import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/feed/presentation/components/news_card.dart';
import 'package:news_now/src/screens/feed/presentation/components/news_card_shimmer.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  static const routeName = '/feed';

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  UserInformation? userInformation;
  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  late ArticlesProvider _articlesProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupScrollListener();
      _initData();
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (!context.mounted) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final threshold = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= threshold) {
        _loadMoreArticles();
      }
    });
  }

  void _loadMoreArticles() {
    if (!_articlesProvider.isLoading &&
        _articlesProvider.moreArticlesAvailable) {
      _articlesProvider.fetchAndSetMoreArticles();
    }
  }

  Future<void> _initData() async {
    if (_isInitialized || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _articlesProvider = Provider.of<ArticlesProvider>(context, listen: false);
    _articlesProvider.resetFetchingState();

    try {
      try {
        await account.get();
        userInformation =
            await locator.get<AuthRepo>().getUserInformation(context);
      } on AppwriteException catch (_) {}

      await _articlesProvider.fetchAndSetInitArticles();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _isInitialized = false;
    });
    return _initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: _hasError
          ? _buildErrorWidget()
          : (!_isInitialized && _isLoading)
              ? _buildLoadingShimmer()
              : _buildContentWidget(context),
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    return Consumer<ArticlesProvider>(
      builder: (ctx, articlesProvider, _) {
        final allArticles = articlesProvider.newsArticles;
        final moreArticlesAvailable = articlesProvider.moreArticlesAvailable;
        final isLoading = articlesProvider.isLoading;

        if (allArticles.isEmpty) {
          return _buildEmptyFeedWidget();
        }

        return _buildArticlesList(
          articles: allArticles,
          moreArticlesAvailable: moreArticlesAvailable,
          isLoading: isLoading,
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30),
            child: Text(
              "My Feed",
              style: TextStyle(
                fontSize: 25,
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (_, __) => const NewsCardShimmer(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            const Text(
              "Error Loading Feed",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _refreshFeed,
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesList({
    required List<NewsArticle> articles,
    required bool moreArticlesAvailable,
    required bool isLoading,
  }) {
    return RefreshIndicator(
      onRefresh: _refreshFeed,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 30, bottom: 25),
              child: Text(
                "My Feed",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryColor,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) => NewsCard(
                key: ValueKey(articles[index].articleId ?? index.toString()),
                newsArticle: articles[index],
                userInformation: userInformation,
                screenName: ScreenType.myFeeds,
              ),
              childCount: articles.length,
            ),
          ),
          SliverToBoxAdapter(
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: NewsCardShimmer(),
                  )
                : !moreArticlesAvailable
                    ? const Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child: Text(
                            "You've reached the end of your feed!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFeedWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.feed_outlined,
              size: 90,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Feed is Empty",
              style: TextStyle(
                color: AppColors.textPrimaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "There are no articles available right now. Please check back later.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _refreshFeed,
              child: const Text("Refresh Feed"),
            ),
          ],
        ),
      ),
    );
  }
}
