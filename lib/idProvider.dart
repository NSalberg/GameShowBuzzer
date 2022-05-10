import 'package:flutter/material.dart';

class ID extends ChangeNotifier {
  var _Id = "";
  String get getID {
    return _Id;
  }


  void setID(String Id) {
    _Id = Id;
    notifyListeners();
  }
}