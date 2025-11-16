import '../../data/models/vehicle.dart';
import '../../../services/firebase/firebase_service.dart';

class VehicleRepository {
  final FirebaseService service;
  VehicleRepository(this.service);

  Future<List<Vehicle>> listVehicles(String uid) async {
    final snap = await service.vehiclesRef(uid).get();
    return snap.docs.map((d) => Vehicle.fromMap(d.id, d.data())).toList();
  }

  Future<void> addVehicle(String uid, Vehicle vehicle) async {
    await service.vehiclesRef(uid).add(vehicle.toMap());
  }

  Future<void> deleteVehicle(String uid, String vehicleId) async {
    await service.vehiclesRef(uid).doc(vehicleId).delete();
  }
}
