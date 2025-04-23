import 'package:flutter/material.dart';
import 'package:news_now/src/common_widgets/custom_snackbar.dart';
import 'package:news_now/src/data_bank.dart';
import 'package:news_now/src/screens/authentication/presentation/signin_screen.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
import 'package:news_now/src/view/presentation/components/burger_menue.dart';
import 'package:provider/provider.dart';
import 'package:news_now/src/screens/profile/presentation/profile_screen.dart';
import 'package:news_now/src/screens/feed/presentation/feed_screen.dart';
import 'package:news_now/src/screens/info/presentation/info_screen.dart';
import 'package:news_now/src/screens/submit/presentation/submit_screen.dart';
import 'package:news_now/src/view/application/bottom_nav_index_provider.dart';
import 'package:news_now/src/view/presentation/components/botton_nav_bar.dart';
import 'package:news_now/src/view/presentation/components/crystal_navigation_bar_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _handleIndexChanged(int i) {
    UserInformation userInformation =
        Provider.of<DataBank>(listen: false, context).userInformation;
    setState(() {
      if (userInformation.userId != 'default') {
        Provider.of<BottomNavIndexProvider>(context, listen: false)
            .changeSelectedTab(i);
      } else {
        if (i == 1) {
          CustomSnackBar.showErrorSnackBar(
            context,
            message: "Please Login or Signup!",
            milliseconds: 2000,
          );
        } else if (i == 2) {
          Navigator.of(context).pushNamed(SignInScreen.routeName);
        } else {
          Provider.of<BottomNavIndexProvider>(context, listen: false)
              .changeSelectedTab(i);
        }
      }
    });
  }

  List screenList = [
    {"title": "NewsNow", "screen": FeedScreen()},
    {"title": "Submit", "screen": SubmitScreen()},
    {"title": "Account", "screen": ProfileScreen()},
    {"title": "About Us", "screen": InfoScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: const BurgerMennueDrawer(),
      appBar: AppBar(
        title: Text(
          screenList[Provider.of<BottomNavIndexProvider>(context).selectedTab]
              ["title"],
        ),
        elevation: 0,
      ),
      body: screenList[Provider.of<BottomNavIndexProvider>(context).selectedTab]
          ["screen"],
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: Provider.of<BottomNavIndexProvider>(context).selectedTab,
        height: 10,
        unselectedItemColor: Colors.black87,
        backgroundColor: Colors.black.withOpacity(0.1),
        onTap: _handleIndexChanged,
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            unselectedIcon: Icons.home_outlined,
            selectedColor: Colors.black,
          ),
          CrystalNavigationBarItem(
            icon: Icons.post_add_rounded,
            unselectedIcon: Icons.post_add_outlined,
            selectedColor: Colors.black,
          ),
          CrystalNavigationBarItem(
            icon: Icons.account_circle_sharp,
            unselectedIcon: Icons.account_circle_outlined,
            selectedColor: Colors.black,
          ),
          CrystalNavigationBarItem(
            icon: Icons.info,
            unselectedIcon: Icons.info_outline,
            selectedColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
