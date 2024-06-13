import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:mobile_sercutity/app.dart';
Future<bool> loginAPI(String name, String pass) async{
  var url = '${host}account/loginapi?name=${name}&&pass=${pass}';
  var response = await http.get(Uri.parse(url));
  var data = json.decode(response.body);
  return data;
}