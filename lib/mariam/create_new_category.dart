import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './submission_button.dart';
import './constants.dart';
//import 'category_expansion_tile.dart';

var size = 0;

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
  String spaceRemover(String x){
    String y = "";
    for (int i = 0; i < x.length; i++){
      if(x[i] == " "){
        continue;
      } else{
        y = x.substring(i);
        break;
      }
    }
    return y;
  }

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
  String newCategory = "";
  String budget = "";

  final _categorytext = TextEditingController();
  final _budgettext = TextEditingController();




  Future<bool> categoryCheck(String newCat) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('categories/JBSahpmjY2TtK0gRdT4s/category')
        .where('label', isEqualTo: newCat)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return (documents.length == 1);
  }

  void connector(String v) async {
    bool value = await categoryCheck(v);
    setState(() {
      _invalid = value;
    });
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
    body: Form(
      key: formKey,
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          Text(
            "Please input the new category data:", textAlign: TextAlign.center,
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

  late bool _invalid;
  Widget buildCategory() {
    return TextFormField(
      controller: _categorytext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        labelText: "New Category",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: _categorytext.clear,
        ),
      ),



    validator: (value) {
      connector(value!.toLowerCase().trim());
      if (value == "" || spaceRemover(value) == "") {
        return "Category cannot be empty";
      } else if (_invalid){
        return "Category already exists";
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => newCategory = spaceRemover(value!)),
  );
  }

  Widget buildBudget() {
    return TextFormField(
      controller: _budgettext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        labelText: "Budget",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: _budgettext.clear,
        ),
    ),
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
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"))
    ],
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

          CollectionReference categoriesRef = FirebaseFirestore.instance.collection("categories/JBSahpmjY2TtK0gRdT4s/category");

          categoriesRef.add(
              {"label": newCategory.toLowerCase().trim(), "budget": int.parse(budget), "parentId": 0, "categoryId": size + 1, "childIds": [], "expenseIds": []});

          final message =
              "'$newCategory' has been successfully added to your categories";
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