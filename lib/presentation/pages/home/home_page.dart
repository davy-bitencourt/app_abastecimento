import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Home'),
      drawer: const AppDrawer(),
      body: Center(),
    );
  }
}
