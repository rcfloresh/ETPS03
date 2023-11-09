import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {  // Cambia el tipo de retorno a Future<String>
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        final UserCredential userCredential = await _auth.signInWithCredential(authCredential);  // Guarda el UserCredential en una variable
        return userCredential.user!.email!;  // Devuelve el correo electrónico del usuario
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }

    return '';  // Devuelve una cadena vacía si no se pudo iniciar sesión
  }

  googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
