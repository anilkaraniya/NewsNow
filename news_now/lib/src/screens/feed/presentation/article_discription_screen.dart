// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_now/src/common_widgets/custom_snackbar.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/data_bank.dart';
import 'package:news_now/src/package_service/locator_service.dart';
import 'package:news_now/src/repository/auth_repo.dart';
import 'package:news_now/src/screens/feed/application/articles_provider.dart';
import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/feed/data/comment.dart';
import 'package:news_now/src/screens/feed/presentation/components/article_discription_appbar.dart';
import 'package:news_now/src/screens/feed/presentation/components/comment_box.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
import 'package:provider/provider.dart';
import 'package:profanity_filter/profanity_filter.dart';

// ignore: must_be_immutable
class ArticleDiscriptionScreen extends StatefulWidget {
  const ArticleDiscriptionScreen({super.key});

  static const routeName = "./article-discription-screen";

  @override
  State<ArticleDiscriptionScreen> createState() =>
      _ArticleDiscriptionScreenState();
}

class _ArticleDiscriptionScreenState extends State<ArticleDiscriptionScreen> {
  NewsArticle? newsArticle;

  final commentFormKey = GlobalKey<FormState>();

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    newsArticle = ModalRoute.of(context)!.settings.arguments as NewsArticle;

    final userInformaion =
        Provider.of<DataBank>(context, listen: false).userInformation;
    final isUser = userInformaion.userId != "default";

    return Scaffold(
      body: isUser
          ? CommentBox(
              userImage: userInformaion.profilePicture,
              labelText: 'Start the discussion...',
              withBorder: false,
              errorText: 'Comment cannot be blank',
              sendButtonMethod: () async {
                if (commentFormKey.currentState!.validate()) {
                  final comment = await Provider.of<ArticlesProvider>(context,
                          listen: false)
                      .addComment(
                    newsArticle!.articleId,
                    userInformaion,
                    Comments(
                      commentId: "",
                      timeOfComment: DateTime.now(),
                      commentWritten: commentController.text,
                      user: userInformaion,
                      upVotes: "",
                    ),
                  );
                  setState(() {
                    newsArticle!.comments!.add(comment);
                  });
                  FocusScope.of(context).unfocus();
                  commentController.clear();
                } else {
                  throw Exception("Not validated");
                }
              },
              formKey: commentFormKey,
              commentController: commentController,
              backgroundColor: AppColors.secondaryColor,
              textColor: AppColors.textPrimaryColor,
              sendWidget: const Icon(
                Icons.whatshot_outlined,
                size: 30,
                color: AppColors.textPrimaryColor,
              ),
              child: MainDescriptionContent(
                constNewsArticle: newsArticle!,
              ),
            )
          : MainDescriptionContent(
              constNewsArticle: newsArticle!,
            ),
    );
  }
}

class MainDescriptionContent extends StatelessWidget {
  const MainDescriptionContent({
    super.key,
    required this.constNewsArticle,
  });
  final NewsArticle constNewsArticle;

  @override
  Widget build(
    BuildContext context,
  ) {
    NewsArticle newsArticle = constNewsArticle;
    List<Comments>? allComments = constNewsArticle.comments;
    allComments!.sort(
        (a, b) => b.timeOfComment!.compareTo(a.timeOfComment as DateTime));
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArticleDiscriptionAppBar(
                newsArticle: newsArticle,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                newsArticle.title!,
                style: const TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontSize: 30,
                  wordSpacing: 5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 3,
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
                child: DescriptionTextWidget(text: newsArticle.discription!),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(
                    newsArticle.newsImageURL!,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    "${newsArticle.upVotes!.length} Upvotes",
                    style: const TextStyle(
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${newsArticle.comments!.length} Comments",
                    style: const TextStyle(
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: AppColors.textSecondaryColor,
              ),
              const SizedBox(
                height: 15,
              ),
              if (newsArticle.comments != null)
                ...allComments.map((comment) {
                  return ArticleComments(
                    comment: comment,
                    newsArticle: newsArticle,
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ArticleComments extends StatefulWidget {
  ArticleComments({
    super.key,
    required this.comment,
    required this.newsArticle,
  });

  final Comments comment;
  NewsArticle newsArticle;

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                    child: widget.comment.user!.profilePicture == null ||
                            widget.comment.user!.profilePicture!.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: const Image(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/images/profilePlaceholder.jpeg",
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.comment.user!.profilePicture!,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.user!.userName!,
                        style: const TextStyle(
                            color: AppColors.textSecondaryColor),
                      ),
                      Text(
                        DateFormat("MMMd").format(
                          widget.comment.timeOfComment!,
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              CustomePopupMenue(
                context: context,
                authRepo: locator.get<AuthRepo>(),
                comment: widget.comment,
                tabColor: AppColors.secondaryColor,
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[900],
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(15),
            child: Text(
              ProfanityFilter().censor(widget.comment.commentWritten!),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Row(
          //   children: [
          //     IconButton(onPressed: () {}, icon: const Icon(Icons.add))
          //   ],
          // )
        ],
      ),
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  const DescriptionTextWidget({
    super.key,
    required this.text,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 500) {
      firstHalf = widget.text.substring(0, 500);
      secondHalf = widget.text.substring(500, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: secondHalf!.isEmpty
          ? Text(
              firstHalf!,
              style: TextStyle(
                color: AppColors.textPrimaryColor,
                fontSize: 16,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  flag ? ("${firstHalf!}...") : (firstHalf! + secondHalf!),
                  style: TextStyle(
                    color: AppColors.textPrimaryColor,
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        flag ? "show more" : "show less",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

class CustomePopupMenue extends StatelessWidget {
  const CustomePopupMenue({
    super.key,
    required this.context,
    required this.authRepo,
    required this.comment,
    required this.tabColor,
  });

  final BuildContext context;
  final AuthRepo authRepo;
  final Comments comment;
  final Color tabColor;

  @override
  Widget build(BuildContext context) {
    UserInformation user =
        Provider.of<DataBank>(context, listen: false).userInformation;
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: Icon(
        Icons.more_vert,
        color: tabColor,
      ),
      iconSize: 25,
      color: tabColor,
      onSelected: (value) async {
        if (value == 1) {
          if (user.userId == comment.user!.userId) {
            Provider.of<ArticlesProvider>(context, listen: false).removeComment(
              comment.article!.articleId,
              user,
              comment,
            );
            Navigator.of(context).pop();
            CustomSnackBar.showSuccessSnackBar(
              context,
              message: "Comment Deleted!",
            );
          }
        } else if (value == 2) {
          // await FirebaseDatabase.instance.ref('reports/comments').push().set({
          //   "userId": user.userId,
          //   "articleId": comment.articleId,
          //   "usersName": user.fullName,
          //   "commentId": comment.commentId,
          //   "writtenComment": comment.commentWritten,
          //   "reportedTime": DateTime.now().toString(),
          // });
          CustomSnackBar.showSuccessSnackBar(
            context,
            message: "REST EASY, Comment is reported!",
          );
        }
      },
      itemBuilder: (context) => [
        if (user.userId == comment.user!.userId)
          const PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(
                  Icons.close,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Delete comment",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.flag,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Report",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
