import '../../data/models/fuel_record.dart';
import '../../../services/firebase/firebase_service.dart';

class FuelRepository {
  final FirebaseService service;
  FuelRepository(this.service);

  Future<List<FuelRecord>> listFuels(String uid) async {
    final snap = await service
        .fuelsRef(uid)
        .orderBy('data', descending: true)
        .get();
    return snap.docs.map((d) => FuelRecord.fromMap(d.id, d.data())).toList();
  }

  Future<void> addFuel(String uid, FuelRecord record) async {
    await service.fuelsRef(uid).add(record.toMap());
  }

  Future<void> deleteFuel(String uid, String fuelId) async {
    await service.fuelsRef(uid).doc(fuelId).delete();
  }
}
