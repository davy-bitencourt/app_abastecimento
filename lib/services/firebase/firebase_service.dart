import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/repositories/firebase_user_repo.dart';
import 'dart:developer' as developer;

class FirebaseService extends ChangeNotifier {
  final FirebaseUserRepo repo;

  FirebaseService(this.repo);

  User? _currentUser;
  User? get currentUser => _currentUser;

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  void init() {
    repo.userChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    _currentUser = auth.currentUser;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    _currentUser = auth.currentUser;
    notifyListeners();
  }

  Future<void> signOut() async {
    await auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      developer.log('Iniciando Google SignIn', name: 'FirebaseService');

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        developer.log(
          'Google sign-in foi cancelado pelo usuário',
          name: 'FirebaseService',
        );
        throw Exception('Login com Google cancelado');
      }

      developer.log(
        'Google user: ${googleUser.email}',
        name: 'FirebaseService',
      );

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        developer.log('Tokens do Google estão nulos', name: 'FirebaseService');
        throw Exception('Não foi possível recuperar tokens do Google');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await auth.signInWithCredential(credential);
      _currentUser = userCred.user;
      notifyListeners();

      developer.log(
        'SignInWithGoogle OK: ${_currentUser?.uid}',
        name: 'FirebaseService',
      );
    } catch (e, st) {
      developer.log(
        'Erro signInWithGoogle: $e\n$st',
        name: 'FirebaseService',
        level: 1000,
      );
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> vehiclesRef(String uid) =>
      firestore.collection('users').doc(uid).collection('veiculos');

  CollectionReference<Map<String, dynamic>> fuelsRef(String uid) =>
      firestore.collection('users').doc(uid).collection('abastecimentos');
}
