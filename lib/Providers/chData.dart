// lib/providers/your_data_provider.dart

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      false; // this is for the rebuilding of Map and First building of Map
  bool _markerLoadingComplete = false;
  Map<String, dynamic> _chargingStations = {};
  bool _polyLineDone = false;
  Set<Marker> _markers = {};
  Set<Polyline> _pPoints = {};
  int? _stateOfCharge;
  String? _vehModel;
  String? _vehVersion;
  bool _showReset = false;

  // Getter to access the data
  bool get loading => _loading;
  bool get loading2 => _loading2;
  Map<String, dynamic> get chargingStations => _chargingStations;
  bool get markerLoadingComplete => _markerLoadingComplete;
  bool get polyLineDone => _polyLineDone;
  Set<Marker> get markers => _markers;
  Set<Polyline> get pPoints => _pPoints;
  int? get stateOfCharge => _stateOfCharge;
  String? get vehModel => _vehModel;
  String? get vehVersion => _vehVersion;
  bool get showReset => _showReset;

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

  set markers(Set<Marker> value) {
    _markers = value;
    notifyListeners();
  }

  set pPoints(Set<Polyline> value) {
    _pPoints = value;
    notifyListeners();
  }

  set stateOfCharge(int? value) {
    _stateOfCharge = value;
    notifyListeners(); // Notify listeners that data has changed
  }

  set vehModel(String? value) {
    _vehModel = value;
    notifyListeners(); // Notify listeners that data has changed
  }

  set vehVersion(String? value) {
    _vehVersion = value;
    notifyListeners(); // Notify listeners that data has changed
  }

  set showReset(bool value) {
    _showReset = value;
    notifyListeners(); // Notify listeners that data has changed
  }
}
