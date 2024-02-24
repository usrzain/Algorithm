    // showModalBottomSheet<void>(
    //                         context: context,
    //                         isScrollControlled: true,
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.only(
    //                             topLeft: Radius.circular(20.0),
    //                             topRight: Radius.circular(20.0),
    //                           ),
    //                         ),
    //                         builder: (BuildContext context) {
    //                           return Container(
    //                               height: 400, // Adjust the height as needed
    //                               decoration: BoxDecoration(
    //                                 color: Colors.black87,
    //                                 borderRadius: BorderRadius.only(
    //                                   topLeft: Radius.circular(20.0),
    //                                   topRight: Radius.circular(20.0),
    //                                 ),
    //                                 border: Border.all(
    //                                   color: Colors
    //                                       .blueGrey, // Set border color to white
    //                                   width: 2.0, // Set border width as needed
    //                                 ),
    //                               ),
    //                               padding: EdgeInsets.all(16.0),
    //                               child: Column(
    //                                 crossAxisAlignment: CrossAxisAlignment.stretch,
    //                                 children: <Widget>[
    //                                   Row(
    //                                     mainAxisAlignment: MainAxisAlignment.start,
    //                                     children: [
    //                                       Flexible(
    //                                         child: AutoSizeText(title,
    //                                             style: TextStyle(
    //                                               color: Colors.white,
    //                                               fontSize: 26.0,
    //                                               fontWeight: FontWeight.bold,
    //                                               height: 0.9,
    //                                             ),
    //                                             maxLines: 2,
    //                                             // Set the maximum number of lines
    //                                             overflow: TextOverflow.ellipsis,
    //                                             maxFontSize: 26.0),
    //                                       ),
    //                                       // Add other widgets if needed
    //                                     ],
    //                                   ),
    //                                   SizedBox(height: 8.0),
    //                                   Row(
    //                                     mainAxisAlignment: MainAxisAlignment.start,
    //                                     children: [
    //                                       Flexible(
    //                                         child: AutoSizeText(address,
    //                                             style: TextStyle(
    //                                               color: Colors.white70,
    //                                               fontSize: 16.0,
    //                                               fontWeight: FontWeight.bold,
    //                                               height: 0.9,
    //                                             ),
    //                                             maxLines: 2,
    //                                             // Set the maximum number of lines
    //                                             overflow: TextOverflow.ellipsis,
    //                                             maxFontSize: 16.0),
    //                                       ),
    //                                       // Add other widgets if needed
    //                                     ],
    //                                   ),
    //                                   SizedBox(height: 5.0),
    //                                   Row(
    //                                     mainAxisAlignment: MainAxisAlignment.start,
    //                                     children: [
    //                                       Text(
    //                                         rating,
    //                                         style: TextStyle(
    //                                           color: Colors.white70,
    //                                           fontSize: 16.0,
    //                                         ),
    //                                       ),
    //                                       SizedBox(width: 5.0),
    //                                       Icon(Icons.star,
    //                                           color: Colors.orange), // Filled star
    //                                       Icon(Icons.star,
    //                                           color: Colors.orange), // Filled star
    //                                       Icon(Icons.star,
    //                                           color: Colors.orange), // Filled star
    //                                       Icon(Icons.star,
    //                                           color: Colors.orange), // Filled star
    //                                       Icon(Icons.star_outline,
    //                                           color: Colors.white),
    //                                       SizedBox(width: 5.0),
    //                                       Text(
    //                                         reviews,
    //                                         style: TextStyle(
    //                                           color: Colors.white70,
    //                                           fontSize: 16.0,
    //                                         ),
    //                                       ), // Empty star
    //                                     ],
    //                                   ),

    //                                   SizedBox(height: 5.0),
    //                                   Row(
    //                                     mainAxisAlignment: MainAxisAlignment.start,
    //                                     children: [
    //                                       ElevatedButton(
    //                                         onPressed: () {
    //                                           // Add functionality for the button
    //                                           // For example, you can navigate to a different screen or perform an action
    //                                         },
    //                                         style: ButtonStyle(
    //                                           backgroundColor: MaterialStateProperty
    //                                               .resolveWith<Color>(
    //                                             (Set<MaterialState> states) {
    //                                               // Change button color based on availability
    //                                               return int.parse(slotsText) > 0
    //                                                   ? Colors.green
    //                                                   : Colors.red;
    //                                             },
    //                                           ),
    //                                         ),
    //                                         child: Text(
    //                                           int.parse(slotsText) > 0
    //                                               ? 'Available'
    //                                               : 'In Use',
    //                                           style: TextStyle(
    //                                             color: Colors.white,
    //                                           ),
    //                                         ),
    //                                       ),
    //                                       SizedBox(width: 15.0),
    //                                       Flexible(
    //                                         child: Row(
    //                                           children: [
    //                                             Icon(Icons.directions,
    //                                                 color: Colors.blue),
    //                                             SizedBox(width: 4.0),
    //                                             Text(
    //                                               'distance',
    //                                               style: TextStyle(
    //                                                   color: Colors.white),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       SizedBox(width: 0.0),
    //                                       Flexible(
    //                                         child: Row(
    //                                           children: [
    //                                             Icon(Icons.directions_car,
    //                                                 color: Colors.green),
    //                                             SizedBox(width: 4.0),
    //                                             Text(
    //                                               time,
    //                                               style: TextStyle(
    //                                                   color: Colors.white),
    //                                               overflow: TextOverflow.ellipsis,
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),

    //                                   Divider(color: Colors.white),
    //                                   SizedBox(height: 8.0),
    //                                   // Initial charging type

    //                                   Flexible(
    //                                     child: Row(
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.start,
    //                                       children: [
    //                                         SizedBox(width: 5.0),
    //                                         Icon(
    //                                           chargingType == 'Conductive'
    //                                               ? Icons.ev_station_outlined
    //                                               : Icons.wifi_tethering_outlined,
    //                                           color: Colors.blue,
    //                                         ),
    //                                         SizedBox(width: 5.0),
    //                                         Text(
    //                                           chargingType, // Replace with the actual charger information
    //                                           style: TextStyle(
    //                                             color: Colors.white70,
    //                                             fontSize: 16.0,
    //                                           ),
    //                                         ),
    //                                         SizedBox(
    //                                           width: 50,
    //                                         ),
    //                                         Icon(
    //                                           Icons.monetization_on,
    //                                           color: Colors.green,
    //                                         ),
    //                                         SizedBox(width: 5.0),
    //                                         Text(price,
    //                                             style: TextStyle(
    //                                               color: Colors.white,
    //                                               fontSize: 16.0,
    //                                             )),
    //                                       ],
    //                                     ),
    //                                   ),

    //                                   // ),
    //                                   SizedBox(height: 8.0),
    //                                   Row(
    //                                     mainAxisAlignment: MainAxisAlignment.start,
    //                                     children: [
    //                                       SizedBox(width: 5.0),
    //                                       Icon(
    //                                         int.parse(slotsText) > 0
    //                                             ? Icons.fiber_manual_record
    //                                             : Icons
    //                                                 .fiber_manual_record, // Change icon based on availability
    //                                         color: int.parse(slotsText) > 0
    //                                             ? Colors.green
    //                                             : Colors
    //                                                 .red, // Change color based on availability
    //                                       ),
    //                                       SizedBox(width: 5.0),
    //                                       Text(
    //                                         'Slots Available is', // Replace with the actual charger information
    //                                         style: TextStyle(
    //                                           color: Colors.white70,
    //                                           fontSize: 16.0,
    //                                         ),
    //                                       ),
    //                                       SizedBox(width: 10.0),
    //                                       Row(
    //                                         children: [
    //                                           Text(
    //                                             '" $slotsText', // Use the variable for the number of available slots
    //                                             style: TextStyle(
    //                                               fontFamily: 'Raleway',
    //                                               color: Colors.white,
    //                                               fontSize: 16.0,
    //                                             ),
    //                                           ),
    //                                           SizedBox(width: 5.0),
    //                                           // Button indicating availability status

    //                                           Text(
    //                                             'out of 3 "', // Replace with the actual charger information
    //                                             style: TextStyle(
    //                                               color: Colors.white,
    //                                               fontSize: 16.0,
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ],
    //                                   ),

    //                                   if (int.parse(slotsText) ==
    //                                       0) // Conditionally render the waiting time row
    //                                     Row(
    //                                       children: [
    //                                         SizedBox(width: 5.0),
    //                                         Icon(
    //                                           Icons.access_time,
    //                                           color: Colors.yellow,
    //                                         ),
    //                                         SizedBox(width: 5.0),
    //                                         Text(
    //                                           'Wait Time is', // Replace with the actual information
    //                                           style: TextStyle(
    //                                             color: Colors.white70,
    //                                             fontSize: 16.0,
    //                                           ),
    //                                         ),
    //                                         SizedBox(width: 5.0),
    //                                         Text(
    //                                           waitTime, // Replace with the actual waiting time information
    //                                           style: TextStyle(
    //                                             color: Colors.white,
    //                                             fontSize: 16.0,
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),

    //                                   Spacer(), // Add space to push the next elements to the bottom
    //                                   Divider(color: Colors.white),
    //                                   Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceEvenly,
    //                                     children: [
    //                                       Expanded(
    //                                         child: ElevatedButton(
    //                                           onPressed: () {
    //                                             // Add functionality for the Cancel button
    //                                             Navigator.of(context)
    //                                                 .pop(); // Close the bottom sheet
    //                                           },
    //                                           style: ButtonStyle(
    //                                             backgroundColor:
    //                                                 MaterialStateProperty.all<
    //                                                     Color>(Colors.grey),
    //                                             side: MaterialStateProperty.all<
    //                                                 BorderSide>(
    //                                               BorderSide(color: Colors.blue),
    //                                             ),
    //                                           ),
    //                                           child: Text(
    //                                             'Cancel', // Replace with the actual waiting time information
    //                                             style: TextStyle(
    //                                               color: Colors.white,
    //                                               fontSize: 16.0,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                       SizedBox(
    //                                           width:
    //                                               10.0), // Adjust the spacing between buttons
    //                                       Expanded(
    //                                         child: ElevatedButton(
    //                                           onPressed: () {
    //                                             // Add functionality for the Navigate button
    //                                           },
    //                                           style: ButtonStyle(
    //                                             backgroundColor:
    //                                                 MaterialStateProperty.all<
    //                                                     Color>(Colors.green),
    //                                           ),
    //                                           child: Text(
    //                                             'Navigate',
    //                                             style: TextStyle(
    //                                               color: Colors.white,
    //                                               fontSize: 16.0,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ],
    //                               ));
    //                         },
    //                       );