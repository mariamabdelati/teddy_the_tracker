import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'subcategory_expansion_tile.dart';
import '../../components/error_dialog.dart';
import '../../constants.dart';
import '../../screens/dashboard/globals.dart';
import 'category_expansion_tile.dart';

class DeleteCategory extends StatefulWidget {
  final String title;

  const DeleteCategory({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _DeleteCategoryState createState() => _DeleteCategoryState();
}

class _DeleteCategoryState extends State<DeleteCategory> {

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

      //form for new category
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Text(
              "Available Categories",
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
        .where("walletID", isEqualTo: globals.getWallet()["walletID"])
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
                List expenses =  data.docs[index]["expenseIDs"];
                if (data.docs[index]["parentID"] == 0 && data.docs[index]["categoryID"] != selectedCategoryID && data.docs[index]["label"] != "others" && expenses.isEmpty) {
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
                      'No Categories Available',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No categories can be deleted since they are all used by expenses or incomes",
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
                  'Delete Category',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  "Are you sure you want to delete '$x' from your categories?",
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
  QuerySnapshot categoriesRef = await FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .where("categoryID", isEqualTo: idx).get();

  var categ = categoriesRef.docs[0];

  FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .doc(categ.id)
      .delete();

  var existingCatsList = globals.getWallet()["categoriesIDs"];
  existingCatsList.remove(idx);

  QuerySnapshot walletsRef = await FirebaseFirestore.instance
      .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
      .where("walletID", isEqualTo: globals.getWallet()["walletID"]).get();

  var walet = walletsRef.docs[0];

  FirebaseFirestore.instance
      .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
      .doc(walet.id)
      .set({"categoriesIDs": existingCatsList}, SetOptions(merge: true));
}