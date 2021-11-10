import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teddy_categories/data/categories.dart';
//import 'package:teddy_categories/data/category_tiles.dart';
import 'package:teddy_categories/constants.dart';
import 'category_more_options.dart';

//Icons.account_tree_rounded
//changing the category labels to uppercase
extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';

  String get capitalize => split(" ").map((str) => str.inCaps).join(" ");
}

class CategoryExpansionTile extends StatefulWidget {
  const CategoryExpansionTile({Key? key}) : super(key: key);

  @override
  _CategoryExpansionTileState createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  //this string is used to identify what category has been selected
  var selectedCategory = "";
  var selectedCategoryID = 0;

  //this strong will be used to take user input for the new category
  var newCategoryTitle = "";

  //this variable is initialized with -1 to indicate no main category has been selected
  var index = -1;

  static const double radius = 20;

  bool isExpanded = false;

  UniqueKey keyTile = UniqueKey();


  /*void expandTile() {
    setState(() {
      isExpanded = true;
      keyTile = UniqueKey();
    });
  }

  void shrinkTile() {
    setState(() {
      isExpanded = false;
      keyTile = UniqueKey();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0.0,
        title: const Text("Categories Section"),
        titleTextStyle:
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(radius)),
              color: mainColorList[1],
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.withAlpha(100), blurRadius: 10.0),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  buildTile(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  Widget buildTile(BuildContext context) {
    var contents = <Widget>[];
    entryCategories.map((item) {
      if (item.parentID == -1) {
        contents.add(buildChips(item.label, item.categoryID));
      }
    }).toList();
    //contents.add(
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: keyTile,
        initiallyExpanded: isExpanded,
        leading:
            selectedCategory != "" ? Material(shadowColor: Colors.blue.withAlpha(100), animationDuration: const Duration(milliseconds: 500),
                color: iconsColor.withOpacity(0.8), elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.category_rounded, color: mainColorList[1]),
                ) ) : Icon(Icons.category_rounded, color: iconsColor),
        collapsedTextColor: iconsColor,
        //childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
        title: Text(
          "Categories",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: iconsColor),
        ),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: contents),
        TextButton.icon(
          label: const Text("more", style: TextStyle(color: Color(0xFF67B5FD))),
          icon: Icon(Icons.more_horiz, color: mainColorList[3]),
          onPressed: () {
            showModalBottomSheet(barrierColor: Colors.black.withAlpha(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              elevation: 20.0,
              //backgroundColor: mainColorList[1],
              context: context,
              builder: (BuildContext context) {
                return const Options();
              },
            );
          },
        )],
      ),
    );
  }

  //takes a string and turns it into an action chip, the action chip changes colour when pressed and displays container
  Widget buildChips(String chipName, int chipNumber) {
    return ActionChip(
        labelPadding: const EdgeInsets.all(6),
        label: Text(chipName.capitalize),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFA),
        ),
        avatar: CircleAvatar(radius: 16,
          child: Text(chipName[0].toUpperCase()),
          backgroundColor: Colors.white.withOpacity(0.8),
        ),
        backgroundColor: (chipName.compareTo(selectedCategory) == 0)
            ? const Color(0xFFF6BAB5)
            : const Color(0xFF67B5FD),
        onPressed: () {
          selectedCategory = "";
          selectedCategoryID = 0;
          // the for loop iterates over the categories list and sees if the the chip name is the same as the label for the category
          //if the condition is met the selected category is made to equal chipname to  indicate selection (colour change)
          for (var i = 0; i < entryCategories.length; i++) {
            if (chipName == entryCategories[i].label) {
              setState(() {
                index = i;
                selectedCategory = chipName;
                selectedCategoryID = chipNumber;
              });
            }
          }
        });
  }
}



/*
  Card(shadowColor: Colors.black.withAlpha(100),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
    side: BorderSide(color: Color(0xFF67B5FD), width: 2),
  )
 */
/*CircleAvatar(radius: 17,
  child: Icon(categoryTiles[0].icon, color: mainColorList[1]),
  backgroundColor: iconsColor.withOpacity(0.8),
)*/