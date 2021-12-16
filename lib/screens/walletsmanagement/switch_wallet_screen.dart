import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import '../../screens/categorymanagement/subcategory_expansion_tile.dart';
import '../../screens/dashboard/globals.dart';
import '../../constants.dart';

/*class Wallets {
  Wallets(this.walletId, this.name, this.userIds);
  int? walletId;
  String? name;
  List? userIds;
  DocumentReference? reference;

  Wallets.fromMap(Map<String, dynamic> map, {this.reference}) {
    walletId = map["walletID"];
    name = map["name"];
    userIds = map["usersIDS"];
  }

  @override
  String toString() => "Wallet<$walletId : $name\$";
}*/






class SwitchWallet extends StatefulWidget {
  /*final double width;
  final double height;
  final double xoffset;
  final double yoffset;
  final double opacity;*/

  const SwitchWallet({Key? key, /*required this.width, required this.height, required this.xoffset, required this.yoffset, required this.opacity*/}) : super(key: key);

  @override
  _SwitchWalletState createState() => _SwitchWalletState();
}

class _SwitchWalletState extends State<SwitchWallet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.blue.withAlpha(100), blurRadius: 10.0)], borderRadius: const BorderRadius.all(Radius.circular(40.0)), color: mainColorList[1],),
      height: 650,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("/wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
            .where("usersIDs", arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong", style: TextStyle(color: Colors.white));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List wallets = snapshot.data!.docs.toList();
            /*List<Wallets> wallets = snapshot.data!.docs
              .map((docSnapshot) =>
              Wallets.fromMap(docSnapshot.data() as Map<String, dynamic>))
              .toList();*/
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: wallets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _createWalletCard(wallets, index),
                );
              },
            );
          }
        });
  }

  Widget _createWalletCard(List<dynamic> wallets, int index) {
    return GestureDetector(
      onTap: (){
        //where wallet is switched
        /*print("wallet switched to " + (wallets[index].name as String));*/
        globals.setWallet(wallets[index]);
        Navigator.pop(context);
      },
      child: Card(
        elevation: 4,
        color: const Color(0xFF0C43D5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
                    (wallets[index]["name"]).toString().capitalize,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: mainColorList[4], fontSize: 20,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
    /*Scaffold(
      appBar: AppBar(
        title: const Text('Switch Wallet'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        //elevation: 0,
      ),
      body: buildBody(context),*/

    /*return AnimatedContainer(
      padding: const EdgeInsets.all(32),
      width: widget.width,
      height: widget.height,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(widget.xoffset, widget.yoffset, 1),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(widget.opacity),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: buildBody(context));*/

    /*return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Wallet'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        //elevation: 0,
      ),
      body: _buildBody(context),
    );}*/
