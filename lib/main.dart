// ignore_for_file: file_names, library_private_types_in_public_api, unused_element

import 'package:effecient/Auth/HomePage.dart';
import 'package:effecient/Auth/loginPage.dart';
import 'package:effecient/Auth/nextScreen.dart';
import 'package:effecient/Providers/chData.dart';
import 'package:effecient/Screens/CS_info_Screen/extraFun.dart';
import 'package:effecient/Screens/Intro/intro_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _hasSeenIntroSignupKey = false;

  @override
  void initState() {
    super.initState();
    checkFirstTime();
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
        home: Stack(
          children: [
            Consumer<chDataProvider>(builder: (context, dataProvider, child) {
              return dataProvider.initialLoadingComplete
                  ? dataProvider.hasSeenTheIntro
                      ? loggedInUser != null
                          ? HomePage(user: loggedInUser)
                          : widget.initialScreen
                      : const IntroScreen()
                  : loadingWidget(context, "Initial Screen");
            })
          ],
        )

        // loggedInUser != null
        //     ? HomePage(user: loggedInUser)
        //     : widget.initialScreen,
        );
  }

  Future<void> checkFirstTime() async {
    final SharedPreferences prefs = await _prefs;
    print('I am watching the Intro thing ');
    if (prefs.get('_hasSeenIntroSignupKey') != null) {
      // It shows that user has seen the Intro
      _hasSeenIntroSignupKey = true;
      Provider.of<chDataProvider>(context, listen: false).hasSeenTheIntro =
          true;
      Provider.of<chDataProvider>(context, listen: false)
          .initialLoadingComplete = true;
    } else {
      _hasSeenIntroSignupKey = false;
      Provider.of<chDataProvider>(context, listen: false).hasSeenTheIntro =
          false;
      Provider.of<chDataProvider>(context, listen: false)
          .initialLoadingComplete = true;
      // prefs.setBool('_hasSeenIntroSignupKey', false);
    }
  }
}
