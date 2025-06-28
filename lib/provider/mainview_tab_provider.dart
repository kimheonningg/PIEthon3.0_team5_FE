import 'package:flutter/material.dart';

class MainviewTabProvider with ChangeNotifier {
  final List<String> _tabs = ['Overview', 'Medical History', 'Imaging', 'Treatment Plans', 'Clinical Notes'];
  String _currentTabName = 'Overview'; //mainview의 tab index
  String get currentTabName => _currentTabName;
  List<String> get tabs => _tabs;

  void changeTab(String tabName) {
    if (_currentTabName != tabName) {
      _currentTabName = tabName;
      notifyListeners();
    }
  }
}
