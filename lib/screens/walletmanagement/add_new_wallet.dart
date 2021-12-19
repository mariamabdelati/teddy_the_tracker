import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teddy_the_tracker/screens/dashboard/globals.dart';
import '../../components/hero_dialog_route.dart';
import '../../constants.dart';
import 'dart:math';

class AddWalletButton extends StatelessWidget {
  const AddWalletButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return AddCategoryPopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddCategory,
          child: SizedBox(
            height: 160,
            width: 200,
            child: Card(
              elevation: 4,
              color: const Color(0xFF0C43D5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          //alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  color: Color.fromRGBO(255, 255, 255, 0.38)),
                              child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Create New Wallet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: mainColorList[4],
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Tag-value used for the add category popup button.
const String _heroAddCategory = 'add-wallet-hero';

class AddCategoryPopupCard extends StatefulWidget {
  // {@macro add_category_popup_card}
  AddCategoryPopupCard({Key? key}) : super(key: key);

  @override
  State<AddCategoryPopupCard> createState() => AddCategoryPopupCardState();
}

class AddCategoryPopupCardState extends State<AddCategoryPopupCard> {
  bool isEnabled = true;

  var _text = TextEditingController();

  bool _validate = false;

  var documents;

  @override
  void initState() {
    super.initState();

    _getWallets();
  }

  void _getWallets() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
        .where("usersIDs",
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<DocumentSnapshot> docs = result.docs;
    documents = docs;
  }

  bool walletcheck(String name) {
    for (var document in documents) {
      if (document["name"] == name) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Hero(
          tag: _heroAddCategory,
          child: Material(
            color: const Color(0xFFECF4FB),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _text,
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        labelText: "Category Name",
                        errorText: _validate ? "Category can't be empty" : null,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _text.clear,
                        ),
                      ),
                      cursorColor: const Color(0xFF67B5FD),
                      enabled: isEnabled,
                      readOnly: !isEnabled,
                    ),
                    const Divider(
                      color: Color(0xFFECF4FB),
                      thickness: 0.5,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (_text.text.isEmpty) {
                              _validate = true;
                            } else if (!walletcheck(_text.text)) {
                              _validate = true;
                            } else {
                              _validate = false;
                            }
                            //get results from the class and search for duplicate names
                          });
                          if (!_validate) {
                            createNewWallet(_text.text);
                          }
                        },
                        child: const Text('Add'),
                        style: TextButton.styleFrom(primary: Colors.blue))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//not used yet
void createNewWallet(String name) async {
  QuerySnapshot wallets = await FirebaseFirestore.instance
      .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
      .orderBy("walletID")
      .get();
  CollectionReference categoriesRef = FirebaseFirestore.instance
      .collection("categories/JBSahpmjY2TtK0gRdT4s/category");
  var walletsList = wallets.docs;
  var maxId = 0;
  for (var doc in walletsList) {
    maxId = max(maxId, doc["walletID"]);
  }
  var createdWallet = FirebaseFirestore.instance
      .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
      .doc();
  createdWallet.set({
    "name": name,
    "walletID": maxId + 1,
    "categoriesIDs": [],
    "usersIDs": [FirebaseAuth.instance.currentUser!.uid],
  });
  // globals.setWallet(createdWallet as Map);

  const budget = -1;
  List defaultCategoriesList = [
    "Food & Beverage",
    "Shopping",
    "Groceries",
    "Healthcare",
    "Bills & Utilities",
    "Transportation",
    "Entertainment",
    "Gifts & Donations",
    "Travel",
    "Others"
  ];
  List categoriesIdList = [];
  for (var index = 0; index < defaultCategoriesList.length; index++) {
    categoriesIdList.add(index);
    var newCategory = defaultCategoriesList[index];
    categoriesRef.add({
      "label": newCategory.toLowerCase().trim(),
      "budget": budget,
      "parentId": 0,
      "categoryId": index,
      "childIds": [],
      "expenseIds": [],
      "walletId": maxId + 1,
    });
  }
  print(createdWallet.id);
  FirebaseFirestore.instance
      .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
      .doc(createdWallet.id)
      .set({"categoriesIDs": categoriesIdList}, SetOptions(merge: true));
}
