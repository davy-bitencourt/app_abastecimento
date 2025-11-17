import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fuel_record.dart';

class FuelRepository {
  final FirebaseFirestore firestore;

  FuelRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> _col(String uid) {
    return firestore.collection('users').doc(uid).collection('abastecimentos');
  }

  Future<void> addFuel(String uid, FuelRecord f) async {
    await _col(uid).add(f.toMap());
  }

  Future<List<FuelRecord>> listFuel(String uid) async {
    final snap = await _col(uid).orderBy('data', descending: true).get();
    return snap.docs.map((d) => FuelRecord.fromMap(d.id, d.data())).toList();
  }

  Future<void> deleteFuel(String uid, String id) async {
    await _col(uid).doc(id).delete();
  }
}
