import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import '../../screens/categorymanagement/subcategory_expansion_tile.dart';
import '../../screens/dashboard/globals.dart';
import '../../constants.dart';
import '../dashboard/dashboard_navbar.dart';
import 'add_new_wallet.dart';

class SelectWallet extends StatefulWidget {
  const SelectWallet({Key? key,}) : super(key: key);

  @override
  _SelectWalletState createState() => _SelectWalletState();
}

class _SelectWalletState extends State<SelectWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Wallet"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          bottom: false,
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 1,child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: AddWalletButton(0),
                    )),
                    Expanded(flex:1,child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: AddWalletButton(1)))
                  ],
                ),
              ),
              _buildBody(context),
            ],
          ),
        ),
      ),
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
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
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
        globals.setWallet(wallets[index]);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
                (route) => false);
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
