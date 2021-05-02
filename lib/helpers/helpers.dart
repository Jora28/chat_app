import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String loggedInKey = "ISLOGGEDIN";
  static String userCurrentIdKey = "USERCURRENTKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userNameKey = "USERNAMEKEY";

  static Future<bool> saveLogged(bool isUserLoggedIn)async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    return  pref.setBool(loggedInKey, isUserLoggedIn);
  }
  static Future<bool> saveUserCurrentId(String userID)async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    return  pref.setString(userCurrentIdKey, userID);
  }

   static Future<bool> saveUserEmail(String userName)async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    return  pref.setString(userEmailKey, userName);
  }
   static Future<bool> saveUserName(String userEmail)async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    return  pref.setString(userNameKey, userEmail);
  }

  static Future<bool> getLoggedIn()async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    return  pref.getBool(loggedInKey);
  }
  static Future<String> getUserCurrentId()async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    return  pref.getString(userCurrentIdKey);
  }
  static Future<String> getUserEmail()async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    return  pref.getString(userEmailKey);
  }

  static Future<String> getUserName()async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    return  pref.getString(userNameKey);
  }
}