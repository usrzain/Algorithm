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

  Widget _buildPopup() {
    String url = 'http://127.0.0.1:5000/api/extract_parameters';
    return AlertDialog(
      title: Text('Enter Input'),
      content: TextField(
        controller: _inputController,
        decoration: InputDecoration(hintText: 'Enter your input'),
        onChanged: (value) {
          double vd = double.parse(value);
          setState(() {
            currentSOC = vd;
          });
        },
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            setState(() {
              _showPopup = false;
            });

            // sendFun();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  sendFun() async {
    String url2 = 'http://127.0.0.1:5000/api/extract_parameters';
    LocationData currentLocation = await _location.getLocation();

    try {
      String queryString = '';
      if (currentLocation.latitude != null) {
        queryString +=
            'currentLAT=${Uri.encodeComponent(currentLocation.latitude.toString())}&currentLONG=${Uri.encodeComponent(currentLocation.longitude.toString())}&currentSOC=${Uri.encodeComponent(currentSOC.toString())}';
      }

      var requestUrl2 = url2 + '?' + queryString;

      print(requestUrl2);
      var response = await http.get(Uri.parse(requestUrl2));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<double> location = List.from(jsonResponse['CS']['location']);
        int queue = jsonResponse['CS']['queue'];
        double cost = jsonResponse['CS']['cost'];
        double distance = jsonResponse['CS']['distance'];

        int available_slots = jsonResponse['CS']['available_slots'];

        // print(
        //     'Response body: ${location}, ${queue},${cost},${distance},${available_slots}');
        // Handle the response here
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending GET request: $e');
    }
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
