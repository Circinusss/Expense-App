import 'package:expenses/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'transaction.dart';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key).toString());
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  key() async {
    final prefs = await SharedPreferences.getInstance();
    //print(prefs.getKeys());
    Set a = prefs.getKeys();
    print(a);
    MyHomePage q = MyHomePage();
    if (a.isNotEmpty) {
      for (int i = 0; i < a.length; i++) {
        List x = json.decode(prefs.getString(a.elementAt(i)).toString());
        Transaction(
            id: x[0].toString(),
            title: x[1].toString(),
            amount: double.parse(x[2].toString()),
            date: DateTime.parse(x[3].toString()));
      }
    }
  }
}
