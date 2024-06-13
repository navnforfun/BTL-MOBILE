import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_sercutity/app.dart';
import 'package:intl/intl.dart';


String x = "hi";

Future<Map<String,List<double>>> getChartData() async {
  var response =
  await http.get(Uri.parse(host + 'DashBoard/GetStateData?n=10'));
  var data = json.decode(response.body) as Map<String, dynamic>;


  Map<String,List<double>> result = {
    'tem' : toDouble(data["temperature"]),
    'hum' : toDouble(data["humidity"]),
    'gas' : toDouble(data["gas"]),
    'water' : toDouble(data["water"]),
  };
  return result;
}

List<double> toDouble(List x) {
  List<double> myList = [];
  x.map((value) {
    myList.add(value + 0.0);
  }).toList();
  return myList.reversed.toList();
}
Future<List<String>> getLogCamera(int n) async{
  var response = await http.get(Uri.parse(host + 'home/ListStateCamera?n=${n}'));
  var data = json.decode(response.body);
  List<String> times = [];
  for(int i =0 ; i< data.length; i++){

// Parse the datetime string
    DateTime dateTime = DateTime.parse(data[i]['time'] );
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(dateTime);
    times.add(formattedDate);
  }
  return  times;
}