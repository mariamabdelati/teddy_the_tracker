import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/walletsmanagement/wallet_selection_screen.dart';
import '../../screens/dashboard/dashboard_navbar.dart';
//import '../../screens/entrymanagement/view_entries.dart';
import '../../screens/registration/auth_screen.dart';
//import '../../screens/welcome/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import '../../screens/dashboard/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Teddy the Tracker",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //canvasColor: mainColorList[4],
          fontFamily: "Nunito",
          appBarTheme: AppBarTheme(color: mainColorList[2]),
          backgroundColor: const Color(0xFFECF4FB), //
          primarySwatch: MaterialColor(0xFF164CC4, color),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
          //canvasColor: Colors.transparent,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: const Color(0xFFF6BAB5),
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData && globals.getWallet() == null) {
              return const SelectWallet();
            }
          },
        ));
  }
}
