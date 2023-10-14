import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/signin_screen.dart';
import 'package:flutter/material.dart';

class PharmacyScreen extends StatelessWidget {
  final String medicineName;

  PharmacyScreen({required this.medicineName});

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Medicamentos').doc(medicineName).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return const Text('Cargando...');
          final pharmacies = (snapshot.data!.get('Farmacias') as List).cast<String>();
          return ListView.builder(
            itemCount: pharmacies.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(pharmacies[index]),
              );
            },
          );
        },
      ),
    );
  }
}
