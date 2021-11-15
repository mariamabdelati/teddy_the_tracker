import 'package:flutter/material.dart';
import './add_entries_page.dart';
import './user_transactions.dart';

class ViewEntries extends StatefulWidget {
  const ViewEntries({Key? key}) : super(key: key);

  @override
  ViewEntriesState createState() => ViewEntriesState();
}

class ViewEntriesState extends State<ViewEntries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0.0,
        title: const Text("View Entries"),
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[UserTransactions()],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: const Text('Add Expense'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewEntryPage(
                              title: 'Create a New Entry')),
                    );
                  }),
            )
          ]),
    );
  }
}
