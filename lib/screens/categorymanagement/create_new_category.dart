import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../screens/dashboard/globals.dart';
import '../../components/submission_button.dart';
import '../../components/success_dialog.dart';
import '../../constants.dart';

class CreateNewCategory extends StatefulWidget {
  final String title;

  const CreateNewCategory({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _CreateNewCategoryState createState() => _CreateNewCategoryState();
}

class _CreateNewCategoryState extends State<CreateNewCategory> {
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
  String newCategory = "";
  //string to save new budget entered into
  String budget = "";

  final _categorytext = TextEditingController();
  final _budgettext = TextEditingController();
  final _categoryfocus = FocusNode();
  final _budgetfocus = FocusNode();


  //checks if a category exists or not
  var documents;

  @override
  void initState() {
    super.initState();

    _getCategories();
  }

  void _getCategories() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
        .where("walletID", isEqualTo: (globals.getWallet()["walletID"]))
        .get();

    List<DocumentSnapshot> docs = result.docs;
    documents = docs;
  }

  bool categoryCheck(String newCat) {
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  "Category Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: mainColorList[2]),
                ),
              ),
              const SizedBox(height: 16),
              buildCategory(),
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

  //builds new category textformfield
  Widget buildCategory() {
    return TextFormField(
      controller: _categorytext,
      focusNode: _categoryfocus,
      decoration: InputDecoration(
        prefixIcon: SizedBox(width: 60,child: Icon(Icons.category_rounded, size: 20, color: iconsColor)),
        labelText: "New Category",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: SizedBox(
          width: 60,
          child: IconButton(
            icon: const Icon(Icons.clear_rounded, size: 20),
            onPressed: _categorytext.clear,
          ),
        ),
      ),

      //validates field  value
      validator: (value) {
        if (value!.toLowerCase().trim().isEmpty) {
          return "Category cannot be empty";
        } else if (!categoryCheck(value.toLowerCase().trim())){
          return "Category already exists";
        } else {
          return null;
        }
      },
      //triggered on submission
      onSaved: (value) => setState(() => newCategory = value!.trim()),
    );
  }

  Widget buildBudget() {
    return TextFormField(
      controller: _budgettext,
      focusNode: _budgetfocus,
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
          //print(globals.getWallet());
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

              //adds new  document to db
              createNewCategory(newCategory.toLowerCase().trim(), budget);

              //message showing verification
              final message =
                  "'$newCategory' has been successfully added to your categories";

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
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            ),
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            }
          },
        );
      },
    );
  }
}

void createNewCategory(String label, String budget) async {
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
    "parentID": 0,
    "categoryID": newID,
    "childIDs": [],
    "expenseIDs": [],
    "incomeIDs": [],
    "walletID": globals.getWallet()["walletID"],
  });

  var existingCatsList = globals.getWallet()["categoriesIDs"];
  existingCatsList.add(newID);

  QuerySnapshot walletsRef = await FirebaseFirestore.instance
      .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
      .where("walletID", isEqualTo: globals.getWallet()["walletID"]).get();

  var walet = walletsRef.docs[0];

  FirebaseFirestore.instance
      .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
      .doc(walet.id)
      .set({"categoriesIDs": existingCatsList}, SetOptions(merge: true));
}
