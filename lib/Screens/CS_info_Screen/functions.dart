// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'AIzaSyBeG5g3Ps44SleGRirPm4IcnC9BvwbLqDI';

// To find the Distance between two points and FInd the time to travel in Traffic

Future<dynamic> getDistanceAndTimeT({
  required double? originLatitude,
  required double? originLongitude,
  required double destinationLatitude,
  required double destinationLongitude,
}) async {
  final String apiKey =
      'AIzaSyBeG5g3Ps44SleGRirPm4IcnC9BvwbLqDI'; // Replace with your actual API key
  final origins = 'origins=$originLatitude,$originLongitude';
  final destinations =
      'destinations=$destinationLatitude,$destinationLongitude';
  // final departureTimeParam =
  //     departureTime != null ? '&departure_time=$departureTime' : '';
  final uri = Uri.parse(
    'https://maps.googleapis.com/maps/api/distancematrix/json?$origins&$destinations=now&key=$apiKey',
  );
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch data: ${response.statusCode}');
  }
}
