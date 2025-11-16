import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Lista de abastecimentos aqui')),
    );
  }
}
