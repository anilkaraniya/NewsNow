import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:news_now/src/data_bank.dart';
import 'package:news_now/src/screens/authentication/application/auth_provider.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
import 'package:news_now/src/uitils/server/appwrite.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';

class AuthRepo {
  Future<void> signIn(String email, String password, BuildContext ctx) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      if (session.current) {
        await account.get();
      }
      await getUserInformation(ctx);
      Provider.of<AuthProvider>(ctx, listen: false)
          .changeLoginStatus(true, true);
    } on AppwriteException catch (e) {
      throw AppwriteException(e.message, e.code, e.type, e.response);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await account.deleteSessions();
    } on AppwriteException catch (_) {
      rethrow;
    }
    if (kDebugMode) {
      print("Looged Out!!!");
    }
    Provider.of<DataBank>(context, listen: false).resetDefaultAccountData();
  }

  Future<UserInformation> getUserInformation(BuildContext ctx) async {
    final user = await account.get();
    var userInformation = UserInformation(
      userId: user.$id,
      userName: user.prefs.data['username'],
      fullName: user.name,
      emailId: user.email,
      profilePicture: user.prefs.data['profilePicture'],
      joined: DateTime.parse(
        user.$createdAt,
      ),
    );

    try {
      final documentsResponse = await database.getDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: APPWRITE_COLLECTION_ID_user,
        documentId: user.$id,
      );

      UserInformation fetchedUserData =
          UserInformation.fromMap(documentsResponse.data);
      Provider.of<DataBank>(ctx, listen: false)
          .addUserInformation(fetchedUserData);
    } on AppwriteException catch (e) {
      throw AppwriteException(e.message, e.code, e.type, e.response);
    }

    return userInformation;
  }

  Future<void> signUp(
      String email, String password, String name, BuildContext ctx) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      await database.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: APPWRITE_COLLECTION_ID_user,
        documentId: user.$id,
        data: {
          'userName': name.replaceAll(" ", "").toLowerCase(),
          'fullName': name,
          'emailId': email,
          'profilePicture': null,
        },
      );

      await signIn(email, password, ctx);

      await account.updatePrefs(
        prefs: {
          'username': name.replaceAll(" ", "").toLowerCase(),
          'profilePicture': null,
        },
      );
    } on AppwriteException catch (e) {
      throw AppwriteException(e.message, e.code, e.type, e.response);
    }
  }
}
