import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/socket_service.dart';

class PassengerBusTracking extends StatefulWidget {
  final String busId;

  PassengerBusTracking({required this.busId});

  @override
  _PassengerBusTrackingState createState() => _PassengerBusTrackingState();
}

class _PassengerBusTrackingState extends State<PassengerBusTracking> {
  GoogleMapController? _mapController;
  LatLng _busLocation = LatLng(28.6139, 77.2090); // Default: New Delhi
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    // Connect to socket and subscribe to this bus
    SocketService.connect();
    SocketService.subscribeToBus(widget.busId, (lat, lng) {
      setState(() {
        _busLocation = LatLng(lat, lng);
        _markers = {
          Marker(
            markerId: MarkerId(widget.busId),
            position: _busLocation,
            infoWindow: InfoWindow(title: "Bus ${widget.busId}"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          )
        };
      });

      // Move camera to bus
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_busLocation),
      );
    });
  }

  @override
  void dispose() {
    SocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracking Bus ${widget.busId}"),
        backgroundColor: Color(0xFF1976D2),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _busLocation,
          zoom: 14,
        ),
        markers: _markers,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
