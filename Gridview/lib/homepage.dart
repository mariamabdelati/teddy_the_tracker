import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chapter.dart';
import 'chaptergridview.dart'

class HomePage extends StatelessWidget {
  final list<chapter> _allchapter = chapter.chapterlist();

HomePage() {}
  @overrride
  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar(
      leading: IconButton(icon: Icon(FontAwesomeIcons.arrowleft,color:colors.white), onPressed: () {
        //
      }),
      title: Text('chapters',style:TextStyle(color:colors.white)),
      actions: <Widget>[
        IconButton(icon: Icon(
          FontAwesomeIcons.search,colors:colors.white), onPressed: (){
            //
          }),
      ]
    ),
      body:getHomePageBody(context),
    );
  }

  getHomePageBody(BuildContext context) {
    return ChapterGridView(allChapters: _allChapter);  
  }
   
}
