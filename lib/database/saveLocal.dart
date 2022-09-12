import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SaveLocalDataBase {
  String? mydir;
  dynamic saveData(String key, dynamic model, var data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Encode and store data in SharedPreferences
    // if (key != 'ALL') {
    String encodedData = json.encode(data);
    // }else{
    //   encodedData = jsonEncode([data]);
    // }

    await prefs.setString(key, encodedData);
  }

  dynamic saveListData(String key, dynamic model, dynamic data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Encode and store data in SharedPreferences
    // if (key != 'ALL') {

    List<String> encodedData = data.forEach((mail) => {jsonEncode(mail)});
    // }else{
    //   encodedData = jsonEncode([data]);
    // }

    await prefs.setStringList(key, encodedData);
  }

  dynamic removeData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  dynamic retrieve(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? mydata = prefs.getString(key);
    var data = json.decode(mydata.toString());
    return data;
  }
}
