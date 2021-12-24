import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/success_dialog.dart';
import '../../screens/dashboard/globals.dart';
import '../../components/submission_button.dart';
import '../../constants.dart';
import 'category_expansion_tile.dart';
import 'subcategory_expansion_tile.dart';
//import 'category_expansion_tile.dart';

class CreateNewSubcategory extends StatefulWidget {
  final String title;

  const CreateNewSubcategory({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _CreateNewSubcategoryState createState() => _CreateNewSubcategoryState();
}

class _CreateNewSubcategoryState extends State<CreateNewSubcategory> {
  //this function is used to remove the extra zeros from the beginning of the budget entered
  String zeroCheck(String x){
    String y = "";
    for (int i = 0; i < x.length; i++){
      if(x[i] == "0"){
        continue;
      } else{
        y = x.substring(i);
        break;
      }
    }
    if (y == "" || y == "." || y == ".0" || y == ".00")
    {
      y = "0";
    }
    return y;
  }

  final formKey = GlobalKey<FormState>();
  //string to save new  category entered into
  String newSubcategory = "";
  //string to save new budget entered into
  String budget = "";

  final _subcategorytext = TextEditingController();
  final _budgettext = TextEditingController();

  //checks if a category exists or not
  var documents;

  @override
  void initState() {
    super.initState();
    _getSubCategories();
  }

  String categoryName = selectedCategory.capitalize;
  void _getSubCategories() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
        .where("parentID", isEqualTo: selectedCategoryID).get();

    List<DocumentSnapshot> docs = result.docs;
    documents = docs;
  }

  //used to determine if a subcategory exists or not
  bool subcategoryCheck(String newCat) {
    for (var document in documents) {
      if (document["label"] == newCat) return false;
    }
    return true;
  }

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
        body: Form(
          key: formKey,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
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
                          child: Icon(Icons.category_rounded, color: Color(0xFF0AA599), size: 25),
                        ),
                        Text(
                          categoryName,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0AA599)),
                        ),
                        const SizedBox(width: 15,)
                      ]),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  "Subcategory Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: mainColorList[2]),
                ),
              ),
              const SizedBox(height: 16),
              buildSubcategory(),
              const SizedBox(height: 16),
              buildBudget(),
              const SizedBox(height: 32),
              const Divider(
                color: Color(0xFF67B5FD),
                thickness: 0.5,
              ),
              const SizedBox(height: 32),
              buildSubmit(),
            ],
          ),
        )
    );
  }

  //builds new subcategory textformfield
  Widget buildSubcategory() {
    return TextFormField(
      controller: _subcategorytext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        prefixIcon: SizedBox(width: 60,child: Icon(Icons.account_tree_rounded, size: 20, color: iconsColor)),
        labelText: "New Subcategory",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: SizedBox(
          width: 60,
          child: IconButton(
            icon: const Icon(Icons.clear_rounded, size: 20),
            onPressed: _subcategorytext.clear,
          ),
        ),
      ),

      //validates field  value
      validator: (value) {
        if (value!.toLowerCase().trim().isEmpty) {
          return "Subcategory cannot be empty";
        } else if (!subcategoryCheck(value.toLowerCase().trim())){
          return "Subcategory already exists for category '$categoryName'";
        } else {
          return null;
        }
      },
      //triggered on submission
      onSaved: (value) => setState(() => newSubcategory = value!.trim()),
    );
  }

  Widget buildBudget() {
    return TextFormField(
      controller: _budgettext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        prefixIcon: SizedBox(width: 60,child: Icon(Icons.attach_money_rounded, size: 20, color: iconsColor)),
        labelText: "Budget",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: SizedBox(
          width: 60,
          child: IconButton(
            icon: const Icon(Icons.clear_rounded,
              size: 20,
            ),
            onPressed: _budgettext.clear,
          ),
        ),
      ),

      //validates field  value
      validator: (value) {
        if (value! == ""){
          return null;
        } else if(zeroCheck(value) == "0") {
          return "Budget must not be zero";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,

      //accepts only up to two decimals
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"))
      ],
      //triggered on submission
      onSaved: (value) => setState(() => budget = value!.isEmpty ? "-1" : zeroCheck(value)),
    );
  }


  Widget buildSubmit() {
    return Builder(
      builder: (context) {
        return SubmitButtonWidget(
          onClicked: () {

            final isValid = formKey.currentState!.validate();
            FocusScope.of(context).unfocus();

            if (isValid) {
              formKey.currentState!.save();

              createNewSubCategory(newSubcategory.toLowerCase().trim(), budget);

              //message showing verification
              final message =
                  "'$newSubcategory' has been successfully added to '$categoryName' subcategories";

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
                        AnimatedCheck(),
                        SizedBox(height: 12),
                        const Text(
                          'Success!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          //style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            ),
                            child: Text('Ok'),
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
              //Navigator.pop(context, MaterialPageRoute(builder: (context) => const CategoryExpansionTile()));
            }
          },
        );
      },
    );
  }
}

void createNewSubCategory(String label, String budget) async {
  QuerySnapshot categories = await FirebaseFirestore.instance
      .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
      .orderBy("categoryID")
      .get();

  var categoriesList = categories.docs;
  var maxId = 0;
  for (var doc in categoriesList) {
    maxId = max(maxId, doc["categoryID"]);
  }
  var newID = maxId + 1;
  var createdCategory = FirebaseFirestore.instance
      .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
      .doc();
  createdCategory.set({
    "label": label.toLowerCase().trim(),
    "budget": int.parse(budget),
    "parentID": selectedCategoryID,
    "categoryID": newID,
    "childIDs": [],
    "expenseIDs": [],
    "incomeIDs": [],
    "walletID": globals.getWallet()["walletID"],
  });

  QuerySnapshot categoriesRef = await FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .where("categoryID", isEqualTo: selectedCategoryID).get();

  var catDoc = categoriesRef.docs[0];
  var existingSubCats = catDoc["childIDs"];
  existingSubCats.add(newID);

  FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .doc(catDoc.id)
      .set({"childIDs": existingSubCats}, SetOptions(merge: true));
}