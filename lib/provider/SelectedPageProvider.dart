import 'package:flutter/cupertino.dart';

class SelectedPageProvider extends ChangeNotifier{
  int currentIndex = 0;

  get getIndex{
    return currentIndex;
  }

  set setIndex(int index){
    currentIndex = index;
    notifyListeners();
  }
}