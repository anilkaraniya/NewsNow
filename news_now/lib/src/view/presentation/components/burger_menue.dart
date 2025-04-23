// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:news_now/src/common_widgets/custom_snackbar.dart';
import 'package:news_now/src/data_bank.dart';
import 'package:news_now/src/package_service/locator_service.dart';
import 'package:news_now/src/screens/authentication/application/auth_provider.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/repository/auth_repo.dart';
import 'package:news_now/src/screens/edit_profile/presentation/edit_profile_screen.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
import 'package:news_now/src/screens/authentication/presentation/signin_screen.dart';
import 'package:news_now/src/screens/profile/presentation/profile_screen.dart';
import 'package:news_now/src/view/application/bottom_nav_index_provider.dart';

class BurgerMennueDrawer extends StatelessWidget {
  const BurgerMennueDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    UserInformation? userInformation =
        Provider.of<DataBank>(context).getUserInformation;
    AuthRepo _authRepo = locator.get<AuthRepo>();
    double tabsFontSize = 20;
    double spaceBetweenTabs = 12;
    Color tabColor = AppColors.textPrimaryColor;

    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 18.0,
            bottom: 20,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  userInformation.userId != "default"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                userInformation.profilePicture == null ||
                                        userInformation.profilePicture!.isEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: const Image(
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                          image: AssetImage(
                                            "assets/images/profilePlaceholder.jpeg",
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                          image: NetworkImage(
                                            userInformation.profilePicture!,
                                          ),
                                        ),
                                      ),
                                customePopupMenue(
                                  context,
                                  userInformation,
                                  _authRepo,
                                  tabColor,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              userInformation.fullName.toString(),
                              style: const TextStyle(
                                color: AppColors.textPrimaryColor,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "@${userInformation.userName}",
                              style: const TextStyle(
                                color: AppColors.textPrimaryColor,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                SignInScreen.routeName,
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                AppColors.secondaryColor,
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                              ),
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                            ),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Provider.of<BottomNavIndexProvider>(context,
                              listen: false)
                          .changeSelectedTab(0);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "My feed",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                  InkWell(
                    onTap: () {
                      if (userInformation.userId != 'default') {
                        Navigator.of(context).pop();
                        Provider.of<BottomNavIndexProvider>(context,
                                listen: false)
                            .changeSelectedTab(1);
                      } else {
                        Navigator.of(context).pop();
                        CustomSnackBar.showErrorSnackBar(
                          context,
                          message: "Please Login or Signup!",
                          milliseconds: 2000,
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.link,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Submit article",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                  InkWell(
                    onTap: () async {
                      var url =
                          'https://docs.google.com/forms/d/e/1FAIpQLSeI8UT0DJe8hzc45BzT07lM_dPYu7vQzw_itWC-MOnv8vnQ-Q/viewform?usp=dialog';

                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        throw 'There was a problem to open the url: $url';
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.stop_circle_sharp,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Feedback",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Provider.of<BottomNavIndexProvider>(context,
                              listen: false)
                          .changeSelectedTab(3);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.question_mark,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "About Us",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<int> customePopupMenue(
    BuildContext context,
    UserInformation userInformation,
    AuthRepo _authRepo,
    tabColor,
  ) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: Icon(
        Icons.settings,
        color: tabColor,
      ),
      iconSize: 25,
      color: AppColors.accentColor,
      onSelected: (value) {
        if (value == 0) {
          Navigator.of(context).pop();
          Provider.of<BottomNavIndexProvider>(context, listen: false)
              .changeSelectedTab(2);
        } else if (value == 1) {
          Navigator.of(context).pushNamed(
            EditProfileScreen.routeName,
            arguments: userInformation,
          );
        } else if (value == 2) {
          _authRepo.logout(context);
          Provider.of<AuthProvider>(context, listen: false)
              .changeLoginStatus(false, true);
          Provider.of<DataBank>(context, listen: false)
              .resetDefaultAccountData();
          Navigator.of(context).pop();
          Provider.of<BottomNavIndexProvider>(context, listen: false)
              .changeSelectedTab(0);
          CustomSnackBar.showSuccessSnackBar(
            context,
            message: "Logged out successfully!",
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.person,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.settings,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Account Details",
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
                Icons.logout,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Logout",
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
