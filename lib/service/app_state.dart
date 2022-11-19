import 'package:flutter/material.dart';
import 'package:wordle/service/shared_preferences_manager.dart';

class AppState with ChangeNotifier{
  String languageCode = 'en';
  bool isDarkMode = true;

  AppState(){
    initAppState();
  }
  Future<void> initAppState() async {
    var checkDarkMode = await sharedPrefs.getBool('isDarkMode');
    var checkLanguageCode = await sharedPrefs.getString('langCode');
    if(checkDarkMode!=null){
      isDarkMode = checkDarkMode;
    }
    if(checkLanguageCode!=null){
      languageCode = checkLanguageCode;
    }
    notifyListeners();
  }

  Future<void> changeTheme(bool isDarkMode) async {
    this.isDarkMode = isDarkMode;
    await sharedPrefs.setBool('isDarkMode', isDarkMode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    this.languageCode = languageCode;
    await sharedPrefs.setString('langCode', languageCode);
    notifyListeners();
  }

}