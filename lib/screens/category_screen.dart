import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teddy_categories/data/categories.dart';
import '../toggle_container_visibility.dart';
import 'add_category_screen.dart';
import '../models/category_model.dart';

//changing the category labels to uppercase
extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';

  String get capitalize => split(" ").map((str) => str.inCaps).join(" ");
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  //this string is used to identify what category has been selected
  var selectedCategory = "";
  var selectedCategoryID = 0;

  //this strong will be used to take user input for the new category
  var newCategoryTitle = "";

  //this variable is initialized with -1 to indicate no main category has been selected
  var index = -1;

  //this show child container is used to show the container when a category is pressed
  var _showChildContainer = false;

  //changes the state
  void show() {
    setState(() {
      _showChildContainer = true;
    });
  }

  /*
   build method contains the widget of the main entry categories and the visibility option that has the childContainer (subcategories for the specificied index)
   the state for visibility is toggled in the action chips section using onpressed
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //elevation: 0.0,
          title: const Text("Categories Section"),
          titleTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: categoryMaptoChip(entryCategories),
            ),
            const AddCategoryButton(),
          ],
        ));
  }

//takes a list of categories and maps them to chip buttons, wrapping them to be displayed in the container
  Widget categoryMaptoChip(List<Category> categories) {
    var contents = <Widget>[];
    categories.map((Category item) {
      if (item.parentID == -1) {
        contents.add(buildChips(item.label, item.categoryID));
        if (selectedCategoryID == item.categoryID && item.childIDs.isNotEmpty)
          {
            contents.add(InvisibleContainer(index, _showChildContainer, childContainer));
          }
      }
    }).toList();

    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: contents,
      ),
    );
  }

//takes a string and turns it into an action chip, the action chip changes colour when pressed and displays container
  Widget buildChips(String chipName, int chipNumber) {
    return ActionChip(
        labelPadding: const EdgeInsets.all(10),
        label: Text(chipName.capitalize),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFA),
        ),
        avatar: CircleAvatar(
          child: Text(chipName[0].toUpperCase()),
          backgroundColor: Colors.white.withOpacity(0.8),
        ),
        backgroundColor: (chipName.compareTo(selectedCategory) == 0)
            ? const Color(0xFFF6BAB5)
            : const Color(0xFF67B5FD),
        onPressed: () {
          selectedCategory = "";
          selectedCategoryID = 0;
          // the for loop iterates over the categories list and sees if the the chip name is the same as the label for the category
          //if the condition is met the selected category is made to equal chipname to  indicate selection (colour change)
          for (var i = 0; i < entryCategories.length; i++) {
            if (chipName == entryCategories[i].label) {
              setState(() {
                index = i;
                selectedCategory = chipName;
                selectedCategoryID = chipNumber;

              });
            }
          }
          //when pressed show is called to set visibility and the childcontainer is called to show the subcategory chips
          show();
        });
  }

  //childcontainer that shows the subcategories for a specific category selected
  childContainer(int index) {
    //if no category is selected or the category has no children, then the child container is invisible
    if (index < 0 || entryCategories[index].childIDs == []) {
      _showChildContainer = false;
    } else {
      //this variable holds the subcategories that will be shown in the container
      final children = <Widget>[];

      /*finding the child categories*/

      //for loop iterates over the categories list
      for (var i = 0; i < entryCategories.length; i++) {
        //for loop iterates over the children list
        for (var j = 0; j < entryCategories[index].childIDs.length; j++) {
          //if statement checks if the category is one of the children belonging to the list
          if (entryCategories[index].childIDs[j] ==
              entryCategories[i].categoryID) {
            //if condition is met then a chip is created for the item and it is added to a widget list
            children.add(buildChips(
                entryCategories[i].label, entryCategories[i].categoryID));
          }
        }
      }

      //a container containing the children is then returned
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: children,
        ),
        decoration: ShapeDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.blue),
      );
    }
  }
}
