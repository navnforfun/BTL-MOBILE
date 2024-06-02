import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_sercutity/api/getChartAPI.dart';
import 'securitylog.dart' as a;
import 'package:mobile_sercutity/app.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'cameraScreen.dart' as cameraScreen;
// import 'package:just_audio/.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double temperatureData = 0;
  double waterData = 0;
  double gasData = 0;
  double humidityData = 0;
  double thresholdT = 50;
  double thresholdW = 500;
  double thresholdG = 500;
  double thresholdH = 90;
  String status = 'An Toàn';
  Color color1 = Colors.blue[300]!;
  Color color2 = Colors.blue[700]!;

  final player = AudioPlayer(); // Create a player
  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
    updateData();
    print("run");
    getLogCamera(5);
  }

  void updateData() {
    const oneSec = Duration(seconds: 2);
    Timer.periodic(oneSec, (Timer t) {
      fetchDataFromAPI();
    });
  }

  Future<void> fetchDataFromAPI() async {
    final response =
        await http.get(Uri.parse(host + 'DashBoard/laststatedata'));
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        temperatureData = data['temperature'] + 0.0;
        waterData = data['water'] + 0.0;
        gasData = data['gas'] + 0.0;
        humidityData = data['humidity'] + 0.0;

        //
        // if (temperatureData.isNotEmpty || waterData.isNotEmpty || gasData.isNotEmpty || humidityData.isNotEmpty) {
        //   status = 'Warning';
        // } else {
        //   status = 'An Toàn';
        // }
        // status = data["state"];
        status = "Stable";
        if (thresholdT < temperatureData) {
          status = "Fire";
        } else if (thresholdW < waterData) {
          status = "Water";
        } else if (thresholdG < gasData) {
          status = "Gas";
        } else if (thresholdH < humidityData) {
          status = "Humidity";
        }
        if (status != "Humidity" && status != "Stable") {
          playSampleSound();
          color1 = Colors.red[400]!;
          color2 = Colors.red[700]!;
        } else {
          color1 = Colors.blue[300]!;
          color2 = Colors.blue[700]!;
        }
      });
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }

  void playSampleSound() async {
    AudioPlayer player = AudioPlayer();
    // await player.setAsset('https://file-examples.com/storage/fe0e2ce82f660c1579f31b4/2017/11/file_example_MP3_700KB.mp3');
    await player.setAsset("assets/alarm.mp3");
    player.play();
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
              color1,
              color2,
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
                  GestureDetector(
                      child: _buildGridItem(
                          context, '🔥', temperatureData.toString()),
                      onTap: () async {
                        const String initialValue = '';
                        String? s = await prompt(
                          context,
                          title: const Text('Chỉnh ngưỡng cảnh báo fire'),
                          textOK: const Text('OK'),
                          textCancel: const Text('Cancel'),
                          hintText: 'Nhập giá trị',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },

                          textAlign: TextAlign.center,
                          // controller: TextEditingController(text: initialValue),
                        );
                        print(s.toString());
                        // double value = double.parse(.toString());
                        setState(() {
                          thresholdT = double.parse(s.toString());
                        });
                      }),
                  SizedBox(width: 20),
                  GestureDetector(
                      child:
                          _buildGridItem(context, '💦', waterData.toString()),
                      onTap: () async {
                        const String initialValue = '';
                        String? s = await prompt(
                          context,
                          title: const Text('Chỉnh ngưỡng cảnh báo water'),
                          textOK: const Text('OK'),
                          textCancel: const Text('Cancel'),
                          hintText: 'Nhập giá trị',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },

                          textAlign: TextAlign.center,
                          // controller: TextEditingController(text: initialValue),
                        );
                        print(s.toString());
                        // double value = double.parse(.toString());
                        setState(() {
                          thresholdW = double.parse(s.toString());
                        });
                      })
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      const String initialValue = '';
                      String? s = await prompt(
                        context,
                        title: const Text('Chỉnh ngưỡng cảnh báo gas'),
                        textOK: const Text('OK'),
                        textCancel: const Text('Cancel'),
                        hintText: 'Nhập giá trị',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },

                        textAlign: TextAlign.center,
                        // controller: TextEditingController(text: initialValue),
                      );
                      print(s.toString());
                      // double value = double.parse(.toString());
                      setState(() {
                        thresholdG = double.parse(s.toString());
                      });
                    },
                    child: _buildGridItem(context, '💥', gasData.toString()),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    child:
                        _buildGridItem(context, '🌳', humidityData.toString()),
                    onTap: () async {
                      const String initialValue = '';
                      String? s = await prompt(
                        context,
                        title: const Text('Chỉnh ngưỡng cảnh báo humidity'),
                        textOK: const Text('OK'),
                        textCancel: const Text('Cancel'),
                        hintText: 'Nhập giá trị',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },

                        textAlign: TextAlign.center,
                        // controller: TextEditingController(text: initialValue),
                      );
                      print(s.toString());
                      // double value = double.parse(.toString());
                      setState(() {
                        thresholdH = double.parse(s.toString());
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => cameraScreen.CameraScreen(cameraIp: videoUrl,)),
                      );
                    },
                    child: Container(
                      width: 320,
                      height: 50,
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
                      child: Center(
                        child: Text(
                            'Camera security'
                        ),
                      ),
                    ),
                  )
                ],
              )
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
