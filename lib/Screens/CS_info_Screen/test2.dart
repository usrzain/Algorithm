import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:effecient/Providers/chData.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:random_uuid_string/random_uuid_string.dart';
import 'package:http/http.dart' as http;

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  Location _location = Location();
  Set<Marker> _markers = {}; // Set to store markers
  GoogleMapController? _mapController;
  LatLng _initialPosition = LatLng(24.8607, 67.0011);
  String address = '123,ABC City,XYZ Country';
  String rating = '4.0';
  String reviews = '(4 reviews)';
  String chargingType = 'Conductive';
  bool loading = false;
  chDataProvider? _provider; // Store the provider reference

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    final CS =
        Provider.of<chDataProvider>(context, listen: false).chargingStations;

    _createMarkers(CS);
  }

  @override
  Widget build(BuildContext context) {
    // print('This is the Data from provider ');
    // print(chargingStations);

    return Scaffold(
      body: Stack(
        children: [
          Visibility(
            visible:
                Provider.of<chDataProvider>(context, listen: true).loading2,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
            ),
          ),

          Visibility.maintain(child: dropdown()),
          Visibility.maintain(
              child: FloatingActionButton(
            onPressed: () {
              // showModalBottomSheet(
              //   context: context,
              //   builder: (BuildContext context) {
              //     // return openFilterModal(context, 0.0, 0.0);
              //     return null;
              //   },
              // );
            },
            tooltip: 'Filter',
            child: const Icon(Icons.filter_list),
          )),

          Visibility(
            visible:
                !Provider.of<chDataProvider>(context, listen: true).loading2,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // Additional widgets can be added based on your requirements
        ],
      ),
    );
  }

  // Creating Markers
  void _createMarkers(CS) async {
    // Create markers from aLLCS
    LocationData CL = await _location.getLocation();
    // Getting CHarging Stations from the Provider

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(
              CL.latitude ?? 0.0,
              CL.longitude ?? 0.0,
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

  dropdown() {
    return Container(
      height: 25,
      color: Colors.lightGreen,
      width: 100,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Icon(
                Icons.list,
                size: 16,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 160,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.redAccent,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.yellow,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.redAccent,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
