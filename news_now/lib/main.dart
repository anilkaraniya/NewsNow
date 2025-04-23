import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/data_bank.dart';
import 'package:news_now/src/package_service/locator_service.dart';
import 'package:news_now/src/screens/authentication/application/auth_provider.dart';
import 'package:news_now/src/screens/authentication/presentation/signin_screen.dart';
import 'package:news_now/src/screens/authentication/presentation/signup_screen.dart';
import 'package:news_now/src/screens/edit_profile/presentation/edit_profile_screen.dart';
import 'package:news_now/src/screens/feed/application/articles_provider.dart';
import 'package:news_now/src/screens/feed/presentation/article_discription_screen.dart';
import 'package:news_now/src/screens/profile/presentation/profile_screen.dart';
import 'package:news_now/src/screens/feed/presentation/feed_screen.dart';
import 'package:news_now/src/screens/info/presentation/info_screen.dart';
import 'package:news_now/src/screens/submit/presentation/submit_screen.dart';
import 'package:news_now/src/view/application/bottom_nav_index_provider.dart';
import 'package:news_now/src/view/presentation/root_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const NewsNow());
}

class NewsNow extends StatelessWidget {
  const NewsNow({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => BottomNavIndexProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ArticlesProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => DataBank(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => AuthProvider(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return const MaterialAppCustom();
          },
        ));
  }
}

class MaterialAppCustom extends StatefulWidget {
  const MaterialAppCustom({
    super.key,
  });

  @override
  State<MaterialAppCustom> createState() => _MaterialAppCustomState();
}

class _MaterialAppCustomState extends State<MaterialAppCustom> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NJ Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          primary: AppColors.primaryColor,
          seedColor: Colors.cyan,
          // ignore: deprecated_member_use
          background: Colors.black,
        ),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        '/': (ctx) => const HomePage(),
        FeedScreen.routeName: (ctx) => const FeedScreen(),
        SubmitScreen.routeName: (ctx) => const SubmitScreen(),
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
        EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
        InfoScreen.routeName: (ctx) => const InfoScreen(),
        SignInScreen.routeName: (ctx) => SignInScreen(),
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        ArticleDiscriptionScreen.routeName: (ctx) => ArticleDiscriptionScreen(),
      },
    );
  }
}
