import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
}

class Category {
  //final num budget;
  //final num categoryID;
  //final Map<num, List<num>> subcat;
  final String label;
  final List<Category> childID;

  Category(this.label, this.childID/*this.budget, this.categoryID, this.subcat,  this.parentID*/);
}

List<Category> catList = [];

List<Category> entryCategories = [
  Category("food", [Category("fast food",[])]),
  Category("clothing", [Category("dresses",[])]),
  Category("transportation", [Category("uber",[]), Category("gas",[])]),
  Category("Savings", []),
  Category("Medical", []),
  Category("Utilities", []),
  Category("Subscriptions", []),
  Category("Other", []),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}


class _CategoryScreenState extends State<CategoryScreen> {

  String selectedCategory = "";
  String newCategoryTitle = "";

  int index = 0;

  var _showContainer;

  List getchild(Category x) {
    return x.childID;
  }

  @override
  void initState() {
    _showContainer = false;
    super.initState();
  }

  void show() {
    setState(() {
      _showContainer = !_showContainer;
    });
  }

  SampleContainer(int index) {
    return categorySection(entryCategories[index].childID);
  }

  @override
  /*Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Custom Categories"),
              centerTitle: true,
            ),
            body:
              Center(child: categorySection(entryCategories))

        )
    );
  }*/
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: <Widget>[
                Center(child: categorySection(entryCategories)),
                SizedBox(height: 20),
                Visibility(
                  child:
                  Center(child: SampleContainer(index)),
                  visible: _showContainer,
                ),
              ],
            ),
          )),
    );
  }

  Widget categorySection(List<Category> categories)
  {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      //direction: Axis.vertical, // main axis (rows or columns)
      children: categories.map((item) => buildChips(item.label)).toList(),
    );
  }

  Widget buildChips(String x)=> ActionChip(
    labelPadding: const EdgeInsets.all(10),
    label: Text(x.inCaps),
    labelStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFFFFFFFA),
    ),
    avatar: CircleAvatar(
      child: Text(x[0].toUpperCase()),
      backgroundColor: Colors.white.withOpacity(0.8),
    ),

    backgroundColor: (x.compareTo(selectedCategory) == 0) ? Colors.amber
      : Colors.blue,/*const Color(0xFF67B5FD),*/

    onPressed: () {
      setState(() {
        selectedCategory = x;
      });
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => categoryPressed(context)),
      );*/
      for(var i = 0; i < entryCategories.length; i++){
        if (x == entryCategories[i].label) {
          index = i;
        }
      }

      show();
      SampleContainer(index);
      //categoryPressed(context);
    },
  );


  Widget categoryPressed(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            //margin: EdgeInsets.only(left: 20.0, right: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)), color: Colors.blue),
            child: const InkWell(
                child: Text(
                  "asdfghjklkjchgwvcjicbewuviewbvneivubewuv dwcdcuehcewivbwv vewbcisbciewvewcbdjcew cejw cuewbcwe vcbewukcewbcewbe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                )
            )
        ),
      ),
    );
  }
/*
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
          decoration: ShapeDecoration(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)), color: Colors.blue),
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
          decoration: ShapeDecoration(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
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
*/

}




/*
Future<int> createCategory(String category) async {
  //check if exists already
  var exists = await categoryExists(category.label);

  if(exists) return 0;

  var db = await OfflineDbProvider.provider.database;
  //get the biggest id in the table
  var table = await db.rawQuery("SELECT MAX(id) as id FROM Category");
  int id = table.first["id"] == null ? 1 : table.first["id"] + 1;
  //insert to the table using the new id
  var resultId = await db.rawInsert(
      "INSERT Into Category (id, title, desc, iconCodePoint)"
          " VALUES (?,?,?,?)",
      [id, category.title, category.desc, category.iconCodePoint.toString()]);
  return resultId;
}*/


