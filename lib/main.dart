import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'core/themes/app_theme.dart';

import 'services/firebase/firebase_service.dart';
import 'data/repositories/firebase_user_repo.dart';

import 'presentation/pages/login/login_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/vehicles/vehicles_page.dart';
import 'presentation/pages/history/history_page.dart';
import 'presentation/pages/config/config_page.dart';
import 'data/repositories/vehicle_repository.dart';
import 'data/repositories/fuel_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  Future<void> _initApp(BuildContext context) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final userRepo = FirebaseUserRepo();
    final service = FirebaseService(userRepo);
    service.init();

    ProviderScope.store = service;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<FirebaseService>.value(
              value: ProviderScope.store!,
            ),

            Provider<VehicleRepository>(
              create: (_) => VehicleRepository(FirebaseFirestore.instance),
            ),
            Provider<FuelRepository>(
              create: (_) => FuelRepository(FirebaseFirestore.instance),
            ),
          ],
          child: const MyApp(),
        );
      },
    );
  }
}

class ProviderScope {
  static FirebaseService? store;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  GoRouter _router(FirebaseService auth) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: auth,
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/vehicles', builder: (_, __) => const VehiclesPage()),
        GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
        GoRoute(path: '/configuracoes', builder: (_, __) => const ConfigPage()),
      ],
      redirect: (context, state) {
        final loggedIn = auth.currentUser != null;
        final onLoginPage = state.uri.toString() == '/login';

        if (!loggedIn && !onLoginPage) return '/login';
        if (loggedIn && onLoginPage) return '/';

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = context.watch<FirebaseService>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'App Abastecimento',
      theme: appTheme,
      routerConfig: _router(firebaseService),
    );
  }
}
