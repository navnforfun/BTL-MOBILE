import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sercutity/app_resources.dart';
import 'test.dart';
import 'package:mobile_sercutity/price_point.dart';
import 'package:mobile_sercutity/api/getChartAPI.dart';
import 'package:mobile_sercutity/chartPoint.dart';

class myChart extends StatefulWidget {
  const myChart({super.key});

  @override
  State<myChart> createState() => _myChartState();
}

class _myChartState extends State<myChart> {
   bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    print("1");
    await getChartData();
    print("2");
    setState(() {
      _loading = false;
      print(_loading);

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
                    LineChartWidget(tem, Colors.redAccent),
                    Text(
                      "Humidity",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    LineChartWidget(hum, Colors.green),
                    Text(
                      "Gas",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    LineChartWidget(gas, Colors.grey),
                    Text(
                      "Water",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    LineChartWidget(gas, Colors.blue),
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

  LineChartWidget(this.points, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: LineChart(
          LineChartData(
            minY: points[0] - 20,
            maxY: points[9] + 5,
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
                    print(e);
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
