import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/registration/verify.dart';
import '../../screens/walletsmanagement/wallet_selection_screen.dart';
import '../../screens/dashboard/dashboard_navbar.dart';
import '../../screens/registration/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import '../../screens/dashboard/globals.dart';

//the main file instantiates the db and begins running the app
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
          fontFamily: "Nunito",
          appBarTheme: AppBarTheme(color: mainColorList[2]),
          backgroundColor: const Color(0xFFECF4FB),//
          primarySwatch: MaterialColor(0xFF164CC4, color),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: const Color(0xFFF6BAB5),
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ),

        /*
        this stream  builder checks if the user is logged in and navigates them to the select wallet screen
        otherwise, the user is navigated to the authentication screen which calls the login page
         */

        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            FirebaseAuth auth = FirebaseAuth.instance;
            if (userSnapshot.hasData &&
                globals.getWallet() == null &&
                FirebaseAuth.instance.currentUser!.emailVerified) {
              //print("returned to the main");
              return const SelectWallet();
            } else if (userSnapshot.hasData &&
                !FirebaseAuth.instance.currentUser!.emailVerified) {
              return Verify(isLogin: true, mauth: auth);
            }
            return const Scaffold(
              resizeToAvoidBottomInset: false,
              body: AuthScreen(true),
            );
          },
        )
    );
  }
}
//FINISHED ADDING AN APP THEME
