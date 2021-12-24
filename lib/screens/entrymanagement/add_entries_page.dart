import 'dart:math';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../components/submission_button.dart';
import '../../screens/categorymanagement/category_expansion_tile.dart';
import '../../constants.dart';

class AddNewEntryPage extends StatefulWidget {
  final String title;
  final ScrollController controller;

  const AddNewEntryPage({Key? key, required this.title, required this.controller}) : super(key: key);

  @override
  AddNewEntryPageState createState() => AddNewEntryPageState();
}

class AddNewEntryPageState extends State<AddNewEntryPage> {
  //this function takes a string and removes beginning zeros so that the we can check that the user did not enter an amount that is 0
  String zeroCheck(String x) {
    String y = "";
    for (int i = 0; i < x.length; i++) {
      if (x[i] == "0") {
        continue;
      } else {
        y = x.substring(i);
        break;
      }
    }
    if (y == "" || y == "." || y == ".0" || y == ".00") {
      y = "0";
    }
    return y;
  }

  final formKey = GlobalKey<FormState>();
  bool catSelect = true;
  //variable used to save the new title
  String newTitle = "";
  //variable used to save the new amount
  String amount = "";
  String recurring = "";
  String type = "";
  bool isExpense = false;
  bool validType = true;
  bool validReccuring = true;

  final _titletext = TextEditingController();
  final _amounttext = TextEditingController();

  var initialDate = DateTime.now();
  bool isChecked = false;


  CollectionReference expenseRef = FirebaseFirestore.instance
      .collection('/entries/7sQnsmHSjX5K8Sgz4PoD/expense');

  CollectionReference incomeRef = FirebaseFirestore.instance
      .collection('/entries/7sQnsmHSjX5K8Sgz4PoD/income');

  var _dateTime = DateTime.now();
  String dateText = '';

  String getDateText(){
    if (dateText == '') {
      return 'Date';
    }else{
      return DateFormat('yyyy-MM-dd').format(_dateTime);
    }
  }

