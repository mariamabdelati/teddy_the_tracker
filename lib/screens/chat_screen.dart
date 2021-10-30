// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("chats/2n4pOdjrY95A2tR9Kq2q/messages")
              .snapshots(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == 'waiting') {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapShot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, index) => Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  documents[index]['text'],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("chats/2n4pOdjrY95A2tR9Kq2q/messages")
                  .add({'text': "this text was added by pressing the key"});
            }));
  }
}
