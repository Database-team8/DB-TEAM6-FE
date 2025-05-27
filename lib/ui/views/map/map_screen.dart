import 'package:ajoufinder/data/services/google_map_service.dart';
import 'package:ajoufinder/ui/viewmodels/navigator_bar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget{

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
    GoogleMapController? _mapController;
    GoogleMapService? _mapService;

    final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(37.2833808, 127.0460720),
      zoom: 18
    );

    @override
    void dispose() {
      super.dispose();
    }

      @override
      Widget build(BuildContext context) {
        
        return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapService = GoogleMapService(controller);
            },
            markers: _createMarkers(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (_) { // 맵을 탭하면 검색창 포커스 해제
              
            },
          ),
          
        ],
      );
  }

  Set<Marker> _createMarkers() {
    final navigatorBarViewModel = Provider.of<NavigatorBarViewModel>(context);
    return {
      Marker(
        markerId: MarkerId('팔달관'),
        position: LatLng(37.28448, 127.0444),
        consumeTapEvents: true,
        onTap: () => navigatorBarViewModel.updateCurrentPage(0),
      ),
      Marker(
        markerId: MarkerId('원천관'),
        position: LatLng(37.28293, 127.0434), // 임의 좌표
        consumeTapEvents: true,
        onTap: () => navigatorBarViewModel.updateCurrentPage(0),
      ),
      Marker(
        markerId: MarkerId('토목실험동'),
        position: LatLng(37.28427, 127.0434), // 임의 좌표
        consumeTapEvents: true,
        onTap: () => navigatorBarViewModel.updateCurrentPage(0),
      ),
      Marker(
        markerId: MarkerId('북문'),
        position: LatLng(37.28543, 127.0441), // 임의 좌표
        consumeTapEvents: true,
        onTap: () => navigatorBarViewModel.updateCurrentPage(0),
      ),
    };
  }
}

