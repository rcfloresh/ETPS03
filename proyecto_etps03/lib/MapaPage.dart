import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de El Salvador'), // Título de la página del mapa
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(13.7942, -88.8965), // Coordenadas para centrar el mapa en El Salvador
          zoom: 10.0, // Nivel de zoom inicial
        ),
        onMapCreated: (GoogleMapController controller) {
          // Aquí puedes personalizar el controlador del mapa si es necesario
        },
      ),
    );
  }
}
