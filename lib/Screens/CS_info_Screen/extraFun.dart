import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getCustomIcon(String assetPath) async {
  final BitmapDescriptor bitmapDescriptor =
      await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(devicePixelRatio: 2.0),
    assetPath,
  );
  return bitmapDescriptor;
}

class ElectricVehicle {
  final String brand;
  final String model;
  final int range;

  ElectricVehicle({
    required this.brand,
    required this.model,
    required this.range,
  });
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
