import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepo {
  Stream<User?> userChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
