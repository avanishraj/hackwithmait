import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<LocationData?> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // Get the current location
    _locationData = await location.getLocation();
    return _locationData;
  }

  // Listen for location changes (optional)
  void listenToLocationChanges() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location here
      print('Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}');
    });
  }

  // Enable background mode (optional)
  Future<bool> enableBackgroundMode(bool enable) async {
    return await location.enableBackgroundMode(enable: enable);
  }
}
