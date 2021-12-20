import 'dart.ui';

// all the content for the gridview itself should be in here m8

class Chapter {
  String chapterName;
  String chapterQuestions;
  int color1, color2;

  Chapter({this.chapterName, this.chapterQuestions, this.color1, this.color2});

  static list<Chapter> chapterlist() {
    var listofChapter = new list<Chapter>();

    listofChapter.add(new Chapter(chapterName: 'Category 1', chapterQuestions: 'subcategory deez', color1: 0xffdb1c76, color2: 0xffbe318a));
    listofChapter.add(new Chapter(chapterName: 'Category 2', chapterQuestions: 'subcategory nuts', color1: 0xffe55149, color2: 0xfff47143));
    return listofChapter;
  }
}
