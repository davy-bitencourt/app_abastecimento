import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class RegisterFuelPage extends StatelessWidget {
  const RegisterFuelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Abastecimento')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Formulário de registro aqui')),
    );
  }
}
