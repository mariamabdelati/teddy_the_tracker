import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teddy_categories/screens/submission_button.dart';
import 'package:teddy_categories/constants.dart';

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
      if (value!.isEmpty || spaceRemover(value).isEmpty) {
        return "Category cannot be empty";
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
    onSaved: (value) => setState(() => budget = value!.isEmpty ? value: zeroCheck(value)),
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

          final message =
              "Category: $newCategory\nBudget: $budget";
          final snackBar = SnackBar(
            content: Text(
              message,
              style: const TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
    },
  );
  }
}