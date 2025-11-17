import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_appbar.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Histórico de Abastecimentos'),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Lista de abastecimentos aqui')),
    );
  }
}
