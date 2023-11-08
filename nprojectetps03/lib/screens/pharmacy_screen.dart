import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/signin_screen.dart';
import '../screens/map_page.dart';
import '../screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class PharmacyScreen extends StatelessWidget {
  final String medicineName;
  final String department;
  final String municipality;

  PharmacyScreen({required this.medicineName, required this.department, required this.municipality});

  Future<DocumentSnapshot> getPharmacyData(String pharmacyName) async {
    return await FirebaseFirestore.instance.collection('Farmacias').doc(pharmacyName).get();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Farmacias para $medicineName', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),  // Cambiado el color del texto a blanco
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),  // Cambiado el color del ícono a blanco
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  hexStringToColor("CB2B93"),
                  hexStringToColor("9546C4"),
                  hexStringToColor("5E61F4")
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        child: SafeArea(  // Agrega SafeArea aquí
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('Medicamentos').doc(medicineName).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Cargando...');
              final pharmacies = (snapshot.data!.get('Farmacias') as List).cast<String>();
              final medicinePrice = snapshot.data!.get('PrecioEstandar');  // Obtener el precio estándar del medicamento
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Precio del medicamento: \$ $medicinePrice',  // Mostrar el precio estándar del medicamento
                      style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),  // Cambiado el color del texto a blanco
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'NOTA: El precio mostrado solo es una referencia proporcionada por la Direccion Nacional de Medicamentos, este puede variar dependiendo del establecimiento que seleccione.',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),  // Cambiado el color del texto a blanco
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pharmacies.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: getPharmacyData(pharmacies[index]),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) return const Text('Cargando...');
                            final pharmacyData = snapshot.data!;
                            if (pharmacyData.get('Departamento') == department && pharmacyData.get('Municipio') == municipality) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MapPage(pharmacyName: pharmacies[index])),
                                  );
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.local_pharmacy, color: Theme.of(context).primaryColor),
                                    title: Text(pharmacies[index], style: Theme.of(context).textTheme.headline6),
                                    trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              );
                            } else {
                              return Container();  // No mostrar nada si la farmacia
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
