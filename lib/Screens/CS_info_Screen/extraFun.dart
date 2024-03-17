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
