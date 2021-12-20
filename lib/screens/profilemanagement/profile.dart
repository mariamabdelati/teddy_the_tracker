import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';

import '../../screens/dashboard/globals.dart';
import '../../main.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        //elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              child:
                  Icon(Icons.person_rounded, color: mainColorList[4], size: 60),
              backgroundColor: const Color(0xFF1D67A6),
            ),
            const SizedBox(height: 40),
            ProfileMenu(
              text: "My Account",
              icon: const Icon(
                Icons.person_rounded,
                color: Color(0xFF1D67A6),
                size: 30,
              ),
              press: () => {},
            ),
            const SizedBox(
              height: 5,
            ),
            ProfileMenu(
              text: "Notifications",
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFF1D67A6),
                size: 30,
              ),
              press: () {},
            ),
            const SizedBox(
              height: 5,
            ),
            ProfileMenu(
              text: "Settings",
              icon: const Icon(
                Icons.settings,
                color: Color(0xFF1D67A6),
                size: 30,
              ),
              press: () {},
            ),
            const SizedBox(
              height: 5,
            ),
            ProfileMenu(
              text: "Help Center",
              icon: const Icon(
                Icons.help,
                color: Color(0xFF1D67A6),
                size: 30,
              ),
              press: () {},
            ),
            const SizedBox(
              height: 5,
            ),
            ProfileMenu(
              text: "Log Out",
              icon: const Icon(
                Icons.logout,
                color: Color(0xFF1D67A6),
                size: 30,
              ),
              press: () {
                FirebaseAuth.instance.signOut();
                globals.setWallet(null);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*Container(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: const Text("Log out"),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ),
      ),
    );*/

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final Widget icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      decoration: BoxDecoration(
        color: mainColorList[1],
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0xFFDBDBDB),
            //offset: Offset(1.1, 1.1),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: const Color(0xFF1D67A6),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: mainColorList[1],
        ),
        onPressed: press,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
