import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const AppDrawer(),
      body: Center(child: Image.asset('assets/images/banner.png', width: 300)),
    );
  }
}
