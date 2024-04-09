import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'securitylog.dart' as a;
import 'package:mobile_sercutity/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String temperatureData = '';
  String waterData = '';
  String gasData = '';
  String humidityData = '';
  String status = 'An Toàn';

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
    LocalNotificationService.initialize();
  }

  Future<void> fetchDataFromAPI() async {
    final response = await http.get(Uri.parse(host+'DashBoard/laststatedata'));
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        temperatureData = data.containsKey('temperature') ? data['temperature'].toString() : '';
        waterData = data.containsKey('water') ? data['water'].toString() : '';
        gasData = data.containsKey('gas') ? data['gas'].toString() : '';
        humidityData = data.containsKey('humidity') ? data['humidity'].toString() : '';

        //
        // if (temperatureData.isNotEmpty || waterData.isNotEmpty || gasData.isNotEmpty || humidityData.isNotEmpty) {
        //   status = 'Warning';
        // } else {
        //   status = 'An Toàn';
        // }
        status =data["state"];
      });
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tình trạng toà nhà'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF64B5F6),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => a.myChart()),
                  );
                },
                child: Container(
                  width: 320,
                  height: 150,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      ' $status',
                      style: TextStyle(fontSize: 24, color: Colors.blue),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGridItem(context, '🔥', temperatureData),
                  SizedBox(width: 20),
                  _buildGridItem(context, '💦', waterData),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGridItem(context, '💥', gasData),
                  SizedBox(width: 20),
                  _buildGridItem(context, '🌳', humidityData),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, String data) {
    return Container(
      width: 150,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 30, color: Colors.blue),
          ),
          SizedBox(height: 5),
          Text(
            data.isNotEmpty ? data : 'N/A',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}