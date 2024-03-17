// lib/providers/your_data_provider.dart

import 'package:flutter/foundation.dart';

// Charging Station class

class ChargingStation {
  final String id;
  final int availableSlots;
  final double cost;
  final double distance;
  final List<double> location;
  final int queue;
  final String duration;

  ChargingStation({
    required this.id,
    required this.availableSlots,
    required this.cost,
    required this.distance,
    required this.location,
    required this.queue,
    required this.duration,
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    return ChargingStation(
      id: json['id'],
      availableSlots: json['available_slots'],
      cost: json['cost'],
      distance: json['distance'],
      location: List<double>.from(json['location']),
      queue: json['queue'],
      duration: json['duration'],
    );
  }
}

// Charging Station class

class chDataProvider extends ChangeNotifier {
  // Data variable to store the fetched data
  bool _loading = false;
  bool _loading2 =
      true; // this is for the rebuilding of Map and First building of Map
  bool _markerLoadingComplete = false;
  Map<String, dynamic> _chargingStations = {};
  bool _polyLineDone = false;

  // Getter to access the data
  bool get loading => _loading;
  bool get loading2 => _loading2;
  Map<String, dynamic> get chargingStations => _chargingStations;
  bool get markerLoadingComplete => _markerLoadingComplete;
  bool get polyLineDone => _polyLineDone;

  int value = 1; // Initial value

  void setValue(int newValue) {
    value = newValue;
    notifyListeners(); // Notify listeners about the change
  }

  // Setter to update the data and notify listeners
  set loading(bool value) {
    _loading = value;
    notifyListeners(); // Notify listeners that data has changed
  }

  set loading2(bool value) {
    _loading2 = value;
    notifyListeners(); // Notify listeners that data has changed
  }

  set markerLoadingComplete(bool value) {
    _markerLoadingComplete = value;
    notifyListeners(); // Notify listeners that data has changed
  }

  inverse() {
    _loading2 = !_loading2;
  }

  set chargingStations(Map<String, dynamic> value) {
    _chargingStations = value;
    notifyListeners();
  }

  set polyLineDone(bool value) {
    _polyLineDone = value;
    notifyListeners();
  }
}
