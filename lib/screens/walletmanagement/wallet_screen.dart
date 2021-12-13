import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dashboard/globals.dart';

class WalletChoosing extends StatefulWidget {
  const WalletChoosing({Key? key}) : super(key: key);

  @override
  _WalletChoosingState createState() => _WalletChoosingState();
}

class _WalletChoosingState extends State<WalletChoosing> {
  @override
  Widget build(BuildContext context) {
    return _getwallets();
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
            return Scaffold(
              body: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: wallets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _createButton(wallets, index);
                  }),
            );
          }
        });
  }

  Widget _createButton(List<dynamic> wallets, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFFFFEFC7),
        ),
        onPressed: () {
          globals.setWallet(wallets[index]);
          Navigator.pop(context);
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
