import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'category_expansion_tile.dart';
import 'category_more_options.dart';

int selectedSubCategoryID = -1;
//changing the category labels to uppercase
extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';

  String get capitalize => split(" ").map((str) => str.inCaps).join(" ");
}

class SubcategoryExpansionTile extends StatefulWidget {
  final List index;
  final bool visible;


  const SubcategoryExpansionTile({Key? key, required this.index, required this.visible}) : super(key: key);

  @override
  _SubcategoryExpansionTileState createState() => _SubcategoryExpansionTileState();
}


class _SubcategoryExpansionTileState extends State<SubcategoryExpansionTile> {
  //this string is used to identify what subcategory has been selected
  late String selectedSubcategory;

  static const double radius = 20;

  late bool _isExpanded;

  UniqueKey keyTile = UniqueKey();

  void expandTile() {
    setState(() {
      _isExpanded = true;
      keyTile = UniqueKey();
    });
  }

  void resetTile() {
    setState(() {
      _isExpanded = false;
      selectedSubcategory = "";
      selectedSubCategoryID = -1;
    });
  }

  void shrinkTile() {
    Future.delayed(const Duration(milliseconds: 300), (){
      setState(() {
        _isExpanded = false;
        keyTile = UniqueKey();
      });
    });
  }

  @override
  void initState(){
    selectedSubcategory = "";
    selectedSubCategoryID = -1;
    _isExpanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(radius)),
          color: mainColorList[1],
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withAlpha(100), blurRadius: 5.0),
          ]),
      child: Visibility(visible: widget.visible,
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
    );
  }

  Widget buildTile(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: keyTile,
        initiallyExpanded: _isExpanded,
        leading:
        selectedSubcategory != "" ? Material(
            shadowColor: Colors.blue.withAlpha(100),
            animationDuration: const Duration(milliseconds: 500),
            color: iconsColor.withOpacity(0.8),
            //elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.account_tree_rounded, color: mainColorList[1]),
            )) : Icon(Icons.account_tree_rounded, color: iconsColor),
        collapsedTextColor: iconsColor,
        title: Text(
          "Subcategories",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: iconsColor),
        ),
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
                  .where("parentID", isEqualTo: selectedCategoryID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong", style: TextStyle(color: Color(0xFFD32F2F)),);
                } else
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final data = snapshot.requireData;
                var contents = <Widget>[];
                List.generate(
                    data.size,
                        (index) {
                      if (data.docs[index]["parentID"] != 0) {
                        String chipName = data.docs[index]["label"];
                        int chipID = data.docs[index]["categoryID"];
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
                                selectedSubcategory) == 0)
                                ? const Color(0xFFF6BAB5)
                                : const Color(0xFF67B5FD),
                            onPressed: () {
                              if (selectedSubcategory != chipName) {
                                setState(() {
                                  selectedSubcategory = chipName;
                                  selectedSubCategoryID = chipID;
                                });
                              } else {
                                setState(() {
                                  selectedSubcategory = "";
                                  selectedSubCategoryID = -1;
                                });
                              }
                            }
                        ));
                      }
                    }
                );

                return Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: contents,
                );
              }),

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
                context: context,
                builder: (BuildContext context) {
                  return const Options("Subcategory");
                },
              );
            },
          )
        ],
      ),
    );
  }
}
