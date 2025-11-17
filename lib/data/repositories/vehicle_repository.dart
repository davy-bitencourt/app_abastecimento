import '../../data/models/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleRepository {
  final FirebaseFirestore firestore;

  VehicleRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> _col(String uid) {
    return firestore.collection('users').doc(uid).collection('veiculos');
  }

  Future<List<Vehicle>> listVehicles(String uid) async {
    final snap = await _col(uid).get();
    return snap.docs.map((d) => Vehicle.fromMap(d.id, d.data())).toList();
  }

  Future<void> addVehicle(String uid, Vehicle v) async {
    await _col(uid).add(v.toMap());
  }

  Future<void> deleteVehicle(String uid, String id) async {
    await _col(uid).doc(id).delete();
  }
}
