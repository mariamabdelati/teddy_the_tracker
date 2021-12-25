import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teddy_the_tracker/screens/welcome/welcome_page.dart';
import '../../components/hero_dialog_route.dart';
import '../../constants.dart';
import 'dart:math';

class AddWalletButton extends StatelessWidget {
  final int idx;
  const AddWalletButton(this.idx, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pages = [
      AddWalletPopupCard(),
      JoinWalletPopupCard(),
    ];
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 4.0, right: 4.0, left: 4.0, top: 12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return pages[idx];
          }));
        },
        child: Hero(
          tag: idx == 0 ? _heroAddWallet : _heroJoinWallet,
          child: SizedBox(
            height: 120,
            width: 180,
            child: Card(
              elevation: 4,
              color: const Color(0xFF0C43D5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          idx == 0 ? "Create New Wallet" : "Join Wallet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: mainColorList[4],
                            fontSize: 17,
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
      //),
    );
  }
}

// Tag-value used for the add category popup button.
const String _heroAddWallet = 'add-wallet-hero';

class AddWalletPopupCard extends StatefulWidget {
  // {@macro add_category_popup_card}
  AddWalletPopupCard({Key? key}) : super(key: key);

  @override
  State<AddWalletPopupCard> createState() => AddWalletPopupCardState();
}

class AddWalletPopupCardState extends State<AddWalletPopupCard> {
  bool isEnabled = true;

  var _text = TextEditingController();

  bool _validate = false;

  String errorText = "";

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
          tag: _heroAddWallet,
          child: Material(
            color: const Color(0xFFECF4FB),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _text,
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        labelText: "Wallet Name",
                        errorText: _validate ? errorText : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: SizedBox(
                            width: 60,
                            child: Icon(Icons.account_balance_wallet_outlined,
                                size: 25, color: iconsColor)),
                        suffixIcon: SizedBox(
                          width: 60,
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              size: 20,
                            ),
                            onPressed: _text.clear,
                          ),
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
                              errorText = "Wallet can't be empty";
                            } else if (!walletcheck(
                                _text.text.trim().toLowerCase())) {
                              _validate = true;
                              errorText = "Wallet name already exists";
                            } else {
                              _validate = false;
                            }
                            //get results from the class and search for duplicate names
                          });
                          if (!_validate) {
                            createNewWallet(_text.text.trim().toLowerCase());
                            Navigator.pop(context);
                            buildSuccessDialog(context,
                                "Wallet ${_text.text} was created successfully");
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

  QuerySnapshot highestCategory = await FirebaseFirestore.instance
      .collection("categories/JBSahpmjY2TtK0gRdT4s/category")
      .orderBy("categoryID", descending: true)
      .limit(1)
      .get();
  int highestID = highestCategory.docs[0]["categoryID"];

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
    "joinCode": createJoinCode(),
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
    categoriesIdList.add(index + highestID + 1);
    var newCategory = defaultCategoriesList[index];
    categoriesRef.add({
      "label": newCategory.toLowerCase().trim(),
      "budget": budget,
      "parentID": 0,
      "categoryID": highestID + index + 1,
      "childIDs": [],
      "expenseIDs": [],
      "incomeIDs": [],
      "walletID": maxId + 1,
    });
  }
  FirebaseFirestore.instance
      .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
      .doc(createdWallet.id)
      .set({"categoriesIDs": categoriesIdList}, SetOptions(merge: true));
}

const String _heroJoinWallet = 'join-wallet-hero';

class JoinWalletPopupCard extends StatefulWidget {
  // {@macro add_category_popup_card}
  JoinWalletPopupCard({Key? key}) : super(key: key);

  @override
  State<JoinWalletPopupCard> createState() => JoinWalletPopupCardState();
}

class JoinWalletPopupCardState extends State<JoinWalletPopupCard> {
  bool isEnabled = true;

  var _text = TextEditingController();

  bool _validate = false;

  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Hero(
          tag: _heroJoinWallet,
          child: Material(
            color: const Color(0xFFECF4FB),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _text,
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        labelText: "Wallet Code",
                        errorText: _validate ? errorText : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: SizedBox(
                            width: 60,
                            child: Icon(Icons.account_balance_wallet_outlined,
                                size: 25, color: iconsColor)),
                        suffixIcon: SizedBox(
                          width: 60,
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              size: 20,
                            ),
                            onPressed: _text.clear,
                          ),
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
                        onPressed: () async {
                          setState(() {
                            if (_text.text.isEmpty) {
                              _validate = true;
                              errorText = "Wallet name can not be empty";
                            } else {
                              _validate = false;
                            }
                            //get results from the class and search for duplicate names
                          });
                          if (!_validate) {
                            // Joining wallet logic
                            String join_code = _text.text;
                            QuerySnapshot joinableWallet =
                                await FirebaseFirestore.instance
                                    .collection(
                                        "wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
                                    .where("joinCode", isEqualTo: join_code)
                                    .limit(1)
                                    .get();
                            if (joinableWallet.size == 0) {
                              setState(() {
                                _validate = true;
                                errorText =
                                    "There is no wallet with this join code";
                              });
                            } else if (joinableWallet.size == 1) {
                              DocumentReference joinableWalletRef =
                                  joinableWallet.docs[0].reference;
                              DocumentSnapshot joinableWalletSnp =
                                  await joinableWalletRef.get();
                              List newUsersList = joinableWalletSnp["usersIDs"];
                              String user_id =
                                  FirebaseAuth.instance.currentUser!.uid;
                              if (newUsersList.contains(user_id)) {
                                setState(() {
                                  _validate = true;
                                  errorText = "You already are in this wallet";
                                });
                              } else {
                                // user can join it
                                newUsersList.add(
                                    FirebaseAuth.instance.currentUser!.uid);
                                joinableWalletRef.update(
                                    {"usersIDs": newUsersList}).then((value) {
                                  Navigator.pop(context);
                                  buildSuccessDialog(context,
                                      "successfully joined ${joinableWalletSnp["name"]}");
                                });
                              }
                            }
                          }
                        },
                        child: const Text('Join'),
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

String createJoinCode() {
  var r = Random();
  String joinCode = String.fromCharCodes(
      List.generate(8, (index) => r.nextInt(122 - 65) + 65));
  return joinCode;
}
