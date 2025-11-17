import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;
import '../../../services/firebase/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isSignUp = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<FirebaseService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => _loading = true);

                          try {
                            if (_isSignUp) {
                              await auth.signUp(
                                _emailCtrl.text.trim(),
                                _passCtrl.text.trim(),
                              );
                            } else {
                              await auth.signIn(
                                _emailCtrl.text.trim(),
                                _passCtrl.text.trim(),
                              );
                            }

                            if (!mounted) return;
                            context.go('/');
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                  child: Text(_isSignUp ? 'Cadastrar' : 'Entrar'),
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text("Entrar com Google"),
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          try {
                            await auth.signInWithGoogle();
                            if (!mounted) return;
                            context.go('/');
                          } catch (e, st) {
                            final msg = e is Exception
                                ? e.toString().replaceAll('Exception: ', '')
                                : 'Erro desconhecido';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Falha no login: $msg')),
                            );
                            developer.log(
                              'Erro no botão Google: $e\n$st',
                              name: 'LoginPage',
                              level: 1000,
                            );
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                ),

                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(
                    _isSignUp ? 'Já tenho uma conta' : 'Não tenho uma conta',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
