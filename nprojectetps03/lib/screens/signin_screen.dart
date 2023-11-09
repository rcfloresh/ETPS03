import 'package:firebase_auth/firebase_auth.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../screens/home_screen.dart';
import '../screens/reset_password.dart';
import '../screens/signup_screen.dart';
import '../utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../services/firebase_services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Ingrese su correo electronico", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Ingrese su contraseña", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "Inicio de Sesión", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen(userEmail: _emailTextController.text)));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                // Login con Google
                ElevatedButton(
                  onPressed: () async {
                    String userEmail = await FirebaseServices().signInWithGoogle();  // Guarda el correo del usuario en una variable
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen(userEmail: userEmail)));  // Pasa el correo del usuario a HomeScreen
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black26;
                        }
                        return Colors.white;
                      })),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google.png",
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Inicio de sesión con Google",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                signUpOption(),
              ],
          ),
        ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("No posee una cuenta?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Registrese",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Olvidó su contraseña?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}