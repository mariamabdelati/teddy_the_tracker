import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../screens/categorymanagement/subcategory_expansion_tile.dart';
import '../../constants.dart';
import '../../screens/dashboard/globals.dart';

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
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 5, bottom: 3),
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: mainColorList[1],
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.withAlpha(100), blurRadius: 5.0),
              ]),
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
                if (data.docs[index]["parentID"] == 0 && data.docs[index]["label"] != "others") {
                  String chipName = data.docs[index]["label"];
                  int chipID = data.docs[index]["categoryID"];
                  contents.add(
                      InputChip(
                        deleteIconColor: Color(0xFFFFFFFA),
                        deleteIcon: Icon(Icons.cancel_rounded, ),
                        onDeleted: () {setState(() {print("bla");}); },

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
        });
  }
}
