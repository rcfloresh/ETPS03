import 'FarmaciaPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  final startPoint = LatLng(13.6929, -89.2182);
  final endPoint = LatLng(13.7134, -89.2188);

  @override
  Widget build(BuildContext context) {


    return Column(
      children: <Widget>[
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              center: startPoint,
              zoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 200.0,
                    height: 200.0,
                    point: startPoint,
                    builder: (ctx) => Container(
                      child: Icon(Icons.location_on, color: Colors.red),
                    ),
                  ),
                  Marker(
                    width: 90.0,
                    height: 90.0,
                    point: endPoint,
                    builder: (ctx) => Container(
                      child: Icon(Icons.location_on, color: Colors.blue),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FarmaciaPage()),
              );
            },
            child: Text('Ir a SearchPage'),
          ),
        ),
      ],
    );
  }
}