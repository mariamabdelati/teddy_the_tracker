import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../screens/categorymanagement/category_expansion_tile.dart';
import '../../screens/categorymanagement/subcategory_expansion_tile.dart';
import '../../components/error_dialog.dart';
import '../../constants.dart';
import 'create_new_category.dart';
import 'create_new_subcategory.dart';
import 'delete_category.dart';
import 'delete_subcategory.dart';
import '../../screens/dashboard/globals.dart';

class Options extends StatefulWidget {
  final String title;

  const Options(this.title, {
    Key? key,
  }) : super(key: key);
  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  //checks if a category exists or not
  late List<DocumentSnapshot> catdocuments;
  late List<DocumentSnapshot> subcatdocuments;
  @override
  void initState() {
    super.initState();

    _getCategories();
    _getSubCategories();
  }

  void _getCategories() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
        .where("walletID", isEqualTo: (globals.getWallet()["walletID"]))
        .get();

    List<DocumentSnapshot> docs = [];
    for (var doc in result.docs){
      List expenses =  doc["expenseIDs"];
      List incomes = doc["incomeIDs"];
      if (doc["parentID"] == 0 && doc["categoryID"] != selectedCategoryID && doc["label"] != "others" && expenses.isEmpty && incomes.isEmpty){
        docs.add(doc);
      }
    }
    catdocuments = docs;
  }

  bool noCategoryCheck() {
    if (catdocuments.isEmpty){
      return true;
    } else{
      return false;
    }
  }

  void _getSubCategories() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
        .where("parentID", isEqualTo: selectedCategoryID)
        .get();


    List<DocumentSnapshot> docs = [];
    for (var doc in result.docs){
      List expenses =  doc["expenseIDs"];
      List incomes = doc["incomeIDs"];
      if (doc["parentID"] != 0 && doc["categoryID"] != selectedSubCategoryID && expenses.isEmpty && incomes.isEmpty){
        docs.add(doc);
      }
    }
    subcatdocuments = docs;
  }

  bool noSubCategoryCheck() {
    if (subcatdocuments.isEmpty){
      return true;
    } else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.blue.withAlpha(100), blurRadius: 10.0)], borderRadius: const BorderRadius.all(Radius.circular(20.0)), color: mainColorList[1],),
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
                height: 40),
            Text(
              widget.title + " Options",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: mainColorList[2]),
            ),
            const SizedBox(
                height: 30),
            ElevatedButton.icon(
              icon: Icon(
                Icons.add,
                color: mainColorList[4],
                size: 24.0,
              ),
              label: Text("Create " + widget.title),
              onPressed: () {
                if (widget.title == "Category"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewCategory(title: 'Create New Category',)));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewSubcategory(title: 'Create New Subcategory',)));
                }
              },
              style: ElevatedButton.styleFrom(primary: mainColorList[2], padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            const SizedBox(height: 25,),
            ElevatedButton.icon(
              icon: Icon(
                Icons.delete_rounded,
                color: mainColorList[4],
                size: 24.0,
              ),
              label: Text("Delete " + widget.title),
              onPressed: (){
                if (widget.title == "Category"){
                  if (noCategoryCheck()){
                    buildErrorDialog(context, "categories");
                  } else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteCategory(title: 'Delete Category',)));
                  }
                } else {
                  if (noSubCategoryCheck()){
                    buildErrorDialog(context, "subcategories");
                  } else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteSubcategory(title: 'Delete Subcategory',)));                  }
                }
              },
              style: ElevatedButton.styleFrom(primary: mainColorList[2], padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            const SizedBox(height: 45,),
            ElevatedButton.icon(
              icon: Icon(
                Icons.close_rounded,
                color: mainColorList[4],
                size: 24.0,
              ),
              label: const Text("Close"),
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(primary: mainColorList[2], padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void buildErrorDialog(BuildContext context, String message) {
  showDialog(context: context, builder: (BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedError(),
            const SizedBox(height: 12),
            const Text(
              "Function Unavailable",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              "This function is unavailable since there are no $message to delete or they are all in use by your entries",
              textAlign: TextAlign.center,
              //style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  });
}