import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LatLng psuHatyai = LatLng(7.006241, 100.499542);

    return Scaffold(
      appBar: AppBar(title: const Text('PSU Hatyai Map')),
      body: FlutterMap(
        // ignore: deprecated_member_use
        options: MapOptions(center: psuHatyai, zoom: 16.0),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80,
                height: 80,
                point: psuHatyai,
                child: const Icon(
                  // ✅ ใช้ child แทน builder ในบางเวอร์ชัน
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
