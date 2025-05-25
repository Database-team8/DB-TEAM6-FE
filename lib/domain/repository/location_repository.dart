import 'package:ajoufinder/domain/entities/location.dart';

abstract class LocationRepository {
  Future<String> getNameById(int departmentId);
  Future<List<Location>> getAllLocations();
}