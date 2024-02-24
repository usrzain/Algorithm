// ignore_for_file: avoid_print, unused_field, prefer_const_constructors, prefer_final_fields,    library_private_types_in_public_api

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:effecient/Screens/CS_info_Screen/functions.dart';
import 'package:random_uuid_string/random_uuid_string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Location _location = Location();
  Set<Marker> _markers = {};

  LatLng _initialPosition = LatLng(24.8607, 67.0011);
  //change conductive to inductive as required
  String address = '123,ABC City,XYZ Country';
  String rating = '4.0';
  String reviews = '(4 reviews)';
  String chargingType = 'Conductive';
  String slotsText = '0'; // Initial number of available slots
  String price = '150 Rs/kwh';
  String? distance;
  String? time;
  String waitTime = '30 mins';

  // Create a Variable for Loading

  bool loading = false;

  DatabaseReference ref = FirebaseDatabase.instance.ref("Locations");

  @override
  void initState() {
    super.initState();
    readData();
  }

  // -------------  Read Data
  Future<void> readData() async {
    try {
      // Fetch current location
      LocationData currentLocation = await _location.getLocation();
      // print('kdvn edinvekvnevneivne');
      // print(currentLocation);

      // Fetch data from the database

      ref.onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.value != null) {
          // Accessing data using key-value pairs
          // print(snapshot
          //     .value.runtimeType); // type comes as _Map<Object?, Object?>
          // print(snapshot.value);
          // Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          // print(data.runtimeType);
          // print('fetched data is = ');
          // print(data);
          if (data == null) {
            print('No data TRANSFERED ');
          }

          if (data != null) {
            // print('data : ');
            // print(data);
            setState(() async {
              _markers.clear();

              // Add marker for the current location
              _markers.add(
                Marker(
                    markerId: const MarkerId('current_location'),
                    position: LatLng(
                      currentLocation.latitude ?? 0.0,
                      currentLocation.longitude ?? 0.0,
                    ),
                    infoWindow: const InfoWindow(title: 'Your Location'),
                    icon: BitmapDescriptor.defaultMarker),
              );

              // Add markers for locations from the database
              data.forEach((key, value) async {
                // print('DATA VALUES ---------');

                // print(value);
                String title = key;
                String address = title;
                // Accessing location
                List<double> location = List<double>.from(value['location']);
                // Accessing inner values of location
                double latitude = location[0];
                double longitude = location[1];
                // Accessing distance
                // double distance = value['distance'];
                // Calculating Distance and Time

                //  Converting the String values of latitude and Longitudes to double data type
                double lati;
                double long;
                double? cLat;
                double? cLong;

                // if (latitude.runtimeType == String ||
                //     longitude.runtimeType == String) {
                //   lati = double.parse(longitude);
                //   long = double.parse(longitude);

                // } else {
                lati = latitude;
                long = longitude;
                cLat = currentLocation.latitude;
                cLong = currentLocation.longitude;

                await sendFun(cLat, cLong, lati, long).then((value) => {
                      setState(() {
                        distance = value["distanceText"];

                        time = value["durationText"];

                        print(distance);
                        print(time);
                      })
                    });

                // await getDistanceAndTimeT(
                //         destinationLatitude: lati,
                //         destinationLongitude: long,
                //         originLatitude: cLat,
                //         originLongitude: cLong)
                //     .then((value) => print(value));
                // .then((value) => print(value));

                // final apiurl =
                //     'https://maps.googleapis.com/maps/api/distancematrix/json?departure_time=now&destinations=$lati,$long&origins=$cLat,$cLong&key=$apiKey';

                // }

                _markers.add(
                  Marker(
                    markerId: MarkerId(RandomString.randomString(length: 10)),
                    position: LatLng(lati, long),
                    infoWindow: InfoWindow(title: title),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                              height: 400, // Adjust the height as needed
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                border: Border.all(
                                  color: Colors
                                      .blueGrey, // Set border color to white
                                  width: 2.0, // Set border width as needed
                                ),
                              ),
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.bold,
                                              height: 0.9,
                                            ),
                                            maxLines: 2,
                                            // Set the maximum number of lines
                                            overflow: TextOverflow.ellipsis,
                                            maxFontSize: 26.0),
                                      ),
                                      // Add other widgets if needed
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(address,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              height: 0.9,
                                            ),
                                            maxLines: 2,
                                            // Set the maximum number of lines
                                            overflow: TextOverflow.ellipsis,
                                            maxFontSize: 16.0),
                                      ),
                                      // Add other widgets if needed
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        rating,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(width: 5.0),
                                      Icon(Icons.star,
                                          color: Colors.orange), // Filled star
                                      Icon(Icons.star,
                                          color: Colors.orange), // Filled star
                                      Icon(Icons.star,
                                          color: Colors.orange), // Filled star
                                      Icon(Icons.star,
                                          color: Colors.orange), // Filled star
                                      Icon(Icons.star_outline,
                                          color: Colors.white),
                                      SizedBox(width: 5.0),
                                      Text(
                                        reviews,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16.0,
                                        ),
                                      ), // Empty star
                                    ],
                                  ),

                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Add functionality for the button
                                          // For example, you can navigate to a different screen or perform an action
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              // Change button color based on availability
                                              return int.parse(slotsText) > 0
                                                  ? Colors.green
                                                  : Colors.red;
                                            },
                                          ),
                                        ),
                                        child: Text(
                                          int.parse(slotsText) > 0
                                              ? 'Available'
                                              : 'In Use',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15.0),
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Icon(Icons.directions,
                                                color: Colors.blue),
                                            SizedBox(width: 4.0),
                                            Text(
                                              distance.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 0.0),
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Icon(Icons.directions_car,
                                                color: Colors.green),
                                            SizedBox(width: 4.0),
                                            Text(
                                              time.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Divider(color: Colors.white),
                                  SizedBox(height: 8.0),
                                  // Initial charging type

                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 5.0),
                                        Icon(
                                          chargingType == 'Conductive'
                                              ? Icons.ev_station_outlined
                                              : Icons.wifi_tethering_outlined,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          chargingType, // Replace with the actual charger information
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Icon(
                                          Icons.monetization_on,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(price,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            )),
                                      ],
                                    ),
                                  ),

                                  // ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 5.0),
                                      Icon(
                                        int.parse(slotsText) > 0
                                            ? Icons.fiber_manual_record
                                            : Icons
                                                .fiber_manual_record, // Change icon based on availability
                                        color: int.parse(slotsText) > 0
                                            ? Colors.green
                                            : Colors
                                                .red, // Change color based on availability
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'Slots Available is', // Replace with the actual charger information
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Row(
                                        children: [
                                          Text(
                                            '" $slotsText', // Use the variable for the number of available slots
                                            style: TextStyle(
                                              fontFamily: 'Raleway',
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          // Button indicating availability status

                                          Text(
                                            'out of 3 "', // Replace with the actual charger information
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  if (int.parse(slotsText) ==
                                      0) // Conditionally render the waiting time row
                                    Row(
                                      children: [
                                        SizedBox(width: 5.0),
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.yellow,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'Wait Time is', // Replace with the actual information
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          waitTime, // Replace with the actual waiting time information
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),

                                  Spacer(), // Add space to push the next elements to the bottom
                                  Divider(color: Colors.white),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Add functionality for the Cancel button
                                            Navigator.of(context)
                                                .pop(); // Close the bottom sheet
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.grey),
                                            side: MaterialStateProperty.all<
                                                BorderSide>(
                                              BorderSide(color: Colors.blue),
                                            ),
                                          ),
                                          child: Text(
                                            'Cancel', // Replace with the actual waiting time information
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              10.0), // Adjust the spacing between buttons
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Add functionality for the Navigate button
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green),
                                          ),
                                          child: Text(
                                            'Navigate',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        },
                      );
                    },
                  ),
                );
              });

              //  when all markers are being set , now set the loading value true
            });

            print(_markers);

            setState(() {
              loading = true;
            });
          }
        } else {
          // Handle the case where snapshot.value is null
          print("Data is null");
        }
      });
    } catch (e) {
      // Handle errors for both getting current location and fetching data
      print("Error: $e");
    }
  }

  // --------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Visibility(
              visible: loading,
              child: Stack(
                children: [
                  Positioned(top: 20, right: 20, child: Text('helo')),
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 20.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    markers: _markers,
                  ),
                ],
              )),
          Visibility(
            visible: !loading,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // Additional widgets can be added based on your requirements
        ],
      ),
    );
  }

  // send func

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

  // send func
}
