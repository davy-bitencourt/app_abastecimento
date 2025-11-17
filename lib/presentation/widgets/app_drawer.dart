import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/firebase/firebase_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = context.read<FirebaseService>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Center(child: Text('Menu'))),

          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              context.push('/');
            },
          ),

          ListTile(
            title: const Text('Meus Veículos'),
            onTap: () {
              Navigator.pop(context);
              context.push('/vehicles');
            },
          ),

          ListTile(
            title: const Text('Registrar Abastecimento'),
            onTap: () {
              Navigator.pop(context);
              context.push('/register');
            },
          ),

          ListTile(
            title: const Text('Histórico de Abastecimentos'),
            onTap: () {
              Navigator.pop(context);
              context.push('/history');
            },
          ),

          ListTile(
            title: const Text('Sair'),
            onTap: () async {
              await firebase.auth.signOut();

              if (!context.mounted) return;

              Navigator.pop(context);
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
