import 'dart:convert';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveUser(User objUser) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = jsonEncode(objUser);
    prefs.setString('user', strUser);
    print("Lưu thành công: $strUser");
    return true;
  } catch (e) {
    print("Lưu thất bại");
    print(e);
    return false;
  }
}

Future<bool> deleteUser() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    print("User data deleted successfully.");
    return true;
  } catch (e) {
    print("Failed to delete user data.");
    print(e);
    return false;
  }
}

Future<User> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String strUser = pref.getString('user')!;
  return User.fromJson(jsonDecode(strUser));
}
