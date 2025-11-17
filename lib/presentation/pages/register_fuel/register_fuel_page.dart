import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_appbar.dart';

class RegisterFuelPage extends StatelessWidget {
  const RegisterFuelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Registrar Abastecimento'),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Formulário de registro aqui')),
    );
  }
}
