import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import '../../data/categories.dart';
//import '../../data/expenses.dart';
//import 'package:pie_chart/pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:new_project/constants.dart';

//add another class named categories

class Entries {
  Entries(this.category, this.amount, this.label);
  int? category;
  String? amount;
  String? label;
  DocumentReference? reference;


  Entries.fromMap(Map<String, dynamic> map, {this.reference}) {
    category = map["categoryId"];
    amount = map["amount"];
    label = map["label"];

  }

  @override
  String toString() => "Entry<$category : $amount\$";
}

Widget _buildBody(context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("expenses/cFqsqHPIscrC6cY9iPs6/expense")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong", style: TextStyle(color: Colors.white));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<Entries> entries = snapshot.data!.docs
              .map((docSnapshot) =>
              Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(entries[index].toString());
              });
        }
      });
}

class TestDashboard extends StatefulWidget {
  const TestDashboard({Key? key}) : super(key: key);

  @override
  TtestDashBoardState createState() => TtestDashBoardState();
}

class TtestDashBoardState extends State<TestDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBody(context),
    );
  }
}
//dummy data
/*class PieData {
  final List<Data> data = [];


}

class Data {
  final int catID;

  final double amount;

  Data({required this.catID, required this.amount});
}*/

class PieData {
  static List<Data> data = [
    Data(name: 'Food', percent: 40, color: const Color(0xFFCCEDFF)),
    Data(name: 'Groceries', percent: 30, color: const Color(0xffbdedff)),
    Data(name: 'Shopping', percent: 15, color: const Color(0xffa8e5ff)),
    Data(name: 'Utilities', percent: 15, color: const Color(0xff9bdbff)),
  ];
}

class Data {
  final String name;

  final double percent;

  final Color color;

  Data({required this.name, required this.percent, required this.color});
}

List<PieChartSectionData> getSections(int touchedIndex) {
  return PieData.data
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
    final isTouched = index == touchedIndex;
    final double fontSize = isTouched ? 20 : 14;
    final double radius = isTouched ? 80 : 60;

    final value = PieChartSectionData(
      color: data.color,
      value: data.percent,
      title: '${data.percent}%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );

    return MapEntry(index, value);
  })
      .values
      .toList();
}

class PieChartPage extends StatefulWidget {
  PieChartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartPageState();
}

class PieChartPageState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                    setState(() {
                      if (event is FlLongPressEnd || event is FlPanEndEvent) {
                        touchedIndex = -1;
                      } else {
                        if (response != null) {
                          touchedIndex = response.touchedSection?.touchedSectionIndex as int;
                        }
                      }
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 35,
                sections: getSections(touchedIndex),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: IndicatorsWidget(),
        ),
      ],
    );
  }
}


class IndicatorsWidget extends StatelessWidget {
  const IndicatorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PieData.data.map(
            (data) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: buildIndicator(
                color: data.color,
                text: data.name,
                // isSquare: true,
              ));
        },
      ).toList(),
    );
  }

  Widget buildIndicator({
    required Color color,
    required String text,
    bool isSquare = false,
    double size = 16,
    Color textColor = const Color(0xFFFFFFFA),
  }) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
