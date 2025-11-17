import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../../../data/models/fuel_record.dart';
import '../../../data/models/vehicle.dart';
import '../../../data/repositories/fuel_repository.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../../services/firebase/firebase_service.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/app_drawer.dart';

//tinha esquecido de commitar o hitorico de abastecimentos
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final FuelRepository fuelRepo;
  late final VehicleRepository vehicleRepo;
  late final FirebaseService firebase;

  List<FuelRecord> records = [];
  List<Vehicle> vehicles = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fuelRepo = context.read<FuelRepository>();
    vehicleRepo = context.read<VehicleRepository>();
    firebase = context.read<FirebaseService>();

    Future.microtask(_load);
  }

  Future<void> _load() async {
    final uid = firebase.currentUser?.uid;
    if (uid == null) return;

    setState(() => loading = true);

    final v = await vehicleRepo.listVehicles(uid);
    final r = await fuelRepo.listFuel(uid);

    if (!mounted) return;

    setState(() {
      vehicles = v;
      records = r;
      loading = false;
    });
  }

  Vehicle? _vehicleById(String id) =>
      vehicles.firstWhereOrNull((v) => v.id == id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Abastecimentos'),
      drawer: const AppDrawer(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (ctx, i) {
                final r = records[i];
                final vehicle = _vehicleById(r.veiculoId);

                return ListTile(
                  title: Text(
                    'R\$ ${r.valorPago.toStringAsFixed(2)} • ${r.quantidadeLitros.toStringAsFixed(1)} L',
                  ),
                  subtitle: Text(
                    '${r.data.day}/${r.data.month}/${r.data.year} — '
                    '${vehicle != null ? "${vehicle.marca} ${vehicle.modelo}" : "Veículo removido"}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await fuelRepo.deleteFuel(
                        firebase.currentUser!.uid,
                        r.id,
                      );

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
    if (vehicles.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Cadastre um veículo antes.')),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();

    final data = TextEditingController();
    final litros = TextEditingController();
    final valor = TextEditingController();
    final km = TextEditingController();
    final obs = TextEditingController();

    Vehicle? selectedVehicle;

    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Novo Abastecimento'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<Vehicle>(
                  decoration: const InputDecoration(labelText: 'Veículo'),
                  items: vehicles
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text('${v.marca} ${v.modelo}'),
                        ),
                      )
                      .toList(),
                  validator: (v) => v == null ? 'Selecione um veículo' : null,
                  onChanged: (v) => selectedVehicle = v,
                ),
                TextFormField(
                  controller: data,
                  validator: _required,
                  decoration: const InputDecoration(
                    labelText: 'Data (AAAA-MM-DD)',
                  ),
                ),
                TextFormField(
                  controller: litros,
                  validator: _required,
                  decoration: const InputDecoration(
                    labelText: 'Litros abastecidos',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: valor,
                  validator: _required,
                  decoration: const InputDecoration(labelText: 'Valor pago'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: km,
                  validator: _required,
                  decoration: const InputDecoration(labelText: 'Quilometragem'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: obs,
                  decoration: const InputDecoration(
                    labelText: 'Observação (opcional)',
                  ),
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
            child: const Text('Salvar'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final rec = FuelRecord(
                id: '',
                data: DateTime.parse(data.text),
                quantidadeLitros: double.parse(litros.text),
                valorPago: double.parse(valor.text),
                quilometragem: int.parse(km.text),
                tipoCombustivel: selectedVehicle!.tipoCombustivel,
                veiculoId: selectedVehicle!.id,
                consumo: null,
                observacao: obs.text.isEmpty ? null : obs.text,
              );

              await fuelRepo.addFuel(firebase.currentUser!.uid, rec);

              if (dialogCtx.mounted) Navigator.pop(dialogCtx);

              if (mounted) _load();
            },
          ),
        ],
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.isEmpty) ? 'Campo obrigatório' : null;
}
