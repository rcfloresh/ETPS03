import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatelessWidget {
  final String pharmacyName;

  MapPage({required this.pharmacyName});

  Future<LatLng> getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } else {
      // Handle location permission not granted
      return LatLng(0, 0);  // Return a default value or handle in another way
    }
  }
  Future<DocumentSnapshot> getPharmacyData() async {
    return await FirebaseFirestore.instance.collection('Farmacias').doc(pharmacyName).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: getCurrentLocation(),
      builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
        if (!snapshot.hasData) return const Text('Cargando...');
        final startPoint = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: getPharmacyData(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return const Text('Cargando...');
            final pharmacyData = snapshot.data!;
            final endPoint = LatLng(pharmacyData.get('Latitud'), pharmacyData.get('Longitud'));

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
                            builder: (ctx) => Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Icon(Icons.location_on, color: Colors.blue),
                                Positioned(
                                  bottom: 70,  // adjust the position as needed
                                  child: Text('Tú', style: TextStyle(color: Colors.blue, fontSize: 12)),  // adjust the font size as needed
                                ),
                              ],
                            ),
                          ),
                          Marker(
                            width: 200.0,
                            height: 200.0,
                            point: endPoint,
                            builder: (ctx) => Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Icon(Icons.location_on, color: Colors.red),
                                Positioned(
                                  bottom: 70,  // adjust the position as needed
                                  child: Text(pharmacyName, style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),  // adjust the font size as needed
                                ),
                              ],
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
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text('Ir a SearchPage'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
