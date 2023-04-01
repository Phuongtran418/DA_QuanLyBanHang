import 'dart:convert';
import 'package:opc_app_main/call_api.dart';
import 'package:flutter/services.dart';

class ConnectJsonObject {
  static Future<List<dynamic>> readJsonData() async {
    var jsonText = await rootBundle.loadString('data/dmvt1.json');
    var data = json.decode(jsonText);
    return data;
  }

  static Future<List<Products>> getAllContacts() async {
    List<Products> lsResult = [];
    List<dynamic> data = await readJsonData();
    lsResult = List<Products>.from(data.map((e) => Products.fromJson(e)));
    return lsResult;
  }
}