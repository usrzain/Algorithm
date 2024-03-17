// ignore_for_file: unused_field, prefer_final_fields, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'package:effecient/Screens/CS_info_Screen/polyLine_Response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:effecient/Providers/chData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:random_uuid_string/random_uuid_string.dart';

class Test3 extends StatefulWidget {
  const Test3({Key? key}) : super(key: key);

  @override
  _Test3State createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  Location _location = Location();

  Set<Marker> _markers = {}; // Set to store markers
  GoogleMapController? _mapController;
  LatLng _initialPosition = LatLng(24.8607, 67.0011);
  // for new polyline
  polyLine_Response plineResp = polyLine_Response();
  String googleAPiKey = "AIzaSyBeG5g3Ps44SleGRirPm4IcnC9BvwbLqDI";
  Set<Polyline> pPoints = {};
  // for new poly line
  bool loading = true;
  int length = 20;
  Map<String, dynamic> aLLCS = {};
  LocationData? currentLocation;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Locations");
  String rating = '4.0';
  String reviews = '(4 reviews)';
  String chargingType = 'Conductive';
  String address = '123,ABC City,XYZ Country';
  // late StreamSubscription<Event> _dataSubscription;
  late Timer _timer;
  // bool localpPoint = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 5), (timer) {
      // Check the value and update state
      if (length == 0) {
        setState(() {
          loading = false;
          _createMarkers(aLLCS);
          print(_markers);
          Provider.of<chDataProvider>(context, listen: false).loading2 = false;
          Provider.of<chDataProvider>(context, listen: false)
              .markerLoadingComplete = true;
          // print(aLLCS);
          // print(currentLocation);

          length = 20;
        });
      }

