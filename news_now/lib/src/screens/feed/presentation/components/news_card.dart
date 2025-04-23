import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appwrite/appwrite.dart';
import 'package:news_now/src/common_widgets/custom_snackbar.dart';
import 'package:news_now/src/common_widgets/shimmers_effect.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/constants/screen_enums.dart';
import 'package:news_now/src/screens/feed/data/upvotes.dart';
import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/feed/presentation/article_discription_screen.dart';
import 'package:news_now/src/screens/feed/presentation/components/common_article_popmenue.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
import 'package:news_now/src/uitils/server/appwrite.dart';
import 'package:provider/provider.dart';

class NewsCard extends StatefulWidget {
  final NewsArticle newsArticle;
  final UserInformation? userInformation;
  final ScreenType screenName;
  const NewsCard({
    super.key,
    required this.userInformation,
    required this.newsArticle,
    required this.screenName,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isUpvoted = false;
  bool? isUser;
  late List<ArticleUpvotes>? upVotes = widget.newsArticle.upVotes;
  late int? upVoteCount = widget.newsArticle.upVotes != null
      ? widget.newsArticle.upVotes!.length
      : 0;
  String? existingUpvoteId;

  @override
  void initState() {
    super.initState();
    isUser = widget.userInformation?.userId != null &&
        widget.userInformation?.userId != "default";

    if (isUser! && upVotes != null) {
      final userUpvote = upVotes!.firstWhere(
        (element) =>
            element.userUpVoted.userId == widget.userInformation?.userId,
        orElse: () => ArticleUpvotes(
            id: "",
            userUpVoted: UserInformation(
              userId: "",
              userName: "",
              fullName: '',
              emailId: '',
              joined: null,
            ),
            upvotedTime: DateTime.now(),
            article: null),
      );

      if (userUpvote.id.isNotEmpty) {
        isUpvoted = true;
        existingUpvoteId = userUpvote.id;
      }
    }
  }

  Future<void> upVote() async {
    if (!isUser!) {
      CustomSnackBar.showErrorSnackBar(
        context,
        message: "Please Login or Signup!",
      );
      return;
    }

    setState(() {
      // Optimistic UI update
      if (isUpvoted) {
        upVoteCount = upVoteCount! - 1;
      } else {
        upVoteCount = upVoteCount! + 1;
      }
      isUpvoted = !isUpvoted;
    });

    try {
      if (isUpvoted) {
        // Add upvote
        final upvoteData = {
          'article': widget.newsArticle.articleId,
          'userUpVoted': widget.userInformation!.userId,
        };

        final result = await database.createDocument(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: APPWRITE_COLLECTION_ID_upVoted,
          documentId: ID.unique(),
          data: upvoteData,
        );

        existingUpvoteId = result.$id;
      } else {
        // Remove upvote
        if (existingUpvoteId != null && existingUpvoteId!.isNotEmpty) {
          await database.deleteDocument(
            databaseId: APPWRITE_DATABASE_ID,
            collectionId: APPWRITE_COLLECTION_ID_upVoted,
            documentId: existingUpvoteId!,
          );
          existingUpvoteId = null;
        } else {
          final upvoteResponse = await database.listDocuments(
            databaseId: APPWRITE_DATABASE_ID,
            collectionId: APPWRITE_COLLECTION_ID_upVoted,
            queries: [
              Query.equal('article', widget.newsArticle.articleId),
              Query.equal('userUpVoted', widget.userInformation!.userId!),
            ],
          );

          if (upvoteResponse.documents.isNotEmpty) {
            await database.deleteDocument(
              databaseId: APPWRITE_DATABASE_ID,
              collectionId: APPWRITE_COLLECTION_ID_upVoted,
              documentId: upvoteResponse.documents.first.$id,
            );
          }
        }
      }
    } catch (e) {
      // Revert UI on error
      setState(() {
        if (isUpvoted) {
          upVoteCount = upVoteCount! - 1;
        } else {
          upVoteCount = upVoteCount! + 1;
        }
        isUpvoted = !isUpvoted;
      });

      CustomSnackBar.showErrorSnackBar(
        context,
        message: "Failed to update upvote: ${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentArticle = widget.newsArticle;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Card(
        key: UniqueKey(),
        shadowColor: AppColors.secondaryLightColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
        color: AppColors.secondaryLightColor,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            ArticleDiscriptionScreen.routeName,
            arguments: widget.newsArticle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.newsArticle.user!.profilePicture == null ||
                              widget.newsArticle.user!.profilePicture!.isEmpty
                          ? const CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(
                                "assets/images/profilePlaceholder.jpeg",
                              ),
                            )
                          : CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                widget.newsArticle.user!.profilePicture!,
                              ),
                            ),
                      CommonArticlePopMenue(
                        newsArticle: widget.newsArticle,
                        iconSize: 25,
                        screenName: widget.screenName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                    left: 15.0,
                  ),
                  child: Text(
                    widget.newsArticle.title!,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 15.0),
                  child: Text(
                    DateFormat("yMMMd")
                        .format(widget.newsArticle.publishedDate!),
                    style: TextStyle(
                        fontSize: 15, color: AppColors.textPrimaryColor),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.newsArticle.newsImageURL!,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CustomShimmerEffect.rectangular(
                          height: 150,
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, right: 15, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 90,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: upVote,
                              icon: Icon(
                                Icons.arrow_upward_rounded,
                                color: isUpvoted
                                    ? Colors.green
                                    : AppColors.textPrimaryColor,
                                size: 25,
                              ),
                            ),
                            Text(
                              upVoteCount == null || upVoteCount == 0
                                  ? ""
                                  : "$upVoteCount",
                              style: TextStyle(
                                fontSize: 20,
                                color: isUpvoted
                                    ? Colors.green
                                    : AppColors.textPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (isUser!) {
                                  Navigator.of(context).pushNamed(
                                    ArticleDiscriptionScreen.routeName,
                                    arguments: widget.newsArticle,
                                  );
                                } else {
                                  CustomSnackBar.showErrorSnackBar(
                                    context,
                                    message: "Please Login or Signup!",
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.comment_outlined,
                                color: AppColors.textPrimaryColor,
                                size: 25,
                              ),
                            ),
                            Text(
                              currentArticle.comments == null ||
                                      currentArticle.comments!.isEmpty
                                  ? ""
                                  : currentArticle.comments!.length.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          CustomSnackBar.showErrorSnackBar(
                            context,
                            message: "Share Function is coming soon!",
                          );
                        },
                        icon: const Icon(
                          Icons.send,
                          color: AppColors.textPrimaryColor,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
