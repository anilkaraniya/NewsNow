import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/constants/screen_enums.dart';

import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/feed/presentation/components/common_article_popmenue.dart';

class ArticleDiscriptionAppBar extends StatelessWidget {
  final NewsArticle newsArticle;
  const ArticleDiscriptionAppBar({
    super.key,
    required this.newsArticle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        articleInformationWidget(),
        Row(
          children: [
            CommonArticlePopMenue(
              newsArticle: newsArticle,
              iconSize: 35,
              screenName: ScreenType.articleDiscription,
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textPrimaryColor,
                size: 40,
              ),
            ),
          ],
        )
      ],
    );
  }

  SizedBox articleInformationWidget() {
    return SizedBox(
      width: 150,
      child: Row(
        children: [
          newsArticle.user!.profilePicture == null ||
                  newsArticle.user!.profilePicture!.isEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: const Image(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/profilePlaceholder.jpeg"),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      scale: 15,
                      newsArticle.user!.profilePicture!,
                    ),
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsArticle.user!.userName!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textPrimaryColor),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "Published on ${DateFormat("yMMMd").format(
                    newsArticle.publishedDate!,
                  )}",
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
