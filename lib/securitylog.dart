import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sercutity/app_resources.dart';
import 'test.dart';
import 'package:mobile_sercutity/price_point.dart';
import 'package:mobile_sercutity/api/getChartAPI.dart';
import 'package:mobile_sercutity/chartPoint.dart';
import 'dart:async';
class myChart extends StatefulWidget {
  const myChart({super.key});

  @override
  State<myChart> createState() => _myChartState();
}

class _myChartState extends State<myChart> {
  bool _loading = true;
  List<double> tem = [];
  List<double> hum = [];
  List<double> gas = [];
  List<double> water = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    updateData();
    print("-=-===-=-=----");
  }
  void updateData() {
    const oneSec = Duration(seconds: 2);
    Timer.periodic(oneSec, (Timer t) {
      getData();
    });
  }

  void getData() async {
    var chartData = await getChartData();
print(chartData);
    setState(() {
      _loading = false;
      print(_loading);
  tem =  chartData['tem']!;
  hum =  chartData['hum']!;
  gas =  chartData['gas']!;
  water =  chartData['water']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Biểu đồ"),
        ),
        body: !_loading
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Temperature",
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    LineChartWidget(tem, Colors.redAccent, 0, 70),
                    Text(
                      "Humidity",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    LineChartWidget(hum, Colors.green, 0, 120),
                    Text(
                      "Gas",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    LineChartWidget(gas, Colors.grey, 100, 700),
                    Text(
                      "Water",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    LineChartWidget(gas, Colors.blue, 100, 700),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  //Show a Circular Progress indicator
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
              ));
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> points;
  final Color color;
  final double x;
  final double y;

  LineChartWidget(this.points, this.color, this.x, this.y, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10,top: 10,right: 10,left: 0),
        child: LineChart(
          LineChartData(
            minY: x,
            maxY: y,
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                ),
              ),
              bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                  spots: data(points).map((e) {
                    return FlSpot(e[1]!, e[2]!);
                  }).toList(),
                  // spots: Map([1,3]),
                  isCurved: true,
                  color: color
                  // dotData: FlDotData(
                  //   show: false,
                  // ),

                  ),
            ],
          ),
        ),
      ),
    );
  }
}
