import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants.dart';
import '../../screens/dashboard/pie_chart.dart';

import 'line_chart.dart';

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
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    const charts = <Widget>[
      PiechartPanel(),
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
                      spacing: 12,
                      activeDotColor: mainColorList[4],
                      dotColor: Colors.white.withOpacity(0.6),
                      dotHeight: 11,
                      dotWidth: 11,
                      type: WormType.thin,
                      //jumpScale: .7,
                      //verticalOffset: 15,
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
        height: 400,
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
        child: const TtestDashboard(),
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
        height: 400,
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