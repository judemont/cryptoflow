import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SparklineChart extends StatelessWidget {
  final List<double> data;
  const SparklineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 70,
        child: LineChart(LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: false,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              color: Colors.blueAccent,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
            ),
          ],
        )));
  }
}
