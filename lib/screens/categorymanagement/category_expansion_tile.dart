import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'subcategory_expansion_tile.dart';
import 'category_more_options.dart';
import 'create_new_category.dart';
import '../../screens/dashboard/globals.dart';


//global variable used to save category id to wallet
var selectedCategoryID = 0;
//this string is used to identify what category has been selected
var selectedCategory = "";

class CategoryExpansionTile extends StatefulWidget {
  //this boolean is used for verification and is  sent from the expenses form to validate the category selection
  final bool chosen; //CHANGED
  const CategoryExpansionTile(this.chosen, {Key? key}) : super(key: key);

  @override
  _CategoryExpansionTileState createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  //this boolean is used for displaying the sucategories if a category is selected
  var isSelected = false;

  var selectedCategorySubs = [];

  static const double radius = 20;

  //boolean used for expansion tile  to indicate whether it is expanded
  bool isExpanded = false;

  UniqueKey keyTile = UniqueKey();

  @override
  void initState(){
    selectedCategory = "";
    selectedCategoryID = 0;
    isExpanded = false;
    super.initState();
  }
  //expanding tile function
  void expandTile() {
    setState(() {
      isExpanded = true;
      keyTile = UniqueKey();
    });
  }

  //shrinks the tile with a delay so that user can see what tey have selected; this function is triggered upon category selection
  void shrinkTile() {
    Future.delayed(const Duration(milliseconds: 300), (){
      setState(() {
        isExpanded = false;
        keyTile = UniqueKey();
      });
    });
  }

  //builds the expansion tile container, builds the tiles and calls the validation function and subcategories based on category selection
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 3),
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
              border:  widget.chosen ? null: Border.all(
                color: const Color(0xFFD32F2F),
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(radius)),
              color: mainColorList[1],
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.withAlpha(100), blurRadius: 5.0),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  buildTile(context),
                ],
              ),
            ),
          ),
        ),
        validateCat(!widget.chosen),
        if (isSelected)
          const SizedBox(
            height: 16,
          ),
        //the selectedCategoryID is passed to the subcategory so that we can show the related subcategory
        SubcategoryExpansionTile(
          index: selectedCategorySubs, visible: isSelected, key: ValueKey(selectedCategoryID),),
      ],
    );
  }



  Widget buildTile(BuildContext context) {
    //stream of categories from db
    final Stream<QuerySnapshot> categories = FirebaseFirestore.instance
        .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
        .where("walletID", isEqualTo: (globals.getWallet()["walletID"]))
        .snapshots();

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: keyTile,
        initiallyExpanded: isExpanded,
        leading:
        selectedCategory != "" ? Material(
            shadowColor: Colors.blue.withAlpha(100),
            animationDuration: const Duration(milliseconds: 500),
            color: iconsColor.withOpacity(0.8),
            //elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.category_rounded, color: mainColorList[1]),
            )) : SizedBox(width: 32, child: Icon(Icons.category_rounded, color: iconsColor)),
        collapsedTextColor: iconsColor,
        title: Text(
          "Categories",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: iconsColor),
        ),
        children: [
          //stream builder uses category stream and for each appends an action chip to a list
          StreamBuilder<QuerySnapshot>(
              stream: categories,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong", style: TextStyle(color: Color(0xFFD32F2F)));
                } else
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final data = snapshot.requireData;
                //size = data.size;
                var contents = <Widget>[];
                List.generate(
                    data.size,
                        (index) {
                      if (data.docs[index]["parentID"] == 0) {
                        String chipName = data.docs[index]["label"];
                        int chipID = data.docs[index]["categoryID"];
                        List chipSubCat = data.docs[index]["childIDs"];
                        contents.add(ActionChip(
                            labelPadding: const EdgeInsets.all(5),
                            label: Text(chipName.capitalize),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFA),
                            ),
                            avatar: CircleAvatar(radius: 16,
                              child: Text(chipName[0].toUpperCase(), style: TextStyle(color: iconsColor),),
                              backgroundColor: Colors.white.withOpacity(0.8),
                            ),
                            backgroundColor: (chipName.compareTo(
                                selectedCategory) == 0)
                                ? const Color(0xFFF6BAB5)
                                : const Color(0xFF67B5FD),
                            onPressed: () {
                              //this sets the state for selection
                              if (selectedCategory != chipName) {
                                setState(() {
                                  selectedCategory = chipName;
                                  selectedCategoryID = chipID;
                                  selectedCategorySubs = chipSubCat;
                                  //reset = true;
                                  isSelected = true;
                                });
                                shrinkTile();
                              } else {
                                setState(() {
                                  selectedCategory = "";
                                  selectedCategoryID = 0;
                                  selectedCategorySubs = [];
                                  isSelected = false;
                                });
                              }
                            }
                        ));
                      }
                    }
                );

                //used to display the chips in the expansion tile
                return Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: contents,
                );
              }),

          //text button toggles a bottom sheet that gives the user options to  add category or delete
          TextButton.icon(
            label: const Text(
                "options", style: TextStyle(color: Color(0xFF67B5FD))),
            icon: Icon(Icons.more_horiz, color: mainColorList[3]),
            onPressed: () {
              showModalBottomSheet(
                barrierColor: Colors.black.withAlpha(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
                elevation: 20.0,
                //backgroundColor: mainColorList[1],
                context: context,
                builder: (BuildContext context) {
                  return const Options("Category");
                },
              );
            },
          )
        ],
      ),
    );
  }

  //validation function displays to show an error with no category selection when submitting form
  validateCat(bool x) {
    return Visibility(
        visible: x,
        child: const Padding(
          padding: EdgeInsets.only(top: 8, left: 12),
          child: Align(alignment: Alignment.centerLeft, child: Text("Please select a category for your entry", style: TextStyle(fontSize: 12,  color: Color(0xFFD32F2F)),)),)
    );
  }
}


//on save then
//set catID in expenses table to selectedCategoryID
