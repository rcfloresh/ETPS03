import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/signin_screen.dart';
import '../screens/map_page.dart';
import '../screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../utils/color_utils.dart';
class PharmacyScreen extends StatefulWidget {
  final String medicineName;
  final String department;
  final String municipality;
  final String userName;  // Añade el nombre de usuario como un parámetro

  PharmacyScreen({required this.medicineName, required this.department, required this.municipality, required this.userName});

  @override
  _PharmacyScreenState createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  Future<DocumentSnapshot> getPharmacyData(String pharmacyName) async {
    return await FirebaseFirestore.instance.collection('Farmacias').doc(pharmacyName).get();
  }

  void addSuggestion(BuildContext context, String medicineName) async {
    final userDoc =
        FirebaseFirestore.instance.collection('DatosUsuario').doc(widget.userName);
    final doc = await userDoc.get();

    if (!doc.exists) {
      await userDoc.set({
        'Sugerencias': [medicineName],
        'Favoritos': []
      });
    } else {
      await userDoc.update({
        'Sugerencias': FieldValue.arrayUnion([medicineName])
      });
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(userEmail: widget.userName)));
  }

  Future<void> addFavorites(BuildContext context, String medicineName) async {
    final userDoc = FirebaseFirestore.instance.collection('DatosUsuario').doc(widget.userName);
    final doc = await userDoc.get();

    if (!doc.exists) {
      await userDoc.set({
        'Sugerencias': [],
        'Favoritos': [medicineName]
      });
    } else {
      List<String> favorites = List<String>.from(doc.data()!['Favoritos']);
      if (favorites.contains(medicineName)) {
        favorites.remove(medicineName);
      } else {
        favorites.add(medicineName);
      }
      await userDoc.update({
        'Favoritos': favorites
      });
    }
    setState(() {});  // Llama a setState para volver a pintar el widget
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Farmacias para ${widget.medicineName}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),  // Cambiado el color del texto a blanco
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
            future: FirebaseFirestore.instance.collection('Medicamentos').doc(widget.medicineName).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Cargando...');
              if (!snapshot.data!.exists) {
                return Center(  // Añade un widget Center para centrar la tarjeta
                  child: Card(
                    margin: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,  // Ajusta la altura de la columna al contenido
                        children: <Widget>[
                          Text(
                            '¿Crées que debemos añadir este medicamento?',
                            style: TextStyle(fontSize: 16.0, color: Colors.purple, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '¡Añadelo como sugerencia! Esto puede ayudarte a ti y a otros usuarios en el futuro',
                            style: TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => addSuggestion(context, widget.medicineName),
                            icon: Icon(Icons.add, color: Colors.white),  // Añade un icono al botón
                            label: Text('Añadir sugerencia', style: TextStyle(fontSize: 14.0, color: Colors.purple, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              final pharmacies = (snapshot.data!.get('Farmacias') as List).cast<String>();
              final medicinePrice = snapshot.data!.get('PrecioEstandar');  // Obtener el precio estándar del medicamento
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('DatosUsuario').doc(widget.userName).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) return const Text('Cargando...');
                            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;  // Especifica explícitamente el tipo de datos
                            List<String> favorites = List<String>.from(userData['Favoritos']);
                            return IconButton(
                              icon: Icon(Icons.favorite,
                                color: favorites.contains(widget.medicineName) ? Colors.red : Colors.white, size: 35,), // Añade un icono de corazón
                              onPressed: () => addFavorites(context,
                                  widget.medicineName), // Llama a addFavorites cuando se presiona el botón
                            );
                          },
                        ),
                        Text(
                          'Precio del medicamento: \$ $medicinePrice', // Mostrar el precio estándar del medicamento
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors
                                  .white), // Cambiado el color del texto a blanco
                        ),
                      ],
                    ),
                  ),
                  Card(
                    // Añade una tarjeta para el texto de la "Nota"
                    margin: EdgeInsets.all(15),
                    child: Column(
                    mainAxisSize: MainAxisSize
                    .min, // Ajusta la altura de la columna al contenido
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            10, top: 10), // Añade un padding inferior al primer texto
                        child: Text(
                          'Nota:',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            20), // Añade un padding inferior al segundo texto
                        child: Text(
                          'El precio mostrado solo es de referencia, proporcionado por la Direccion Nacional de Medicamentos.',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
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
                            if (pharmacyData.get('Departamento') == widget.department && pharmacyData.get('Municipio') == widget.municipality) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MapPage(pharmacyName: pharmacies[index], userName: widget.userName,)),
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
