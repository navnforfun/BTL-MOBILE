import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_sercutity/app.dart';

List<double> tem = [];
List<double> hum = [];
List<double> gas = [];
List<double> water = [];
String x = "hi";

Future<void> getChartData() async {
  var response =
  await http.get(Uri.parse(host + 'DashBoard/GetStateData?n=10'));
  var data = json.decode(response.body) as Map<String, dynamic>;

  tem = toDouble(data["temperature"]);
  hum = toDouble(data["humidity"]);
  gas = toDouble(data["gas"]);
  water = toDouble(data["water"]);
}

List<double> toDouble(List x) {
  List<double> myList = [];
  x.map((value) {
    myList.add(value + 0.0);
  }).toList();
  return myList;
}
