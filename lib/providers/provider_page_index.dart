import 'package:flutter/foundation.dart';

class PageIndex extends ChangeNotifier {
  static int _index = 0;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }
}
