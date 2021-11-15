import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:teddy_categories/screens/category_expansion_tile.dart';

import '../constants.dart';

class AddNewEntryPage extends StatefulWidget {
  final String title;

  const AddNewEntryPage({Key? key, required this.title}) : super(key: key);

  @override
  AddNewEntryPageState createState() => AddNewEntryPageState();
}

class AddNewEntryPageState extends State<AddNewEntryPage> {
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
  String newTitle = "";
  String amount = "";

  final _titletext = TextEditingController();
  final _amounttext = TextEditingController();

  var initialDate = DateTime.now();
  bool isChecked = false;
  CollectionReference expenseRef = FirebaseFirestore.instance
      .collection('/expenses/cFqsqHPIscrC6cY9iPs6/expense');

  var _dateTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime(2023))
        .then((value) {
      setState(() {
        _dateTime = value!;
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
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: ElevatedButton(
                          child: const Text('Confirm'),
                          onPressed: () async {
                            //save to firebase
                            //tite_var = titleController.text.toString();
                            //amount_var = amountController.text.toString();

                            await expenseRef.add({
                              'amount': int.parse(amount),
                              'categoryId': 1,
                              'date': _dateTime.toString(),
                              'expenseId': 2,
                              'label': newTitle.toLowerCase(),
                              'recurring': isChecked,
                            }).then((value) => print("amount added"));
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: ElevatedButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ],
                ),
            ),
        );
  }

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
      validator: (value) {
        if (value == "" || value!.trim() == "") {
          return "Title cannot be empty";
        } else {
          return null;
        }
      },
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
      validator: (value) {
        if (value! == "") {
          return "Amount must not be empty";
        } else if (zeroCheck(value) == "0") {
          return "Amount must not be zero";
        } else {
          return null;
        }
      },
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
        "Choose a date \n",
        style: TextStyle(fontSize: 20),
      ),
      ElevatedButton(
          child: const Text('Date'),
          onPressed: () {
            //get date here
            _showDatePicker();
          }),
    ]);
  }

  buildRecurring() {
    return Row(children: [
      const Text("Recurring?\n",
          style: TextStyle(fontSize: 20)),
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
}
