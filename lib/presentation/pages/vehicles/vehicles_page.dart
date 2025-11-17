import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_appbar.dart';
import '../../../data/models/vehicle.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../../services/firebase/firebase_service.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  late final VehicleRepository repo;
  late final FirebaseService firebase;

  List<Vehicle> vehicles = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    repo = context.read<VehicleRepository>();
    firebase = context.read<FirebaseService>();

    // evita travar o initState com I/O
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final uid = firebase.currentUser?.uid;
    if (uid == null || !mounted) return;

    setState(() => loading = true);

    final list = await repo.listVehicles(uid);

    if (!mounted) return;
    setState(() {
      vehicles = list;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Veículos'),
      drawer: const AppDrawer(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (ctx, i) {
                final v = vehicles[i];
                return ListTile(
                  title: Text('${v.marca} ${v.modelo}'),
                  subtitle: Text(
                    '${v.placa} • ${v.ano} • ${v.tipoCombustivel}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await repo.deleteVehicle(firebase.currentUser!.uid, v.id);
                      if (mounted) _load();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddDialog(BuildContext ctx) {
    final formKey = GlobalKey<FormState>();

    final modelo = TextEditingController();
    final marca = TextEditingController();
    final placa = TextEditingController();
    final ano = TextEditingController();
    final tipo = TextEditingController();

    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Novo veículo'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: modelo,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: _required,
                ),
                TextFormField(
                  controller: marca,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: _required,
                ),
                TextFormField(
                  controller: placa,
                  decoration: const InputDecoration(labelText: 'Placa'),
                  validator: _required,
                ),
                TextFormField(
                  controller: ano,
                  decoration: const InputDecoration(labelText: 'Ano'),
                  keyboardType: TextInputType.number,
                  validator: _required,
                ),
                TextFormField(
                  controller: tipo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo Combustível',
                  ),
                  validator: _required,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final v = Vehicle(
                id: '',
                modelo: modelo.text,
                marca: marca.text,
                placa: placa.text,
                ano: int.parse(ano.text),
                tipoCombustivel: tipo.text,
              );

              await repo.addVehicle(firebase.currentUser!.uid, v);

              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              if (mounted) _load();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.isEmpty) ? 'Campo obrigatório' : null;
}
