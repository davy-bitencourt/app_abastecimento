import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/theme_notifier.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/app_drawer.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: const AppAppBar(title: 'Configurações'),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Opções gerais',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Tema escuro'),
            trailing: Switch(
              value: theme.isDark,
              onChanged: (val) => theme.toggleTheme(val),
            ),
          ),
        ],
      ),
    );
  }
}
