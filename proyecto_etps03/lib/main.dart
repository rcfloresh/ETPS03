import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'FarmaciaPage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _username;
  String? _password;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Usuario'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu usuario';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FarmaciaPage()),
                    );
                  },
                  child: Text('Iniciar Sesión'),
                ),

                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                  },
                  child: Text('¿Olvidaste tu contraseña?'),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()),
                    );
                  },
                  child: Text('Agregar nuevo usuario'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                      final AuthCredential credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );
                      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
                      final User? user = authResult.user;

                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FarmaciaPage()),
                        );
                      }
                    } catch (error) {
                      // Manejar errores de autenticación aquí
                      print('Error de autenticación: $error');
                    }
                  },
                  child: Text('Iniciar Sesión con Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
