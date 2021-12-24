import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../screens/dashboard/globals.dart';
import '../../components/submission_button.dart';
import '../../constants.dart';
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

  //used to determine if a category exists or not
  late bool _invalid;

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
        .where("walletID", isEqualTo: globals.getWallet()["walletID"])
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
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 16),
              Text(
                "Please input the new subcategory data:", textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: iconsColor),
              ),
              const SizedBox(height: 32),
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
      controller: _subcategorytext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        prefixIcon: SizedBox(width: 60,child: Icon(Icons.category_rounded, size: 20, color: iconsColor)),
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
        //categoryCheck(value!.toLowerCase().trim());
        //connector(value!.toLowerCase().trim());
        if (value!.toLowerCase().trim().isEmpty) {
          return "Subcategory cannot be empty";
        } else if (!categoryCheck(value.toLowerCase().trim())){
          return "Subcategory already exists";
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


              createNewCategory(newSubcategory.toLowerCase().trim(), budget);

              //adds new  document to db
              //categoriesRef.add(
                  //{"label": newCategory.toLowerCase().trim(), "budget": int.parse(budget), "parentID": 0, "categoryID": size + 1, "childIDs": [], "expenseIDs": [], "walletID": globals.getWallet()["walletID"]});

              //message showing verification
              final message =
                  "'$newSubcategory' has been successfully added to your categories";
              final snackBar = SnackBar(
                content: Text(
                  message,
                  style: const TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              //Navigator.pop(context, MaterialPageRoute(builder: (context) => const CategoryExpansionTile()));
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