import 'package:flutter/material.dart';
import './constants.dart';
import './create_new_category.dart';
//import 'category_expansion_tile.dart';

class Options extends StatelessWidget {

  const Options({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.blue.withAlpha(100), blurRadius: 10.0)], borderRadius: const BorderRadius.all(Radius.circular(20.0)), color: mainColorList[1],),
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
                height: 40),
            Text(
              "Categories",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: iconsColor),
            ),
            const SizedBox(
                height: 30),
            ElevatedButton.icon(
              icon: Icon(
                Icons.add,
                color: mainColorList[4],
                size: 24.0,
              ),
              label: const Text("Create Category"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewCategory(title: 'Create New Category',)));
              },
              style: ElevatedButton.styleFrom(primary: mainColorList[3], padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 25,),
            ElevatedButton.icon(
              icon: Icon(
                Icons.delete_rounded,
                color: mainColorList[4],
                size: 24.0,
              ),
              label: const Text("Delete Category"),
              onPressed: null,
              style: ElevatedButton.styleFrom(primary: mainColorList[3], padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 45,),
            ElevatedButton.icon(
              icon: Icon(
                Icons.close_rounded,
                color: mainColorList[4],
                size: 24.0,
              ),
              label: const Text("Close"),
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(primary: mainColorList[3], padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}