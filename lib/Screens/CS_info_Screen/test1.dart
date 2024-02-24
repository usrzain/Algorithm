import 'dart:convert';
// import 'dart:ffi';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:effecient/Screens/CS_info_Screen/functions.dart';
import 'package:effecient/Screens/CS_info_Screen/mapScreen.dart';
import 'package:effecient/Screens/CS_info_Screen/test2.dart';
import 'package:random_uuid_string/random_uuid_string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class Test1 extends StatefulWidget {
  const Test1({Key? key}) : super(key: key);

  @override
  _Test1State createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  Location _location = Location();
  bool loading = true;
  int length = 20;
  Map<dynamic, dynamic> aLLCS = {};
  LocationData? currentLocation;

  DatabaseReference ref = FirebaseDatabase.instance.ref("Locations");

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Check the value and update state
      if (length == 0) {
        print(currentLocation);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => Test2(
        //           chargingStations: aLLCS, currentLocation: currentLocation)),
        // );
        setState(() {
          loading = false;
          length = 1;
        });
      }
    });
    readData();
  }

  Future<void> readData() async {
    try {
      // Fetch current location
      LocationData CL = await _location.getLocation();
      setState(() {
        currentLocation = CL;
      });

      // Fetch data from the database

      ref.onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.value != null) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          print('fetched data is = ');
          print(data);
          if (data == null) {
            print('No data TRANSFERED ');
          }

          if (data != null) {
            length = data.length;
            print(length);
            data.forEach((key, value) async {
              Map<dynamic, dynamic> chargingStation = {
                'available_slots': 2,
                'cost': 2.83,
                'distance': 5.5,
                'location': [24.89627, 67.06616],
                'queue': 0,
                'duration': 0
              };
              List<double> location = List<double>.from(value['location']);
              chargingStation['location'] = value['location'];
              chargingStation['available_slots'] = value['available_slots'];
              chargingStation['cost'] = value['cost'];
              chargingStation['queue'] = value['queue'];

              // Accessing inner values of location
              double latitude = location[0];
              double longitude = location[1];

              double? lati = latitude;
              double? long = longitude;
              double? cLat = CL.latitude;
              double? cLong = CL.longitude;

              await sendFun(cLat, cLong, lati, long).then((value1) => {
                    chargingStation['distance'] = value1['distanceText'],
                    chargingStation['duration'] = value1['durationText'],

                    setState(() {
                      aLLCS[key] = chargingStation;
                      length = length - 1;
                      print(length);
                    }),
                    // print(chargingStation),
                  });
            });
          }
        } else {}
      });
    } catch (e) {
      // Handle errors for both getting current location and fetching data
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: loading
              ? CircularProgressIndicator()
              : Test2(
                  chargingStations: aLLCS, currentLocation: currentLocation)),
    );
    // body: Center(child: CircularProgressIndicator()));
  }

  // Navigation function
  void Navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
  }
// Navigation Function

  // send Func
  sendFun(double? clat, double? clong, double dlat, double dlong) async {
    String url2 = 'http://127.0.0.1:5000/api/distanceandtime';

    try {
      String queryString = '';

      queryString +=
          'cLAT=${Uri.encodeComponent(clat.toString())}&cLONG=${Uri.encodeComponent(clong.toString())}&dLAT=${Uri.encodeComponent(dlat.toString())}&dLONG=${Uri.encodeComponent(dlong.toString())}';

      var requestUrl2 = url2 + '?' + queryString;

      var response = await http.get(Uri.parse(requestUrl2));
      if (response.statusCode == 200) {
        Map<dynamic, dynamic> jsonResponse = jsonDecode(response.body);

        String distanceText =
            jsonResponse["data"]["rows"][0]["elements"][0]["distance"]["text"];

        String durationText =
            jsonResponse["data"]["rows"][0]["elements"][0]["duration"]["text"];

        return {'distanceText': distanceText, 'durationText': durationText};
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending GET request: $e');
    }
  }
  // send Func
}
