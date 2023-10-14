import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/signin_screen.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('Farmacias para $medicineName'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Medicamentos').doc(medicineName).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return const Text('Cargando...');
          final pharmacies = (snapshot.data!.get('Farmacias') as List).cast<String>();
          return ListView.builder(
            itemCount: pharmacies.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: getPharmacyData(pharmacies[index]),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) return const Text('Cargando...');
                  final pharmacyData = snapshot.data!;
                  if (pharmacyData.get('Departamento') == department && pharmacyData.get('Municipio') == municipality) {
                    return ListTile(
                      title: Text(pharmacies[index]),
                    );
                  } else {
                    return Container();  // No mostrar nada si la farmacia no pertenece al departamento y municipio seleccionados
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}