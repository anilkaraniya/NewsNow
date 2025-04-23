import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_now/custome_icons_icons.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/data_bank.dart';
import 'package:news_now/src/screens/edit_profile/presentation/edit_profile_screen.dart';
import 'package:news_now/src/screens/feed/data/article.dart';
import 'package:news_now/src/screens/feed/data/comment.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Comments> fetchedcomments = [];
  List<NewsArticle> fetchedPublishedArticles = [];
  bool isStateChanged = false;
  bool fetchingPublihsedArticles = true;

  @override
  void dispose() {
    fetchedPublishedArticles.clear();
    super.dispose();
  }

  void changeState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserInformation? userInformation =
        Provider.of<DataBank>(context).userInformation;

    bool socialCheck = userInformation.instagram != null ||
        userInformation.githubUsername != null ||
        userInformation.linkedin != null ||
        userInformation.twitter != null ||
        userInformation.facebook != null ||
        userInformation.websiteURL != null;

    var socialWrap = SizedBox(
      width: 300,
      child: Wrap(
        runSpacing: 5,
        children: [
          const SizedBox(
            height: 15,
          ),
          if (userInformation.githubUsername != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://github.com/${userInformation.githubUsername!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.github_circled_alt2,
                color: AppColors.textSecondaryColor,
                size: 30,
              ),
            ),
          if (userInformation.linkedin != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://www.linkedin.com/${userInformation.linkedin!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.linkedin_1,
                color: AppColors.textSecondaryColor,
                size: 30,
              ),
            ),
          if (userInformation.twitter != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://twitter.com/${userInformation.twitter!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.twitter,
                color: AppColors.textSecondaryColor,
                size: 30,
              ),
            ),
          if (userInformation.instagram != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://www.instagram.com/${userInformation.instagram!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.instagram,
                color: AppColors.textSecondaryColor,
                size: 30,
              ),
            ),
          if (userInformation.facebook != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://www.facebook.com/${userInformation.facebook!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.facebook,
                color: AppColors.textSecondaryColor,
                size: 30,
              ),
            ),
          if (userInformation.websiteURL != null)
            InkWell(
              onTap: () async {
                var url = 'https://${userInformation.websiteURL}';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              child: Row(children: [
                const Icon(
                  CustomeIcons.link,
                  color: AppColors.textSecondaryColor,
                  size: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    userInformation.websiteURL!,
                    style: const TextStyle(
                      color: AppColors.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );

    var biocontainer = Container(
      padding: const EdgeInsets.only(
        right: 70,
        bottom: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (userInformation.biography != null)
            Text(
              userInformation.biography!,
              style: const TextStyle(
                color: AppColors.textSecondaryColor,
                fontSize: 15,
              ),
            ),
        ],
      ),
    );

    var accountDetailsButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditProfileScreen.routeName,
          arguments: userInformation,
        );
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        ),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        )),
      ),
      child: const Text(
        "Account Details",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 25,
            left: 25,
            right: 25,
            bottom: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: "personalProfile",
                child: userInformation.userId == "default" ||
                        userInformation.profilePicture == null
                    ? const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage("assets/images/profilePlaceholder.jpeg"),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                          image: NetworkImage(
                            userInformation.profilePicture!,
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                userInformation.fullName.toString(),
                style: const TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "@${userInformation.userName}",
                style: const TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontSize: 15,
                ),
              ),
              if (userInformation.biography != null) biocontainer,
              const SizedBox(
                height: 9,
              ),
              Text(
                "Joined ${DateFormat.yMMMM().format(userInformation.joined as DateTime)}",
                style: const TextStyle(
                  fontFamily: "Roboto",
                  color: AppColors.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (socialCheck) socialWrap,
              const SizedBox(
                height: 20,
              ),
              accountDetailsButton,
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleComments extends StatelessWidget {
  const ArticleComments({
    super.key,
    required this.comment,
  });

  final Comments comment;

  @override
  Widget build(BuildContext context) {
    final cleanComentWritten =
        ProfanityFilter().censor(comment.commentWritten!);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[900],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    Text(
                      comment.upVotes == "null"
                          ? comment.upVotes.toString()
                          : "0",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.64,
                    child: Text(
                      cleanComentWritten,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontSize: 16.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat("yMMMd").format(
                      comment.timeOfComment!,
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey[200],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
