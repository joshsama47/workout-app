import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OutdoorWorkoutScreen extends StatefulWidget {
  const OutdoorWorkoutScreen({super.key});

  @override
  State<OutdoorWorkoutScreen> createState() => _OutdoorWorkoutScreenState();
}

class _OutdoorWorkoutScreenState extends State<OutdoorWorkoutScreen> {
  GoogleMapController? _mapController;
  bool _isTracking = false;
  StreamSubscription<Position>? _positionStream;
  final List<LatLng> _route = [];
  Polyline? _polyline;

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _toggleTracking() async {
    if (_isTracking) {
      _stopTracking();
    } else {
      await _startTracking();
    }
  }

  Future<void> _startTracking() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isTracking = true;
    });

    _positionStream = Geolocator.getPositionStream().listen((
      Position position,
    ) {
      setState(() {
        _route.add(LatLng(position.latitude, position.longitude));
        _polyline = Polyline(
          polylineId: const PolylineId('route'),
          points: _route,
          color: Colors.blue,
          width: 5,
        );
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
      });
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
    setState(() {
      _isTracking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outdoor Workout')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco
          zoom: 12,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: _polyline != null ? {_polyline!} : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTracking,
        child: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
      ),
    );
  }
}
