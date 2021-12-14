import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import '../../screens/dashboard/pie_chart.dart';

//import 'line_chart.dart';

class ChartsPageView extends StatefulWidget {
  const ChartsPageView({Key? key}) : super(key: key);

  @override
  _ChartsPageViewState createState() => _ChartsPageViewState();
}

class _ChartsPageViewState extends State<ChartsPageView> {
  //int touchedIndex = -1;
  String bal = '0';
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final charts = PageView(
      onPageChanged: (int page) {
        setState(() {
          currentPage = page;
        });
      },
      controller: PageController(initialPage: 0),
      children: <Widget>[
        PiechartPanel(),
        Linechart(),
      ],
    );
    return Stack(children: <Widget>[
      charts,
      Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 300, bottom: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < 2; i++)
                    (i == currentPage ? circleBar(true) : circleBar(false))
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 11 : 8,
      width: isActive ? 11 : 8,
      decoration: BoxDecoration(
          color: isActive ? mainColorList[4] : Colors.white.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}

class PiechartPanel extends StatefulWidget {
  const PiechartPanel({Key? key}) : super(key: key);

  @override
  _PiechartPanelState createState() => _PiechartPanelState();
}

class _PiechartPanelState extends State<PiechartPanel> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 400,
        height: 330,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              //Color(0xFF1D67A6),
              //Color(0xFF3493E3),
              //Color(0xFF61ADEB)
              Color(0xFF0054DA),
              Color(0xFF049BD6),
              //Color(0xFF1E49C1),
              //Color(0xFF67B5FD),
            ],
            center: Alignment(1.0, 2.0),
            focal: Alignment(1.0,0.6),
            focalRadius: 1.1,
          ),
          //border: Border.all(color: Colors.grey),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.1, 1.1),
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.circular(40),
        ),
        child: PieChartPage(),
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
        width: 400,
        height: 330,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              Color(0xFF0054DA),
              Color(0xFF049BD6),
              //Color(0xFF1D67A6),
              //Color(0xFF3493E3),
              //Color(0xFF0054DA),
              //Color(0xFF3298D6),
            ],
            center: Alignment(1.0, 2.0),
            focal: Alignment(1.0,0.6),
            focalRadius: 1.1,
            /*center: Alignment(0.3, 1.8),
            focal: Alignment(-1.0, 0.6),
            focalRadius: 1.4,*/
          ),
          //border: Border.all(color: Colors.grey),
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
          child: TestDashboard(),/*Text('PageView 2',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),*/
        ),
      ),
    );
  }
}