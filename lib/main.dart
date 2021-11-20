<<<<<<< HEAD
import 'package:auth_test/screens/auth_screen.dart';
import 'package:auth_test/widgets/auth/auth_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/welcome_screen.dart';
import 'constants.dart';
import 'screens/dashboard_screen.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/dashboard/dashboard_screen.dart';
//import '../../screens/entrymanagement/view_entries.dart';
import '../../screens/registration/auth_screen.dart';
//import '../../screens/welcome/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
>>>>>>> 81e15421d895fbe0cc4d9b92137aceaa31319c4e

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

<<<<<<< HEAD
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterChat App',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
=======
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
          //bottomSheetTheme: BottomSheetThemeData(
          //backgroundColor: Colors.black.withOpacity(0)),
          //canvasColor: Colors.transparent,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: const Color(0xFFF6BAB5),
              textTheme: ButtonTextTheme.primary,

>>>>>>> 81e15421d895fbe0cc4d9b92137aceaa31319c4e
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
<<<<<<< HEAD
              return DashboardScreen();
            }
            return WelcomeScreen();
          },
        )
        //ChatScreen(),
        );
  }
}



//FINISHED ADDING AN APP THEME
=======
              return const DashboardScreen();
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
>>>>>>> 81e15421d895fbe0cc4d9b92137aceaa31319c4e
