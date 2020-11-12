import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  static const routeName = '/map';
  final double lat;
  final double lon;

  Map({@required this.lat, @required this.lon});
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  int counter = 1;
  Set<Marker> _marker = HashSet<Marker>();
  Completer<GoogleMapController> _controller = Completer();

  //  final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    double lat = widget.lat;
    double long = widget.lon;
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Place location'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        markers: _marker,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (point) {
          setState(() {
            _marker.clear();
            final String markerIdVal = 'marker_id_$counter';
            counter++;
            _marker
                .add(Marker(markerId: MarkerId(markerIdVal), position: point));
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
