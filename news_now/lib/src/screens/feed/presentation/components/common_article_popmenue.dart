// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:news_now/src/common_widgets/custom_snackbar.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/constants/screen_enums.dart';
import 'package:news_now/src/data_bank.dart';
import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/feed/presentation/article_discription_screen.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
import 'package:provider/provider.dart';

class CommonArticlePopMenue extends StatefulWidget {
  const CommonArticlePopMenue({
    super.key,
    required this.newsArticle,
    required this.iconSize,
    required this.screenName,
  });

  final NewsArticle newsArticle;
  final double iconSize;
  final ScreenType? screenName;

  @override
  State<CommonArticlePopMenue> createState() => _CommonArticlePopMenueState();
}

class _CommonArticlePopMenueState extends State<CommonArticlePopMenue> {
  @override
  Widget build(BuildContext context) {
    final UserInformation userInformation =
        Provider.of<DataBank>(context, listen: false).userInformation;

    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: const Icon(
        Icons.more_vert_sharp,
        color: AppColors.textPrimaryColor,
      ),
      iconSize: widget.iconSize,
      color: AppColors.accentColor,
      onSelected: (value) async {
        if (userInformation.userId == 'default') {
          CustomSnackBar.showErrorSnackBar(context,
              message: "Please Login or Signup!");
        } else {
          if (value == 11) {
          } else if (value == 12) {
          } else if (value == 2) {
            Navigator.of(context).pushNamed(
              ArticleDiscriptionScreen.routeName,
              arguments: widget.newsArticle,
            );
          } else if (value == 3) {
          } else if (value == 4) {
            // await FirebaseDatabase.instance.ref('reports/articles').push().set({
            //   "userId": userInformation.userId.toString(),
            //   "articleId": widget.newsArticle.articleId.toString(),
            //   "usersName": userInformation.fullName.toString(),
            //   "reportedTime": DateTime.now().toString(),
            // });
            CustomSnackBar.showSuccessSnackBar(context,
                message: "REST EASY, Article is reported!");
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.mode_comment),
              SizedBox(
                width: 10,
              ),
              Text("Comment")
            ],
          ),
        ),
        // PopupMenuItem(
        //   value: 3,
        //   child: Row(
        //     children: [
        //       const Icon(Icons.block_rounded),
        //       const SizedBox(
        //         width: 10,
        //       ),
        //       Flexible(
        //         child: Text(
        //           "Don't show articles from ${newsArticle.username}",
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        const PopupMenuItem(
          value: 4,
          child: Row(
            children: [
              Icon(Icons.flag),
              SizedBox(
                width: 10,
              ),
              Text("Report")
            ],
          ),
        ),
      ],
    );
  }
}
