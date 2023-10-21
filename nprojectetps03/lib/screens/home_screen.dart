import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/pharmacy_screen.dart';
import '../utils/color_utils.dart';
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
  List<String> _medicineList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Inicio",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Medicamentos').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return const Text('Cargando...');
                        _medicineList = snapshot.data!.docs.map((doc) => doc.id).toList();
                        return Autocomplete<String>(

                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return _medicineList.where((String option) {
                              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                            });
                          },
                          onSelected: (String selection) {
                            _medicineController.text = selection;
                          },

                          // Start Style
                          fieldViewBuilder: (context, Controller, focusNode, onFieldSubmitted){
                            return TextFormField(
                              controller: Controller,
                              focusNode: focusNode,
                           //   onFieldSubmitted: onFieldSubmitted,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black), // Borde enfocado negro
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: 'Ingrese un medicamento'
                              ),
                            );
                          },


                          // End Style



                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('deptMuni').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return const Text('Cargando...');
                        final departments = snapshot.data!.docs.map((doc) => doc.id).toList();
                        return DropdownButton<String>(
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
                          // Start Style

                        style: TextStyle(color: Colors.black), // Color del texto negro
                        icon: Icon(Icons.arrow_drop_down), // Icono de flecha
                        underline: Container(  // Borde inferior
                        height: 2,
                        color: Colors.black, // Color del borde inferior
                        ),

                        decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        )
                        ),

                          // End Style
                        );
                      },
                    ),





                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text("Buscar"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) => PharmacyScreen(medicineName:
                          _medicineController.text, department:
                          _selectedDepartment!, municipality:
                          _selectedMunicipality!)),
                        );
                      },
                    ),
                  ],
                ),
              )
          )
      ),
    );
  }
}
