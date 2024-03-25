// ignore_for_file: file_names, library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';
import 'package:effecient/navBar/colors/colors.dart';
import 'package:effecient/navBar/font.dart';
import 'package:effecient/navBar/navBar.dart';
import 'package:effecient/tab_contents.dart';

//import 'package:effecient/Auth/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
// import 'tab_contents.dart';
//import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User? user;

  //const HomePage({Key? key}) : super(key: key);
  const HomePage({Key? key, required this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectBtn = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: navBtn.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectBtn = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          if (_tabController.index == 0) Tab1Content(),
          if (_tabController.index == 1) Tab2Content(),
          if (_tabController.index == 2) Tab3Content(),
          if (_tabController.index == 3) Tab4Content(user: widget.user),
          if (_tabController.index == 4) Tab5Content(user: widget.user),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: navigationBar(),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await FirebaseAuth.instance.signOut();
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const LoginPage()),
      //     );
      //   },
      //   child: Icon(Icons.arrow_forward),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }

  AnimatedContainer navigationBar() {
    double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      height: 70.0,
      duration: const Duration(milliseconds: 20),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(selectBtn == 0 ? 0.0 : 20.0),
          topRight:
              Radius.circular(selectBtn == navBtn.length - 1 ? 0.0 : 20.0),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < navBtn.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() => selectBtn = i);
                  _tabController.animateTo(i);
                },
                child: iconBtn(i, screenWidth),
              ),
          ],
        ),
      ),
    );
  }

  SizedBox iconBtn(int i, double screenWidth) {
    bool isActive = selectBtn == i ? true : false;
    double tabWidth = screenWidth / navBtn.length;

    return SizedBox(
      width: tabWidth,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: FractionalTranslation(
              translation: Offset(
                0,
                isActive ? -0.2 : 0,
              ),
              child: navBtn[i].iconOrImagePath is IconData
                  ? Icon(
                      navBtn[i].iconOrImagePath,
                      color: isActive ? selectColor : white,
                    )
                  : Image.asset(
                      navBtn[i].iconOrImagePath,
                      color: isActive ? selectColor : white,
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionalTranslation(
              translation: Offset(
                0,
                isActive ? -0.2 : 0,
              ),
              child: Text(
                navBtn[i].name,
                style:
                    isActive ? bntText.copyWith(color: selectColor) : bntText,
              ),
            ),
          ),
          if (isActive)
            Positioned(
              top: 2,
              left: 20,
              right: 20,
              child: Container(
                height: 5,
                color: bgColor,
              ),
            ),
        ],
      ),
    );
  }
}

// class NextScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Next Screen'),
//       ),
//       body: Center(
//         child: Text('This is the next screen!'),
//       ),
//     );
//   }
// }

class TabContent extends StatelessWidget {
  final String title;

  const TabContent({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
