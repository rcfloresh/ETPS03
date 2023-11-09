import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/pharmacy_screen.dart';
import '../utils/color_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;  // Añade el correo del usuario como un parámetro

  const HomeScreen({Key? key, required this.userEmail}) : super(key: key);  // Incluye el correo del usuario en el constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _medicineController = TextEditingController();
  String? _selectedDepartment;
  String? _selectedMunicipality;
  List<String> _medicineList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Busqueda de medicamentos',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)), // Cambiado el color del texto a blanco
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          // Agrega SafeArea aquí
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              // Cambiado el padding superior para evitar la superposición con la AppBar
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Medicamentos')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return const Text('Cargando...');
                      _medicineList =
                          snapshot.data!.docs.map((doc) => doc.id).toList();
                      return Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _medicineList.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          _medicineController.text = selection;
                        },
                        // Start Style
                        fieldViewBuilder:
                            (context, Controller, focusNode, onFieldSubmitted) {
                          Controller.text = _medicineController.text;
                          return TextFormField(
                            controller: Controller,
                            focusNode: focusNode,
                            onChanged: (value) {
                              _medicineController.text = value;  // Actualiza _medicineController con el valor ingresado manualmente
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.local_pharmacy,
                                color: Colors.white70,
                              ),
                              labelText:
                              "Ingrese el medicamento que desea consultar",
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                              fillColor: Colors.white.withOpacity(0.3),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          );
                        },
                      );
                    },
                  ),


                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('deptMuni')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return const Text('Cargando...');
                      final departments =
                      snapshot.data!.docs.map((doc) => doc.id).toList();
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: Colors.white70,
                          ),
                          labelText: "Selecciona un departamento",
                          labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.9)),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white.withOpacity(0.3),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                        ),
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
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('deptMuni')
                        .doc(_selectedDepartment)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists)
                        return const Text('Cargando...');
                      final municipalities =
                      (snapshot.data!.get('municipalities') as List)
                          .cast<String>();
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: Colors.white70,
                          ),
                          labelText: "Selecciona un municipio",
                          labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.9)),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white.withOpacity(0.3),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                        ),
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

                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text("Buscar"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacyScreen(
                                medicineName: _medicineController.text,
                                department: _selectedDepartment!,
                                municipality: _selectedMunicipality!,
                              userName: widget.userEmail, )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
