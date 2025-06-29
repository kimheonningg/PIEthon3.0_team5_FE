import 'package:flutter/material.dart';

class MainviewTabProvider with ChangeNotifier {
  final List<String> _tabs = ['Overview', 'Medical History', 'Imaging', 'Treatment Plans', 'Clinical Notes'];
  String _currentTabName = 'Overview'; //mainview의 tab index
  String _referenceType = '';
  String _referenceId = '';
  String get currentTabName => _currentTabName;
  String get referenceType => _referenceType;
  String get referenceId => _referenceId;
  List<String> get tabs => _tabs;

  void changeTab(String tabName) {
    _currentTabName = tabName;
    notifyListeners();
  }

  void showReference(String reference_type, String reference_id) {
    _referenceType = reference_type;
    _referenceId = reference_id;

    switch (referenceType.toLowerCase()) {
      case 'notes':
        _currentTabName = 'Clinical Notes';
        break;
      case 'appointments':
      case 'treatments':
      case 'medicalhistories':
        _currentTabName = 'Treatment Plans';
        break;
      case 'labresults':
        _currentTabName = 'Medical History';
        break;
      case 'imaging':
        _currentTabName = 'Imaging';
        break;
      default:
        _currentTabName = 'Overview';
    }

    notifyListeners();
  }
}
