import 'package:flutter/material.dart';

enum _SelectedTab { home, submit, account, info }

class BottomNavIndexProvider with ChangeNotifier {
  _SelectedTab _selectedTab = _SelectedTab.home;

  int get selectedTab {
    return _selectedTab.index;
  }

  void changeSelectedTab(int pageIndex) {
    _selectedTab = _SelectedTab.values[pageIndex];
    notifyListeners();
  }
}
