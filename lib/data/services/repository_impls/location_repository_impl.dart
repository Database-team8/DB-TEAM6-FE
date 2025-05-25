import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/repository/location_repository.dart';

class LocationRepositoryImpl extends LocationRepository{

  @override
  Future<String> getNameById(int departmentId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Location>> getAllLocations() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Location(id: 1, locationName: '팔달관'),
      Location(id: 3, locationName: '원천관'),
      Location(id: 5, locationName: '남제관'),
    ];
  }
}