      if (length == 20) {}
    });

    readData();
  }

  @override
  void dispose() {
    _timer.cancel();
    // _dataSubscription.cancel(); // Cancel the subscription
    super.dispose();
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

          if (data == null) {
            print('No data TRANSFERED ');
          }

          if (data != null) {
            length = data.length;

            data.forEach((key, value) async {
              print('Working has been started');
              Map<String, dynamic> chargingStation = {
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
                      // print(length);
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

  // Send Function

  // send Func
  sendFun(double? clat, double? clong, double dlat, double dlong) async {
    // This is Final one
    // String url2 = 'https://server-orcin-eight.vercel.app/api/distanceandtime';
    // print(url2);

    // Just for Checking
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
  // send Function

  // Creating Markers
  void _createMarkers(CS) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(
              currentLocation?.latitude ?? 0.0,
              currentLocation?.longitude ?? 0.0,
            ),
            infoWindow: const InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarker),
      );

      for (var key in CS.keys) {
        String title = key;

        double lati = CS[key]['location'][0];
        double long = CS[key]['location'][1];
        int slotsText = CS[key]['available_slots'];
        String distance = CS[key]['distance'];
        String time = CS[key]['duration'];
        int queue = CS[key]['queue'];
        double cost = CS[key]['cost'];

        settingMarkers(
            title, lati, long, slotsText, distance, time, queue, cost);
      }
    });

    // setState(() {
    //   loading = true;
    // });
    // // for loading from provider
    // Provider.of<chDataProvider>(context, listen: false).loading2 = true;
  }
  // Creating Markers

  // Setting Markers
  settingMarkers(title, lati, long, slotsText, distance, time, queue, price) {
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
                      color: Colors.blueGrey, // Set border color to white

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
                                style: const TextStyle(
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

                          Icon(Icons.star, color: Colors.orange), // Filled star

                          Icon(Icons.star, color: Colors.orange), // Filled star

                          Icon(Icons.star, color: Colors.orange), // Filled star

                          Icon(Icons.star, color: Colors.orange), // Filled star

                          Icon(Icons.star_outline, color: Colors.white),

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
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  // Change button color based on availability

                                  return slotsText > 0
                                      ? Colors.green
                                      : Colors.red;
                                },
                              ),
                            ),
                            child: Text(
                              slotsText > 0 ? 'Available' : 'In Use',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Flexible(
                            child: Row(
                              children: [
                                Icon(Icons.directions, color: Colors.blue),
                                SizedBox(width: 4.0),
                                Text(
                                  distance,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 0.0),
                          Flexible(
                            child: Row(
                              children: [
                                Icon(Icons.directions_car, color: Colors.green),
                                SizedBox(width: 4.0),
                                Text(
                                  time,
                                  style: TextStyle(color: Colors.white),
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            Text('$price',
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
                            slotsText > 0
                                ? Icons.fiber_manual_record
                                : Icons
                                    .fiber_manual_record, // Change icon based on availability

                            color: slotsText > 0
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

                      if (slotsText == 0)

                        // Conditionally render the waiting time row

                        Row(
                          children: [
                            SizedBox(width: 5.0),
                            Icon(
                              Icons.access_time,
                              color: Colors.yellow,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              '$queue', // Replace with the actual information

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),

                      Spacer(), // Add space to push the next elements to the bottom

                      Divider(color: Colors.white),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey),
                                side: MaterialStateProperty.all<BorderSide>(
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
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
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
  }
  // Setting Markers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Example'),
      ),
      body: Stack(
        children: [
          // Consumer widget displaying content based on loading2
          Consumer<chDataProvider>(
            builder: (context, dataProvider, child) {
              return dataProvider
                      .loading2 // check either button has been pushed or not
                  ? dataProvider
                          .markerLoadingComplete // Checking Either markers has been done or not
                      ? dataProvider.polyLineDone
                          ? GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: _initialPosition,
                                zoom: 12.0,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _mapController = controller;
                              },
                              markers: _markers,
                              // setting polylines
                              polylines: pPoints,
                            )
                          : const Text('Polyline Loading ')
                      : const CircularProgressIndicator() // Show loading indicator
                  : dataProvider.markerLoadingComplete
                      ? GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: 12.0,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          markers: _markers,
                        )
                      : const CircularProgressIndicator();
              // Show loading indicator// Display message when loaded
            },
          ),
          // Right-top positioned FloatingActionButton
          Positioned(
            // Adjust top padding as needed
            child: FloatingActionButton(
              onPressed: () {
                final dataProvider = context
                    .read<chDataProvider>(); // Access provider using context
                dataProvider.loading2 = !dataProvider.loading2;
                // sending request for Best Charging Station
                requestForBestCS(
                    currentLocation?.latitude, currentLocation?.longitude, 25);
                // Setting the polyline Flag to true
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  //  Sending Request to the server for best CS
  void requestForBestCS(double? clat, double? clong, cSOC) async {
    // This is Final one
    // String url2 = 'https://server-orcin-eight.vercel.app/api/extract_parameters';
    // print(url2);

    // Just for Checking
    String url1 = 'http://127.0.0.1:5000/api/extract_parameters';
    try {
      String queryString = '';

      queryString +=
          'currentLAT=${Uri.encodeComponent(clat.toString())}&currentLONG=${Uri.encodeComponent(clong.toString())}&currentSOC=${Uri.encodeComponent(cSOC.toString())}';

      var requestUrl2 = url1 + '?' + queryString;

      var response = await http.get(Uri.parse(requestUrl2));

      if (response.statusCode == 200) {
        Map<dynamic, dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        double destLat = jsonResponse['CS']['location'][0];
        double destLong = jsonResponse['CS']['location'][1];

        drawPolyLine(currentLocation?.latitude, currentLocation?.longitude,
            destLat, destLong);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {}
  }

  // Drawing polyline
  void drawPolyLine(
      double? startLat, double? startLng, double endLat, double endLng) async {
    String URL =
        "https://maps.googleapis.com/maps/api/directions/json?key=$googleAPiKey&units=metric&origin=$startLat,$startLng&destination=$endLat,$endLng&mode=driving";

    print('THE URL IS THIS ----------------');
    print(URL);

    String url1 = 'http://127.0.0.1:5000/api/fetchPolylines';

    try {
      String queryString = '';

      queryString +=
          'cLAT=${Uri.encodeComponent(startLat.toString())}&cLONG=${Uri.encodeComponent(startLng.toString())}&dLAT=${Uri.encodeComponent(endLat.toString())}&dLONG=${Uri.encodeComponent(endLng.toString())}';

      var requestUrl2 = url1 + '?' + queryString;

      var response = await http.get(Uri.parse(requestUrl2));
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = jsonDecode(response.body);
        plineResp = polyLine_Response.fromJson((myMap));
        for (int i = 0; i < plineResp.routes![0].legs![0].steps!.length; i++) {
          pPoints.add(Polyline(
              polylineId: PolylineId(
                  plineResp.routes![0].legs![0].steps![i].polyline!.points!),
              points: [
                LatLng(
                    plineResp.routes![0].legs![0].steps![i].startLocation!.lat!,
                    plineResp
                        .routes![0].legs![0].steps![i].startLocation!.lng!),
                LatLng(
                    plineResp.routes![0].legs![0].steps![i].endLocation!.lat!,
                    plineResp.routes![0].legs![0].steps![i].endLocation!.lng!),
              ],
              width: 3,
              color: Colors.red));
        }

        print(pPoints);

        setState(() {
          Provider.of<chDataProvider>(context, listen: false).polyLineDone =
              true;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
