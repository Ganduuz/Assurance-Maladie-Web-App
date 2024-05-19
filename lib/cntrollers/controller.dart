import 'package:flutter/material.dart';
class Controller extends ChangeNotifier{
  final GlobalKey<ScaffoldState> _scaffoldkey=GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldkey=> _scaffoldkey;
  void controlMenu(){
    if(!_scaffoldkey.currentState!.isDrawerOpen){
      _scaffoldkey.currentState!.openDrawer();
    }
  }
}
