import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../components/submission_button.dart';
import '../../screens/categorymanagement/category_expansion_tile.dart';
import '../../constants.dart';

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
  String dateText = '';

  String getDateText(){
    if (dateText == '') {
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
        dateText = DateFormat('dd-MM-yyyy').format(value);
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

  buildRecurring() {
    return Row(children: [
      const Text(
        "Recurring?        ",
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

