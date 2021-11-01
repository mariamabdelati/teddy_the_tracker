import 'package:flutter/material.dart';
import 'category.dart';

void main() => runApp( SelectCategory());

class SelectCategory extends StatefulWidget {

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
  /*State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }*/
}

class _SelectCategoryState extends State<SelectCategory> {


  String selectedCategory = "";
  String newCategoryTitle = "";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
        appBar: AppBar(

          title: Text("Categories"),
        ),
        body: categorySection(context)

    ));
  }

  Widget categorySection(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0,),
          Text(
            "Please Define Your Category",
            style: TextStyle(fontSize: 30.0
            ),
            textAlign: TextAlign.center,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
            onChanged: (val) {
              newCategoryTitle = val;
              //print(addedCategoryTitle);
            },
          ),
          SizedBox(height: 15.0,),
          categoryPicker(),
          SizedBox(height: 15.0,)
        ],
      ),
    );
  }

  Widget categoryPicker() {
    List<Widget> categoryTabs() {
      Widget addNewCategory() {
        return Container(
          //margin: EdgeInsets.only(left: 20.0, right: 20.0),
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blue
          ),
          child: InkWell(
            child: Text(
              "+",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onTap: () {
              if (newCategoryTitle != '') {
                setState(() {
                  entryCategories.add(newCategoryTitle);
                });
              }
              else {
                print("text box empty");
              }
            },
          ),
        );
      }

      List<Widget> category = entryCategories.map((label) {
        return Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: (label.compareTo(selectedCategory) == 0)
                  ? Colors.amber
                  : Colors.blue
          ),
          child: InkWell(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onTap: () {
              setState(() {
                selectedCategory = label;
              });
            },
          ),
        );
      }).toList();
      category.insert(0, addNewCategory());
      return category;
    }

    return Wrap(
      spacing: 20,
      runAlignment: WrapAlignment.center,
      runSpacing: 10.0,
      alignment: WrapAlignment.center,
      children: categoryTabs(),
    );
  }
}
