import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'core/themes/app_theme.dart';

// Services e Repositórios
import 'services/firebase/firebase_service.dart';
import 'data/repositories/firebase_user_repo.dart';

// Pages
import 'presentation/pages/login/login_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/vehicles/vehicles_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseService>(
          create: (_) {
            final repo = FirebaseUserRepo();
            final service = FirebaseService(repo);
            service.init();
            return service;
          },
        ),
      ],
      child: const MyApp(),
    );
  }
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
      ],

      redirect: (context, state) {
        final loggedIn = auth.currentUser != null;
        final isOnLoginPage = state.uri.toString() == '/login';

        if (!loggedIn && !isOnLoginPage) return '/login';
        if (loggedIn && isOnLoginPage) return '/';
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
