import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:category_ui_fix/screens/category_expansion_tile.dart';
import 'package:category_ui_fix/screens/submission_button.dart';

import '../constants.dart';
import 'package:intl/intl.dart';

class AddNewEntryPage extends StatefulWidget {
  final String title;

  const AddNewEntryPage({Key? key, required this.title}) : super(key: key);

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
  //variable used to save the new title
  String newTitle = "";
  //variable used to save the new amount
  String amount = "";

  final _titletext = TextEditingController();
  final _amounttext = TextEditingController();

  var initialDate = DateTime.now();
  bool isChecked = false;
  CollectionReference expenseRef = FirebaseFirestore.instance
      .collection('/expenses/cFqsqHPIscrC6cY9iPs6/expense');

  var _dateTime = DateTime.now();
  String date_button_string = '';

  /*String formattedDate = DateFormat('dd-MM-yyyy').format(_dateTime);*/
  /*DateFormat('dd-MM-yyyy').format(_dateTime)*/

  String get_date_button_Text(){
    if (date_button_string == '') {
      return 'Date';
    }else{
        return DateFormat('dd-MM-yyyy').format(_dateTime);
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
        date_button_string = DateFormat('dd-MM-yyyy').format(value);
      });
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
      //form containing list view of the fields
      body:Form(
        key: formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),
            Text(
              "Please input the new expense or income data:",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: iconsColor),
            ),
            const SizedBox(height: 32),
            buildTitle(),
            const SizedBox(height: 16),
            buildAmount(),
            const SizedBox(height: 16),
            buildDate(),
            const SizedBox(height: 16),
            buildRecurring(),
            const SizedBox(height: 16),
            const CategoryExpansionTile(),
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
        hintText: "Enter the title for your expense",
        labelText: "New Title",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: _titletext.clear,
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
      //this is triggered upon saving the form using the submission button
      onSaved: (value) => setState(() => newTitle = value!.trim()),
    );
  }

  buildAmount() {
    return TextFormField(
      controller: _amounttext,
      focusNode: FocusNode(),
      decoration: InputDecoration(
        hintText: "Enter the amount for your expense",
        labelText: "Amount",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: _amounttext.clear,
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

  buildDate() {
    return Row(children: [
      const Text(
        "Choose a date                 ",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5689B9)),
      ),
      ElevatedButton(
          child: Text(get_date_button_Text()),
          onPressed: () {
            //get date here
            _showDatePicker();
          }),
    ]);
  }

  buildRecurring() {
    return Row(children: [
      const Text("Recurring?        ",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5689B9)),
      ),
      Checkbox(
        checkColor: Colors.white,
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
    ]);
  }

  Widget buildSubmit() {
    return Builder(
      builder: (context) {
        return SubmitButtonWidget(
          onClicked: () async {

            //checks if the data is valid
            final isValid = formKey.currentState!.validate();
            FocusScope.of(context).unfocus();

            if (isValid) {
              //saves the values (triggers onsaved)
              formKey.currentState!.save();

              //add to db
              await expenseRef.add({
                'amount': amount,
                'categoryId': 1,
                'date': DateFormat('dd-MM-yyyy').format(_dateTime),
                'expenseId': 2,
                'label': newTitle.toLowerCase(),
                'recurring': isChecked,
              });

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