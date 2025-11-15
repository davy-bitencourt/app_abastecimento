import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Importe as opções geradas pelo FlutterFire CLI
import 'firebase_options.dart';

void main() async {
  // Garante que os bindings do Flutter foram inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase usando as opções da plataforma atual
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Firebase App')),
        body: Center(child: Text('Firebase inicializado!')),
      ),
    );
  }
}