  void _showDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2023))
        .then((value) {
      setState(() {
        _dateTime = value!;
        dateText = DateFormat('yyyy-MM-dd').format(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        /*leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),*/
      ),
      //form containing list view of the fields
      body: Form(
        key: formKey,
        child: ListView(
          controller: widget.controller,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            //const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                "Entry Details",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: mainColorList[2]),
              ),
            ),
            const SizedBox(height: 16),
            buildType(),
            validateType(!validType, "type"),
            const SizedBox(height: 16),
            buildTitle(),
            const SizedBox(height: 16),
            buildAmount(),
            const SizedBox(height: 16),
            buildDate(),
            const SizedBox(height: 16),
            buildRecurring(),
            validateType(!validReccuring, "recurrence"),
            const SizedBox(height: 16),
            CategoryExpansionTile(catSelect),
            //validateType(!catSelect, "category"),
            const SizedBox(height: 32),
            const Divider(
              color: Color(0xFF67B5FD),
              thickness: 0.5,
            ),
            const SizedBox(height: 32),
            buildSubmit(),
          ],
        ),
      ),
    );
  }

  //builds title text field
  buildTitle() {
    return TextFormField(
      controller: _titletext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        hintText: "Entry Title",
        //labelText: "New Title",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        prefixIcon: SizedBox(
            width: 60,
            child:
            Icon(Icons.label_outline_rounded, size: 25, color: iconsColor)),
        suffixIcon: SizedBox(
          width: 60,
          child: IconButton(
            icon: const Icon(
              Icons.clear_rounded,
              size: 20,
            ),
            onPressed: _titletext.clear,
          ),
        ),
      ),

      //validates the value in title y making it a required field and ensuring it isnt empty
      validator: (value) {
        if (value == "" || value!.trim() == "") {
          return "Title cannot be empty";
        } else {
          return null;
        }
      },

      //validates the value in title y making it a required field and ensuring it isnt empty
      onSaved: (value) => setState(() => newTitle = value!.trim()),
    );
  }

  buildAmount() {
    return TextFormField(
      controller: _amounttext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        hintText: "Amount",
        //labelText: "Amount",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        prefixIcon: SizedBox(
            width: 60,
            child:
            Icon(Icons.account_balance_wallet_outlined, size: 25, color: iconsColor)),
        suffixIcon: SizedBox(
          width: 60,
          child: IconButton(
            icon: const Icon(
              Icons.clear_rounded,
              size: 20,
            ),
            onPressed: _amounttext.clear,
          ),
        ),
      ),

      //validations check if amount is empty or 0
      validator: (value) {
        if (value! == "") {
          return "Amount must not be empty";
        } else if (zeroCheck(value) == "0") {
          return "Amount must not be zero";
        } else {
          return null;
        }
      },

      // only allow numbers and decimal places up to 2 places
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"))
      ],
      onSaved: (value) => setState(() => amount = zeroCheck(value!)),
    );
  }

  buildDate(){
    return TextFormField(
      readOnly: true,
      onTap: () {
        _showDatePicker();
      },
      decoration: InputDecoration(
        hintText: getDateText(),
        hintStyle: getDateText() != 'Date' ? const TextStyle(color: Colors.black87) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        prefixIcon: SizedBox(
            width: 60,
            child: Icon(Icons.date_range_rounded, size: 25, color: iconsColor)),
      ),
      validator: (value) {
        if (getDateText() == "Date") {
          return "Date must not be empty";
        } else {
          return null;
        }
      },
    );
  }

  buildType() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          border: Border.all(
            color: validType ? Colors.grey : const Color(0xFFD32F2F),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Icon(EvaIcons.creditCardOutline, color: iconsColor, size: 26),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: (type == "Expense")
                  ? mainColorList[8]
                  : iconsColor, width: 2),
              primary: (type == "Expense")
                  ? mainColorList[8]
                  : iconsColor,
              //backgroundColor: (recurring == "Yes") ? Colors.grey: null,
            ),
            onPressed: () {
              setState(() {
                type = "Expense";
                isExpense = true;
                validType =  true;
              });
            },
            child: Center(
              child: Text(
                "Expense",
                style: TextStyle(
                    color: (type == "Expense")
                        ? mainColorList[8]
                        : iconsColor,
                    fontSize: 16
                ),
              ),
            ),
          ),
          const SizedBox(width: 15,),
          OutlinedButton(
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: (type == "Income")
                  ? progressbarColorWhite
                  : iconsColor, width: 2),
              primary: (type == "Income") ? progressbarColorWhite : iconsColor,
              //backgroundColor: (recurring == "No") ? Colors.grey[100]: null,
            ),
            onPressed: () {
              setState(() {
                type = "Income";
                isExpense = false;
                validType =  true;
              });
            },
            child: Center(
              child: Text(
                "Income",
                style: TextStyle(
                    color: (type == "Income")
                        ? progressbarColorWhite
                        : iconsColor,
                    fontSize: 16
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  validateType(bool x, String w) {
    return Visibility(
        visible: x,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 12),
          child: Text("Please select the $w of your entry", style: const TextStyle(fontSize: 12,  color: Color(0xFFD32F2F)),),)
    );
  }

  buildRecurring() {
    return Container(
      //margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          border: Border.all(
            color: validReccuring ? Colors.grey : const Color(0xFFD32F2F),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Icon(Icons.autorenew_rounded, color: iconsColor, size: 25),
          ),
          const Text(
            "Recurring?",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          const SizedBox(width: 30,),
          OutlinedButton(
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: (recurring == "Yes")
                  ? mainColorList[8]
                  : iconsColor, width: 2),
              primary: (recurring == "Yes")
                  ? mainColorList[8]
                  : iconsColor,
              //backgroundColor: (recurring == "Yes") ? Colors.grey: null,
            ),
            onPressed: () {
              setState(() {
                recurring = "Yes";
                isChecked = true;
                validReccuring = true;
              });
            },
            child: Center(
              child: Text(
                "Yes",
                style: TextStyle(
                    color: (recurring == "Yes")
                        ? mainColorList[8]
                        : iconsColor,
                    fontSize: 16
                ),
              ),
            ),
          ),
          const SizedBox(width: 15,),
          OutlinedButton(
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: (recurring == "No")
                  ? progressbarColorWhite
                  : iconsColor, width: 2),
              primary: (recurring == "No") ? progressbarColorWhite : iconsColor,
              //backgroundColor: (recurring == "No") ? Colors.grey[100]: null,
            ),
            onPressed: () {
              setState(() {
                recurring = "No";
                isChecked = false;
                validReccuring = true;
              });
            },
            child: Center(
              child: Text(
                "No",
                style: TextStyle(
                    color: (recurring == "No")
                        ? progressbarColorWhite
                        : iconsColor,
                    fontSize: 16
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubmit() {
    return Builder(
      builder: (context) {
        return SubmitButtonWidget(
          onClicked: () async {

            //checks if the data is valid
            final isValid = formKey.currentState!.validate();
            FocusScope.of(context).unfocus();
            var isSelected = true;

            if (selectedCategoryID == 0){
              setState(() {
                catSelect = false;
              });
            } else {
              setState(() {
                catSelect = true;
              });
            }

            if (recurring.isEmpty){
              setState(() {
                validReccuring = false;
                isSelected = false;
              });
            }

            if (type.isEmpty){
              setState(() {
                validType = false;
                isSelected = false;
              });
            }

            if (isValid && isSelected) {
              //saves the values (triggers onsaved)
              formKey.currentState!.save();

              //add to db
              createNewEntry(newTitle.toLowerCase(), amount, _dateTime, isChecked, isExpense);

              //shows snackbar with details upon adding
              final message =
                  "'$newTitle' with amount '$amount 'has been successfully added to your entries";
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

void createNewEntry(String label, String amount, DateTime date, bool recurring, bool isExpense) async {
  QuerySnapshot entry;
  if (isExpense){
    entry = await FirebaseFirestore.instance
        .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
        .orderBy("expenseID")
        .get();
  } else{
    entry = await FirebaseFirestore.instance
        .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/income")
        .orderBy("incomeID")
        .get();
  }

  var entriesList = entry.docs;
  var maxId = 0;
  for (var doc in entriesList) {
    if (isExpense){
      maxId = max(maxId, doc["expenseID"]);
    } else{
      maxId = max(maxId, doc["incomeID"]);
    }
  }
  var newID = maxId + 1;


  if (isExpense) {
    var createdEntry = FirebaseFirestore.instance
        .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/expense")
        .doc();
    createdEntry.set({
      "label": label.toLowerCase().trim(),
      'date': DateFormat('yyyy-MM-dd').format(date),
      "amount": amount,
      "categoryID": selectedCategoryID,
      "expenseID": newID,
      "recurring": recurring,
      //"walletID": globals.getWallet()["walletID"],
    });
  } else {
    var createdEntry = FirebaseFirestore.instance
        .collection("/entries/7sQnsmHSjX5K8Sgz4PoD/income")
        .doc();
    createdEntry.set({
      "label": label.toLowerCase().trim(),
      'date': DateFormat('yyyy-MM-dd').format(date),
      "amount": amount,
      "categoryID": selectedCategoryID,
      "incomeID": newID,
      "recurring": recurring,
      //"walletID": globals.getWallet()["walletID"],
    });
  }



  //var existingCatsList = globals.getWallet()["categoriesIDs"];
  QuerySnapshot categoriesRef = await FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .where("categoryID", isEqualTo: selectedCategoryID).get();

  var categ = categoriesRef.docs[0];


  List existingEntries = categ["expenseIDs"];
  existingEntries.add(newID);

  FirebaseFirestore.instance
      .collection("/categories/JBSahpmjY2TtK0gRdT4s/category")
      .doc(categ.id)
      .set({"expenseIDs": existingEntries}, SetOptions(merge: true));

}