import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../screens/categorymanagement/subcategory_expansion_tile.dart';
import '../../constants.dart';
import 'globals.dart';

//add another class named categories

class Entries {
  Entries(this.catID, this.amount, this.label,);
  int? catID;
  String? amount;
  String? label;
  DocumentReference? reference;

  Entries.fromMap(Map<String, dynamic> map, {this.reference}) {
    catID = map["categoryID"];
    amount = map["amount"];
    label = map["label"];
  }

  @override
  String toString() => "Entry<$label : $catID : $amount\$";
}

class Categories {
  Categories(this.catID, this.subcats, this.label,);
  int? catID;
  List? subcats;
  String? label;
  DocumentReference? reference;

  Categories.fromMap(Map<String, dynamic> map, {this.reference}) {
    catID = map["categoryID"];
    subcats = map["childIDs"];
    label = map["label"];
  }

  @override
  String toString() => "Entry<$label : $catID : $subcats\$";
}

// widget responsible for fetching the data from firebase and convert them to List <Entries>
Widget _getExpenses(context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
          .where("walletID", isEqualTo: (globals.getWallet()["walletID"])).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong",
              style: TextStyle(color: Colors.white));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<Entries> expenses = snapshot.data!.docs
              .map((docSnapshot) =>
              Entries.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return Container(
            child: _getCategories(context, expenses),
          );
        }
      });
}

Widget _getCategories(context, List<Entries> expenses) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
          .where("walletID", isEqualTo: (globals.getWallet()["walletID"])).snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("error retreiving categories");
          return const Text("Something went wrong",
              style: TextStyle(color: Colors.white));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<Categories> categories = snapshot.data!.docs
              .map((docSnapshot) =>
              Categories.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();
          return Container(
            child: _buildBody(context, expenses, categories),
          );
        }
      });
}

// Widget responsible for converting List <Entries> to List <FlSpot>
Widget _buildBody(context, List<Entries> expenses, List<Categories> categories) {
  Map expensesData = {};
  Map categoriesData = {};
  List<Data> data = [];

  for (var entry in expenses.toList()) {
    if (expensesData.containsKey(entry.catID)) {
      expensesData[entry.catID] =
          expensesData[entry.catID] + double.parse(entry.amount as String);
    } else {
      expensesData[entry.catID] = double.parse(entry.amount as String);
    }
  }


  var otherID = 0;
  for (var category in categories.toList()) {
    if (category.label == "others"){
      otherID = category.catID as int;
    }
    categoriesData[category.catID] = category.label;
  }

  double total = 0;
  expensesData.forEach((k, v) {
    total += v;
  });

  var sortedExpensesKeys = expensesData.keys.toList(growable:false)
    ..sort((k1, k2) => expensesData[k2].compareTo(expensesData[k1]));
  LinkedHashMap sortedExpensesData = LinkedHashMap
      .fromIterable(sortedExpensesKeys, key: (k) => k, value: (k) => expensesData[k]);

  Map expensesDataTrimmed = {};
  Map expensesDataNoOther = {};
  int index = 0;

  var list = sortedExpensesData.keys.toList(growable:false);
  var other = list.indexOf(otherID);

  int count = 0;
  var key;
  var value;
  if (other < 9 && other > -1){
    sortedExpensesData.forEach((k, v) {
      if (count != other){
        expensesDataNoOther[k] = v;
        count ++;
      } else{
        key = k;
        value = v;
        count++;
      }
    });
    expensesDataNoOther[key] = value;
  }

  if(expensesDataNoOther.isNotEmpty) {
    expensesDataNoOther.forEach((k, v) {
      if (index < 9) {
        if (k == other){
          expensesDataTrimmed["other categories"] = v;
        } else{
          expensesDataTrimmed[k] = v;
          index++;
        }
      } else {
        if (index == 9){
          if (expensesDataTrimmed["other categories"] == null){
            expensesDataTrimmed["other categories"] = v;
            index++;
          }  else{
            expensesDataTrimmed["other categories"] = expensesDataTrimmed["other categories"] + v;
            index++;
          }
        } else{
          expensesDataTrimmed["other categories"] = expensesDataTrimmed["other categories"] + v;
          index++;
        }
      }
    });
  } else {
    sortedExpensesData.forEach((k, v){
      expensesDataTrimmed[k] = v;
    });
  }
  int i = 0;
  expensesDataTrimmed.forEach((k, v) {
    categoriesData.forEach((key, value) {
      if (k == key){
        data.add(Data(name: value, percent: double.parse(((v/total)*100).toStringAsFixed(2)), color: pieChartColors[i]));
        i++;
      }
    });
    if (expensesDataTrimmed.length > 9){
      if (expensesDataTrimmed.keys.last == k){
        data.add(Data(name: k, percent: double.parse(((v/total)*100).toStringAsFixed(2)), color: pieChartColors[i]));
      }
    }
  });

  if (data.isEmpty){
    data.add(Data(name: "no expenses available", percent: 100.00, color: pieChartColors[0]));
  }

  return Container(
      child: Stack(children: <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          const SizedBox(
            height: 37,
          ),
          const Text(
            "Expenses by Category Distribution",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 2, bottom: 20),
                child: PieChartPage(data),
              )),
          const SizedBox(
            height: 10,
          )
        ])
      ]));
}

