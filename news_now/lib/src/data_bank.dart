import 'package:flutter/foundation.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';

// import 'package:news_now/src/features/maintainers/domain/maintainers.dart';
// import 'package:news_now/src/features/analytics/domain/analytics.dart';
// import 'package:news_now/src/features/maintainers/domain/project_users.dart';
// import 'package:news_now/src/features/profile/domain/server_stats_class.dart';
// import 'package:news_now/src/features/recovery/domain/borrower.dart';
// import 'package:news_now/src/features/recovery/domain/borrower_list.dart';

class DataBank with ChangeNotifier {
  UserInformation userInformation = UserInformation(
    userId: "default",
    emailId: "default@gmail.com",
    userName: "Login",
    fullName: "Go ahead and Signin or Signup",
    joined: DateTime(2022),
    profilePicture:
        "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png",
  );

  UserInformation get getUserInformation {
    return userInformation;
  }

  void addUserInformation(UserInformation userData) {
    userInformation = userData;
    notifyListeners();
  }

  void resetDefaultAccountData() {
    userInformation = UserInformation(
      userId: "default",
      emailId: "default@gmail.com",
      userName: "Login",
      fullName: "Go ahead and Signin or Signup",
      joined: DateTime(2022),
      profilePicture:
          "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png",
    );
    notifyListeners();
  }
}
//   models.User? _userData;
//   ProjectUsers? _projectUser;
//   Analytics? _analytics;
//   List<Borrower>? _borrowers;
//   final List<BorrowerList> _borrowersList = [];
//   Maintainers? _maintainers;
//   ServerStatsClass? _serverStats;

//   models.User? get userData {
//     return _userData;
//   }

  // ProjectUsers? get projectUser {
  //   return _projectUser;
  // }

//   Analytics? get analytics {
//     return _analytics;
//   }

//   List<Borrower>? get borrowers {
//     return _borrowers;
//   }

//   List<BorrowerList>? get borrowersListG {
//     return _borrowersList;
//   }

//   Maintainers? get maintainers {
//     return _maintainers;
//   }

//   ServerStatsClass? get serverStats {
//     return _serverStats;
//   }

  // void addUserData(models.User userData) {
  //   _userData = userData;
  // }

//   void addProjectUserData(models.User? userData,
//       {ProjectUsers? projectUser, bool notifylisteners = false}) {
//     if (projectUser == null) {
//       _projectUser = ProjectUsers.fromUser(userData!);
//     } else {
//       _projectUser = projectUser;
//     }
//     if (notifylisteners) {
//       notifyListeners();
//     }
//   }

//   void addAnalytics(Analytics analytics, {bool notifylisteners = false}) {
//     _analytics = analytics;
//     if (notifylisteners) {
//       notifyListeners();
//     }
//   }

//   void addBorrower(List<Borrower> borrowers) {
//     _borrowers = borrowers;
//   }

//   void addBorrowerList(
//     List<BorrowerList> borrowersListR, {
//     bool clearList = false,
//   }) {
//     if (clearList) {
//       _borrowersList.clear();
//     }
//     _borrowersList.addAll(borrowersListR);
//     notifyListeners();
//   }

//   void updateBorrower(
//       BorrowerList? previousBorrowerData, BorrowerList borrowerData,
//       {String? borrowerid}) {
//     int? index;
//     if (borrowerid == null) {
//       index = _borrowersList.indexWhere(
//         (borrower) => borrower.borrowerid == previousBorrowerData!.borrowerid,
//       );
//     } else {
//       index = _borrowersList.indexWhere(
//         (borrower) => borrower.borrowerid == borrowerid,
//       );
//     }
//     _borrowersList[index] = borrowerData;
//     if (kDebugMode) {
//       print("Updated");
//     }
//     notifyListeners();
//   }

//   void removeBorrower(String? borrowerid) {
//     int? index;
//     index = _borrowersList.indexWhere(
//       (borrower) => borrower.borrowerid == borrowerid,
//     );
//     _borrowersList.removeAt(index);
//     notifyListeners();
//   }

//   BorrowerList getBorrowerList(String borrowerId) {
//     return _borrowersList
//         .firstWhere((borrwerList) => borrwerList.borrowerid == borrowerId);
//   }

//   void addMaintainers(Maintainers maintainers) {
//     _maintainers = maintainers;
//   }

//   void addServerStats(ServerStatsClass serverStats) {
//     _serverStats = serverStats;
//     notifyListeners();
//   }
// }
