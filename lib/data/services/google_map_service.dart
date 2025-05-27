import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService {
  final GoogleMapController _mapController;

  GoogleMapService(this._mapController);
  
  Future<void> moveToPosition(
      double latitude, double longitude, double zoom) async {
    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: zoom),
      ),
    );
  }

  Future<void> searchAndMove(String query) async {
    // TODO: 검색어를 좌표로 변환하는 기능 추가 (Geocoding API 호출 등)
    // 검색 기능 구현
  }
}

