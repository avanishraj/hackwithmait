import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSButton extends StatefulWidget {
  final String contactNo;

  SOSButton({Key? key, required this.contactNo}) : super(key: key);

  @override
  _SOSButtonState createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> {
  LocationService locationService = LocationService();
  String message = "SOS! I need help. My current location is: ";

  void sendSOSMessage() async {
    try {
      LocationData? location = await locationService.getCurrentLocation();
      if (location != null) {
        String locationMessage =
            "$message https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}";
        print(locationMessage);

        final Uri smsUrl = Uri(
          scheme: 'sms',
          path: widget.contactNo,
          query: 'body=${Uri.encodeComponent(locationMessage)}',
        );
        print(
          widget.contactNo,
        );

        if (await canLaunchUrl(smsUrl)) {
          await launchUrl(smsUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to open SMS app. Please check your SMS app settings.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to fetch location')),
        );
      }
    } catch (e) {
      print('Error launching SMS app: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: sendSOSMessage,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text("SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),),
          ),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
        ));
  }
}

class LocationService {
  Location location = Location();

  Future<LocationData?> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    return _locationData;
  }
}
