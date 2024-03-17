// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:effecient/Screens/CS_info_Screen/test1.dart';
import 'package:effecient/Screens/CS_info_Screen/test3.dart';
import 'package:effecient/Screens/profile.dart';
import 'package:effecient/Screens/CS_info_Screen/mapScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';

class Tab1Content extends StatefulWidget {
  @override
  _Tab1ContentState createState() => _Tab1ContentState();
}

class _Tab1ContentState extends State<Tab1Content> {
  TextEditingController _inputController = TextEditingController();
  double currentSOC = 0.0;
  bool _showPopup = true;
  Location _location = Location();

  @override
  Widget build(BuildContext context) {
    // return Center(child: _showPopup ? _buildPopup() : MapScreen());
    // Just for checking Test1
    return Center(child: Test3());
  }
}

class Tab2Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.green, // Color for Tab 2
        child: Text('Tab 2 Content', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class Tab3Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue, // Color for Tab 3
        child: Text('Tab 3 Content', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class Tab4Content extends StatelessWidget {
  final User? user;

  const Tab4Content({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue, // Color for Tab 3
        child: Text('Tab 4 Content', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ----------------

class Tab5Content extends StatelessWidget {
  final User? user;

  const Tab5Content({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Profile(user: user),
    );
  }
}