class ExpensePieChart extends StatefulWidget {
  const ExpensePieChart({Key? key}) : super(key: key);

  @override
  ExpensePieChartState createState() => ExpensePieChartState();
}

class ExpensePieChartState extends State<ExpensePieChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: _getExpenses(context)
    );
  }
}

class Data {
  final String name;

  final double percent;

  final Color color;

  Data({required this.name, required this.percent, required this.color});

}

List<PieChartSectionData> getSections(int touchedIndex, List<Data> piechartData) {
  return piechartData.asMap().map<int, PieChartSectionData>((index, data) {
    final isTouched = index == touchedIndex;
    final opacity = isTouched  ? 1.0 : 0.9;
    final double radius = isTouched ? 70 : 60;

    final value = PieChartSectionData(
      color: data.color.withOpacity(opacity),
      value: data.percent,
      title: '${data.percent}%',
      radius: radius,
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xff044d7c),
      ),
      badgeWidget: isTouched? _Badge(text: '${data.percent}%', borderColor: data.color, size: 37, ) : null,
      badgePositionPercentageOffset: .65,
      showTitle: false,//isTouched,
      titlePositionPercentageOffset: 0.60,
      borderSide: isTouched
          ? const BorderSide(color: Color(0xff0293ee), width: 4)
          : null,
    );

    return MapEntry(index, value);
  })
      .values
      .toList();
}

class PieChartPage extends StatefulWidget {
  final List<Data> list;
  const PieChartPage(this.list, {Key? key}) : super(key: key);

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: AspectRatio(
            aspectRatio: 1,
            child: buildPieChart(widget.list),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 15.0, top: 15.0, bottom: 15.0),
          child: IndicatorsWidget(widget.list, touchedIndex),
        ),
      ],
    );
  }

  Widget buildPieChart(List<Data> piechartData) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
            setState(() {
              if (event is FlLongPressEnd || event is FlPanEndEvent) {
                touchedIndex = -1;
              } else {
                if (event.isInterestedForInteractions || response != null || response?.touchedSection != null) {
                  touchedIndex = response?.touchedSection!.touchedSectionIndex as int;
                }
              }
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 35,
        sections: getSections(touchedIndex, piechartData),
      ),
    );
  }
}

class IndicatorsWidget extends StatelessWidget {
  final List<Data> list;
  final int touchedIndex;
  const IndicatorsWidget(this.list, this.touchedIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(list.length, (index) {
          return Expanded(
            flex: 1,
            child: Container(
                child: buildIndicator(
                  touched: touchedIndex  == index,
                  color: list[index].color,
                  text: (list[index].name).capitalize,
                )),
          );
        })
    );
  }

  Widget buildIndicator({
    required Color color,
    required String text,
    required bool touched,
    bool isSquare = false,
    Color textColor = const Color(0xFFFFFFFA),
  }) {
    return Row(
      children: <Widget>[
        Container(
          width: touched? 18 : 16,
          height: touched? 18 : 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SizedBox(
                width: 95,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    text,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: touched? FontWeight.w900 : FontWeight.w100,
                      color: touched ? const Color(0xFFFEC768) : textColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double size;
  final Color borderColor;

  const _Badge({
    Key? key,
    required this.text,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size*2.05,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          color: borderColor,
          width: 4,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(
            text
        ),
      ),
    );
  }
}
