import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPiechart extends StatelessWidget {
  const MyPiechart({
    Key? key,
    required this.present,
    required this.absent,
    required this.late,
    required this.total,
  }) : super(key: key);

  final int present;
  final int absent;
  final int late;
  final int total;
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: Color.fromARGB(255, 35, 237, 48),
            value: present.toDouble(),
            title: '${(present.toDouble() / total * 100).toStringAsFixed(2)}%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Color.fromARGB(255, 216, 20, 20),
            value: absent.toDouble(),
            title: '${(absent.toDouble() / total * 100).toStringAsFixed(2)}%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Color.fromARGB(255, 211, 217, 26),
            value: late.toDouble(),
            title: '${(late.toDouble() / total * 100).toStringAsFixed(2)}%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
