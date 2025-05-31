import 'package:ajoufinder/data/dto/location/locations/locations_response.dart';

abstract class LocationRepository {
  Future<String> getNameById(int departmentId);
  Future<LocationsResponse> getAllLocations();
}