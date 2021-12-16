import 'package:flutter/material.dart';
import '../../components/hero_dialog_route.dart';
import '../../constants.dart';

class AddWalletButton extends StatelessWidget {
  //Widget navigatePage();
  const AddWalletButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return AddWalletPopupCard();
          }));
        },
        child: Hero(
            tag: _heroAddCategory,
            child: SizedBox(
              height: 160,
              width: 160,
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
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
                            style: TextStyle(color: mainColorList[4], fontSize: 17,),
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
                            } else {
                              _validate = false;
                            }
                          });
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