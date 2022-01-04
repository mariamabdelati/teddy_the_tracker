import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants.dart';
import '../../screens/dashboard/expense_pie_chart.dart';
import 'income_pie_chart.dart';
import 'line_chart.dart';


class ChartsPageView extends StatefulWidget {
  const ChartsPageView({Key? key}) : super(key: key);

  @override
  _ChartsPageViewState createState() => _ChartsPageViewState();
}

class _ChartsPageViewState extends State<ChartsPageView> {
  String bal = '0';
  int currentPage = 0;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    const charts = <Widget>[
      ExpensesPiechartPanel(),
      IncomesPiechartPanel(),
      Linechart(),
    ];
    final pages = PageView.builder(
      onPageChanged: (int page) {
        setState(() {
          currentPage = page % charts.length;
        });
      },
      itemBuilder: (context, index){
        return charts[index % charts.length];
      },
      controller: controller,
    );
    return Stack(children: <Widget>[
      pages,
      Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 375, bottom: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedSmoothIndicator(
                    onDotClicked: animateToPage,
                    activeIndex: currentPage,
                    count: charts.length,
                    effect: WormEffect(
                      spacing: 40,
                      activeDotColor: mainColorList[4],
                      dotColor: Colors.white.withOpacity(0.6),
                      dotHeight: 13,
                      dotWidth: 13,
                      type: WormType.thin,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  void animateToPage(int index) => controller.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
}

class ExpensesPiechartPanel extends StatefulWidget {
  const ExpensesPiechartPanel({Key? key}) : super(key: key);

  @override
  _ExpensesPiechartPanelState createState() => _ExpensesPiechartPanelState();
}

class _ExpensesPiechartPanelState extends State<ExpensesPiechartPanel> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 400,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              Color(0xFF0054DA),
              Color(0xFF049BD6),
            ],
            center: Alignment(1.0, 2.0),
            focal: Alignment(1.0,1.0),
            focalRadius: 1.1,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.1, 1.1),
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.circular(40),
        ),
        child: const ExpensePieChart(),
      ),
    );
  }
}

class IncomesPiechartPanel extends StatefulWidget {
  const IncomesPiechartPanel({Key? key}) : super(key: key);

  @override
  _IncomesPiechartPanelState createState() => _IncomesPiechartPanelState();
}

class _IncomesPiechartPanelState extends State<IncomesPiechartPanel> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 400,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              Color(0xFF0054DA),
              Color(0xFF049BD6),
            ],
            center: Alignment(1.0, 2.0),
            focal: Alignment(1.0,1.0),
            focalRadius: 1.1,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.1, 1.1),
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.circular(40),
        ),
        child: const IncomePieChart(),
      ),
    );
  }
}

class Linechart extends StatefulWidget {
  const Linechart({Key? key}) : super(key: key);

  @override
  _LinechartState createState() => _LinechartState();
}

class _LinechartState extends State<Linechart> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 400,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              Color(0xFF0054DA),
              Color(0xFF049BD6),
            ],
            center: Alignment(1.0, 2.0),
            focal: Alignment(1.0,1.0),
            focalRadius: 1.1,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.1, 1.1),
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Center(
          child: TestDashboard(),
        ),
      ),
    );
  }
}
