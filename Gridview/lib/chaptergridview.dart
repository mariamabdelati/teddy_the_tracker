import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chapter.dart';
import 'menuitem.dart';

class ChapterGridView extends StatelessWidget {
  final list<Chapter> allChapters;

  ChapterGridView ({Key key, this.allChapters}) : super(key: key);

  @override
  Widget build(BuildContext context)  {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 0.9,
      children: _getGridViewItems(context),
    )
  }

  _getGridViewItems(BuildContext context) {
    List<Widget> chapterWidgets = new list<Widget>();
    for (int i = 0; i < allChapters.length; i++) {
      var widget = _getGridItemUI(context, allChapters[i]);
      chapterWidgets.add(Widget);
    };
    return chapterWidgets;
  }

  //Create individual item
  _getGridItemUI(BuildContext context, Chapter item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [new Color(item.color1), new Color(item.color2)],
              begin: Alignment(-1.0, -1.0)  
          ), //gradient colors
        ),
      ),
      //popup menu for favouriting 
    );
  }
}
