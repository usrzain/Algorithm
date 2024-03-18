// ignore_for_file: unused_field, prefer_final_fields, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:effecient/Screens/CS_info_Screen/extraFun.dart';
import 'package:effecient/Screens/CS_info_Screen/polyLine_Response.dart';
import 'package:effecient/Screens/CS_info_Screen/test2.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:effecient/Providers/chData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:random_uuid_string/random_uuid_string.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:maps_launcher/maps_launcher.dart';

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
  String googleAPiKey = "AIzaSyCtDSgmH1koRCq9tU3zqf4T5tzsISG3nNY";
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
  String? selectedValue;
  bool locationPermission = false;
  late final customIcon;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  // bool localpPoint = false;

  @override
  void initState() {
    addCustomIcon();
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 5), (timer) {
      // Check the value and update state
      if (length == 0) {
        setState(() {
          loading = false;
          _createMarkers(aLLCS);

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

  // Creating Icon for markers

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/Intro/charging-station.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  //

  Future<void> readData() async {
    try {
      // Making icon for marker
      final customIcon2 =
          await getCustomIcon('assets/Intro/charging-station.png');

      // Fetch current location
      LocationData CL = await _location.getLocation();

      print('working ');
      setState(() {
        currentLocation = CL;
        _initialPosition = LatLng(CL.latitude ?? 0.0, CL.longitude ?? 0.0);
        customIcon = customIcon2;
      });
      print(currentLocation.runtimeType);
      print(_initialPosition.runtimeType);

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
    String url2 = 'https://server-orcin-eight.vercel.app/api/distanceandtime';
    // print(url2);

    // Just for Checking
    // String url2 = 'http://127.0.0.1:5000/api/distanceandtime';

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
    bool bToggle = true;
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
          icon: BitmapDescriptor.defaultMarkerWithHue(
              // ignore: dead_code
              (bToggle)
                  ? BitmapDescriptor.hueYellow
                  : BitmapDescriptor.hueAzure),
        ),
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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
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
                                ' $slotsText', // Use the variable for the number of available slots

                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),

                              SizedBox(width: 5.0),

                              // Button indicating availability status
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
                                MapsLauncher.launchCoordinates(
                                    lati, long, 'Google Headquarters are here');
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
                          ? Stack(
                              children: [
                                GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: _initialPosition,
                                    zoom: 12.0,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _mapController = controller;
                                  },
                                  markers: Provider.of<chDataProvider>(context,
                                          listen: false)
                                      .markers,
                                  // setting polylines
                                  polylines: Provider.of<chDataProvider>(
                                          context,
                                          listen: false)
                                      .pPoints,
                                ),
                                Positioned(
                                    top: 20.0, // Adjust top padding
                                    left: 20.0, // Adjust left padding
                                    child: Text(
                                        ' Your calculated range is ${dataProvider.range}')),
                              ],
                            )
                          : loadingWidget(context, 'Polylines')
                      : loadingWidget(
                          context, 'Markers') // Show loading indicator
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
                      : loadingWidget(context, 'Markers');
              // Show loading indicator// Display message when loaded
            },
          ),

          Positioned(
              top: 16.0, // Adjust margin as needed
              left: 16.0, // Adjust horizontal margin as needed
              child: Consumer<chDataProvider>(
                  builder: (context, dataProvider, child) {
                return dataProvider.showReset
                    ? FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            pPoints = {};
                          });
                          Provider.of<chDataProvider>(context, listen: false)
                              .pPoints = {};
                          Provider.of<chDataProvider>(context, listen: false)
                              .polyLineDone = false;
                          Provider.of<chDataProvider>(context, listen: false)
                              .loading2 = false;
                          Provider.of<chDataProvider>(context, listen: false)
                              .stateOfCharge = null;
                          Provider.of<chDataProvider>(context, listen: false)
                              .vehBrand = null;
                          Provider.of<chDataProvider>(context, listen: false)
                              .vehModel = null;
                          Provider.of<chDataProvider>(context, listen: false)
                              .showReset = false;
                        },
                        child: const Text('Reset'),
                      )
                    : FloatingActionButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  content: openFilterModal(
                                      context,
                                      currentLocation?.latitude,
                                      currentLocation?.longitude)));
                        },
                        child: const Text('Filter'),
                      );
              }))
        ],
      ),
    );
  }

  Widget loadingWidget(BuildContext context, String text) {
    return Stack(
      children: [
        Container(
            alignment: Alignment.center, child: CircularProgressIndicator()),
        Container(alignment: Alignment.center, child: Text('$text is loading '))
      ],
    );
  }

  Widget openFilterModal(
      BuildContext context, double? currentLAT, double? currentLONG) {
    int? userInput;
    String? selectedTitle = '';
    String? selectedSecondTitle = '';

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Input:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      userInput = int.parse(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter input here',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Select Brand :',
                  style: TextStyle(fontSize: 18),
                ),
                Wrap(
                  children: [
                    // Generate chip tiles for titles
                    ChoiceChip(
                      label: Text('BMW'),
                      selected: selectedTitle == 'BMW',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedTitle = isSelected ? 'BMW' : '';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text('Honda'),
                      selected: selectedTitle == 'Honda',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedTitle = isSelected ? 'Honda' : '';
                        });
                      },
                    ),

                    ChoiceChip(
                      label: Text('Tesla'),
                      selected: selectedTitle == 'Tesla',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedTitle = isSelected ? 'Tesla' : '';
                        });
                      },
                    ),
                    // Add more chip tiles as needed
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Select Model:',
                  style: TextStyle(fontSize: 18),
                ),
                Wrap(
                  children: [
                    // Generate chip tiles for second titles
                    ChoiceChip(
                      label: Text('2018'),
                      selected: selectedSecondTitle == '2018',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedSecondTitle = isSelected ? '2018' : '';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text('2019'),
                      selected: selectedSecondTitle == '2019',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedSecondTitle = isSelected ? '2019' : '';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text('2020'),
                      selected: selectedSecondTitle == '2020',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedSecondTitle = isSelected ? '2020' : '';
                        });
                      },
                    )
                    // Add more chip tiles as needed
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Making it false to show the loading.....
                    // Provider.of<chDataProvider>(context, listen: false).loading2 =
                    //     false;

                    // Do something with userInput, selectedTitle, selectedSecondTitle
                    if (userInput != null &&
                        selectedTitle != null &&
                        selectedSecondTitle != null) {
                      Navigator.pop(context);
                      Provider.of<chDataProvider>(context, listen: false)
                          .showReset = true;
                      Provider.of<chDataProvider>(context, listen: false)
                          .stateOfCharge = userInput;
                      Provider.of<chDataProvider>(context, listen: false)
                          .vehBrand = selectedTitle;
                      Provider.of<chDataProvider>(context, listen: false)
                          .vehModel = selectedSecondTitle;

                      final dataProvider = context.read<
                          chDataProvider>(); // Access provider using context

                      // Calculating the Range

                      List<Map<String, dynamic>> electricVehicles = [
                        {'brand': 'BMW', 'model': '2019', 'range': 50.0},
                        {'brand': 'Honda', 'model': '2018', 'range': 40.0},
                        {'brand': 'Tesla', 'model': '2020', 'range': 60.0},
                      ];

                      double totalRange = 0.0;

                      for (var vehicle in electricVehicles) {
                        // finding the Brand and get the total Range of it

                        if (selectedTitle == vehicle['brand']) {
                          totalRange = vehicle['range'];
                        }
                      }

                      double calculate_Range = userInput! / 100 * totalRange;

                      dataProvider.range = calculate_Range;

                      dataProvider.loading2 = true;
                      requestForBestCS(currentLAT, currentLONG, userInput,
                          selectedTitle, selectedSecondTitle);
                    } else {}

                    // Update loading2 within the Future
                    // fetchData();

                    // waiting for 2 seconds
                    // await Future.delayed(const Duration(seconds: 2));
                    // again making loading to true to show the output
                  },
                  child: Text('Apply'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //  Sending Request to the server for best CS
  void requestForBestCS(double? clat, double? clong, cSOC, String? vehBrand,
      String? vehModel) async {
    // This is Final one
    // String url2 = 'https://server-orcin-eight.vercel.app/api/extract_parameters';
    // print(url2);

    // Just for Checking
    // String url1 = 'http://127.0.0.1:5000/api/extract_parameters';
    String url1 =
        'https://server-orcin-eight.vercel.app/api/extract_parameters';
    try {
      String queryString = '';

      queryString +=
          'currentLAT=${Uri.encodeComponent(clat.toString())}&currentLONG=${Uri.encodeComponent(clong.toString())}&currentSOC=${Uri.encodeComponent(cSOC.toString())}&vehBrand=${Uri.encodeComponent(vehBrand!)}&vehModel=${Uri.encodeComponent(vehModel!)}';

      var requestUrl2 = url1 + '?' + queryString;

      var response = await http.get(Uri.parse(requestUrl2));

      if (response.statusCode == 200) {
        Map<dynamic, dynamic> jsonResponse = jsonDecode(response.body);

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
    // String url1 = 'http://127.0.0.1:5000/api/fetchPolylines';
    String url1 = 'https://server-orcin-eight.vercel.app/api/fetchPolylines';

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

        setState(() {
          Provider.of<chDataProvider>(context, listen: false).markers =
              _markers;
          Provider.of<chDataProvider>(context, listen: false).pPoints = pPoints;
          Provider.of<chDataProvider>(context, listen: false).polyLineDone =
              true;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
