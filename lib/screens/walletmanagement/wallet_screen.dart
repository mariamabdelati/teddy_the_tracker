import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teddy_the_tracker/screens/dashboard/dashboard_navbar.dart';
import 'package:teddy_the_tracker/screens/walletmanagement/add_new_wallet.dart';
import '../dashboard/globals.dart';

class WalletChoosing extends StatefulWidget {
  const WalletChoosing({Key? key}) : super(key: key);

  @override
  _WalletChoosingState createState() => _WalletChoosingState();
}

class _WalletChoosingState extends State<WalletChoosing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_getwallets(), const AddWalletButton()],
      ),
    );
  }

  Widget _getwallets() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("wallets/9Ho4oSCoaTrpsVn1U3H1/wallet")
            .where("usersIDs",
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong",
                style: TextStyle(color: Colors.white));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List wallets = snapshot.data!.docs.toList();
            return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                itemCount: wallets.length,
                itemBuilder: (BuildContext context, int index) {
                  return showWallet(
                    wallets,
                    index,
                  );
                });
          }
        });
  }

  Widget showWallet(List<dynamic> wallets, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFFFFEFC7),
        ),
        onPressed: () {
          globals.setWallet(wallets[index]);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (route) => false);
          // Navigator.pop(context);
        },
        child: Center(
          child: Text(
            wallets[index]["name"],
            style: TextStyle(color: Color(0xFF1D67A6), fontSize: 14),
          ),
        ),
      ),
    );
  }
}
