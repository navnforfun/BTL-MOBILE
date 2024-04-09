import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile_sercutity/price_point.dart';
class myChart extends StatefulWidget {
  const myChart({super.key});

  @override
  State<myChart> createState() => _myChartState();
}

class _myChartState extends State<myChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bieu do"),),
      body: Column(
        children: [
          Text("Temperature"),
          LineChartWidget(pricePoints),
          SizedBox(
            height: 50,
          ),
          Text("Humidity"),

          LineChartWidget(pricePoints),
          // Text("Water"),
          //
          // LineChartWidget(pricePoints),
          // Text("Gas"),
          //
          // LineChartWidget(pricePoints),

        ],
      ),
    );
  }
}


class LineChartWidget extends StatelessWidget {
  final List<PricePoint> points;

  LineChartWidget(this.points, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x , point.y )).toList(),
              // spots: Map([1,3]),
              isCurved: true,
              // dotData: FlDotData(
              //   show: false,
              // ),

            ),
          ],

        ),
      ),
    );
  }
}