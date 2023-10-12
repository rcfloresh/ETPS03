import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _medicineController = TextEditingController();
  String? _selectedDepartment;
  String? _selectedMunicipality;

  // Lista de departamentos de El Salvador
  final List<String> departments = [
    'Ahuachapan',
    'Cabañas',
    'Chalatenango',
    'Cuscatlan',
    'La Libertad',
    'La Paz',
    'La Union',
    'Morazán',
    'San Miguel',
    'San Salvador',
    'San Vicente',
    'Santa Ana',
    'Sonsonate',
    'Usulutan'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _medicineController,
              decoration: InputDecoration(
                labelText: 'Medicamento',
              ),
            ),
            DropdownButton<String>(
              hint: Text('Selecciona un departamento'),
              value: _selectedDepartment,
              items: departments.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue;
                  _selectedMunicipality = null;
                });
              },
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('deptMuni').doc(_selectedDepartment).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) return const Text('Cargando...');
                final municipalities = (snapshot.data!.get('municipalities') as List).cast<String>();
                return DropdownButton<String>(
                  hint: Text('Selecciona un municipio'),
                  value: _selectedMunicipality,
                  items: municipalities.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMunicipality = newValue;
                    });
                  },
                );
              },
            ),
            ElevatedButton(
              child: Text("Buscar"),
              onPressed: () {
                // Implementa la funcionalidad de búsqueda aquí
              },
            ),
            ElevatedButton(
              child: Text("Logout"),
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
      ),
    );
  }
}
