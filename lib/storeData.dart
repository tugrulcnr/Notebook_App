// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

enum KeyNames { topics ,mesaj}

class StoreDate {
  SharedPreferences? prefs;
  StoreDate() {
    init();
  }
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveData(KeyNames key, List<String> value) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key.name, value);
  }

  Future<List<String>?> getStoreData(KeyNames key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(key.name)?.toList();
  }


 
}
