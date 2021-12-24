import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../screens/categorymanagement/subcategory_expansion_tile.dart';
import '../../components/error_dialog.dart';
import '../../constants.dart';
import '../../screens/dashboard/globals.dart';
import 'category_expansion_tile.dart';

class DeleteSubcategory extends StatefulWidget {
  final String title;

  const DeleteSubcategory({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _DeleteSubcategoryState createState() => _DeleteSubcategoryState();
}

class _DeleteSubcategoryState extends State<DeleteSubcategory> {
  String categoryName = selectedCategory.capitalize;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              //margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF0AA599),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 60,
                      child: Icon(Icons.category_rounded, color: const Color(0xFF0AA599), size: 25),
                    ),
                    Text(
                      categoryName,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0AA599)),
                    ),
                    const SizedBox(width: 15,)
                  ]),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Text(
              "Available Subcategories",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: mainColorList[2]),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 355,
              margin: const EdgeInsets.only(top: 5, bottom: 3),
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                  borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
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
          ),
        ],
      ),

      /**/
    );
  }

  Widget buildTile(BuildContext context) {
    final Stream<QuerySnapshot> categories = FirebaseFirestore.instance
        .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
        .where("parentID", isEqualTo: selectedCategoryID)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
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
                List expenses = data.docs[index]["expenseIDs"];
                List incomes = data.docs[index]["incomeIDs"];
                if (data.docs[index]["parentID"] != 0 && data.docs[index]["categoryID"] != selectedSubCategoryID && expenses.isEmpty && incomes.isEmpty) {
                  String chipName = data.docs[index]["label"];
                  int chipID = data.docs[index]["categoryID"];
                  contents.add(
                      InputChip(
                        deleteIconColor: Color(0xFFFFFFFA),
                        deleteIcon: const Icon(Icons.cancel_rounded, ),
                        onDeleted: () {
                          showCustomDialog(context, chipName, chipID);
                       },
                        labelPadding: const EdgeInsets.only(left: 8, right: 5, bottom: 5, top: 5),
                        label: Text(chipName.capitalize),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFA),
                        ),
                        backgroundColor: mainColorList[2],
                  ));
                }
              }
          );

          if (contents.isEmpty){
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
                      'No Subcategories Available',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No subcategories can be deleted since they are all used by expenses or incomes",
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
            /*return const Padding(
              padding: EdgeInsets.all(10.0),
              child: *//*Text("No categories can be deleted since they are all used by expenses or incomes", style: TextStyle(color: Color(0xFFD32F2F))),*//*
            );*/
          }  else {
            //used to display the chips in the expansion tile
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: contents,
              ),
            );
          }
        });
  }

  void showCustomDialog(BuildContext context, String x, int y) {
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              const Text(
                'Delete Subategory',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to delete '$x' from your '$categoryName' subcategories?",
                textAlign: TextAlign.center,
                //style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 15.0,),
                  ElevatedButton(
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))  ,
                      primary: const Color(0xFFD32F2F),
                    ),
                    onPressed: () {
                      deleteCategory(y);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              //const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
  }
}

void deleteCategory(int idx) async {
  QuerySnapshot subcategoriesRef = await FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .where("categoryID", isEqualTo: idx).get();

  var categ = subcategoriesRef.docs[0];

  FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .doc(categ.id)
      .delete();

  QuerySnapshot categoriesRef = await FirebaseFirestore.instance
        .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
        .where("categoryID", isEqualTo: selectedCategoryID).get();

    var catDoc = categoriesRef.docs[0];
    var existingSubCats = catDoc["childIDs"];
    existingSubCats.remove(idx);

  FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .doc(catDoc.id)
      .set({"childIDs": existingSubCats}, SetOptions(merge: true));
}