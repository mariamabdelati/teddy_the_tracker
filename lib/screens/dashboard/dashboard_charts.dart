import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class LineGraph extends StatefulWidget {
  const LineGraph({Key? key}) : super(key: key);

  @override
  _LineGraphState createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  late List<EntriesData> _chartdata;
  @override
  Widget build(BuildContext context) {
    _chartdata = getChartData();
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          series: <ChartSeries>[
            LineSeries<EntriesData, double>(
                dataSource: _chartdata,
                xValueMapper: (EntriesData entry, _) => entry.date,
                yValueMapper: (EntriesData entry, _) => entry.amount)
          ],
          primaryXAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
        ),
      ),
    );
  }

  List<EntriesData> getChartData() {
    final List<EntriesData> chartData = [
      EntriesData(2017, 465),
      EntriesData(2020, 500),
      EntriesData(2021, 600),
      EntriesData(2022, 200),
    ];

    Query data = FirebaseFirestore.instance
        .collection("expenses/cFqsqHPIscrC6cY9iPs6/expense")
        .orderBy("date", descending: true);
    return chartData;
  }
}

class EntriesData {
  EntriesData(this.date, this.amount);
  final double date;
  final double amount;
}
