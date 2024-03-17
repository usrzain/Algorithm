import 'package:effecient/Auth/HomePage.dart';
import 'package:effecient/Auth/loginPage.dart';
import 'package:effecient/Data.dart';
import 'package:effecient/Providers/chData.dart';
import 'package:effecient/Providers/loading.dart';

import 'package:effecient/Screens/Extra_Screens/tabCheck.dart';
import 'package:effecient/WelcomePage.dart';
import 'package:effecient/tab_contents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:effecient/Screens/CarSelection/carSelection.dart';

import 'package:effecient/Screens/CarSelection/carSelect.dart';
import 'package:effecient/Screens/Extra_Screens/intro1.dart';

import 'package:effecient/Screens/Intro/intro_screen.dart';

import 'package:effecient/Screens/PortSelection/EvPortSelectionScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //MAIN
  runApp(ChangeNotifierProvider(
    // Create an instance of YourDataProvider
    create: (context) => chDataProvider(),

    child: const MyApp(initialScreen: LoginPage()), // Your app's main widget
  ));
  // Preview the WelcomePage directly
  // runApp(MyApp(initialScreen: HomePage()));

  // runApp(MyApp(initialScreen: const MyTabScreen()));

  //runApp(MyApp(initialScreen: CarSelect()));
  //runApp(MyApp(initialScreen: IntroScreen()));

  // runApp(MyApp(initialScreen: CarSelection()));

  //runApp(MyApp(initialScreen: EvPortSelectionScreen()));
}

class MyApp extends StatefulWidget {
  final Widget initialScreen;

  const MyApp({required this.initialScreen, Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    loggedInUser = FirebaseAuth.instance.currentUser;
    if (loggedInUser != null) {
      print('logged in');
    } else {
      print('Logged out');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: loggedInUser != null
          ? HomePage(user: loggedInUser)
          : widget.initialScreen,
    );
  }
}
