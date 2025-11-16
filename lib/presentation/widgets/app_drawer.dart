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
        children: [
          const DrawerHeader(child: Center(child: Text('Menu'))),
          ListTile(
            title: const Text('Meus Veículos'),
            onTap: () => context.push('/vehicles'),
          ),
          ListTile(
            title: const Text('Registrar Abastecimento'),
            onTap: () => context.push('/register'),
          ),
          ListTile(
            title: const Text('Histórico de Abastecimentos'),
            onTap: () => context.push('/history'),
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () async {
              await firebase.auth.signOut();

              if (!context.mounted) return;

              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
