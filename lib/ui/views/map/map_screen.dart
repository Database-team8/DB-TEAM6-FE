import 'package:ajoufinder/data/services/google_map_service.dart';
import 'package:ajoufinder/ui/shared/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget{

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
    late GoogleMapController _mapController;
    final GoogleMapService _mapService = GoogleMapService();
    final TextEditingController _searchController = TextEditingController();
    final FocusNode _searchFocusNode = FocusNode();

    final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(37.2833808, 127.0460720),
      zoom: 18
    );

    @override
    void dispose() {
      _searchController.dispose();
      _searchFocusNode.dispose();
      super.dispose();
    }

    void _performMapSearch(String query) {
      //추후 구현
      _searchFocusNode.unfocus();
    }

      @override
      Widget build(BuildContext context) {
        return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapService.setMapController(controller);
            },
            markers: _createMarkers(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (_) { // 맵을 탭하면 검색창 포커스 해제
              _searchFocusNode.unfocus();
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, // 상태바 높이 고려
            left: 15,
            right: 15,
            child: SearchBarWidget(
              controller: _searchController,
              hintText: '장소, 주소 검색',
              onSubmitted: _performMapSearch,
              focusNode: _searchFocusNode,
              onClear: () {},
            ),
          ),
        ],
      );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId('팔달관'),
        position: LatLng(37.28448, 127.0444),
        consumeTapEvents: true,
        onTap: () {
        },
      ),
      Marker(
        markerId: MarkerId('원천관'),
        position: LatLng(37.28293, 127.0434), // 임의 좌표
        consumeTapEvents: true,
        onTap: () {
        },
      ),
      Marker(
        markerId: MarkerId('토목실험동'),
        position: LatLng(37.28427, 127.0434), // 임의 좌표
        consumeTapEvents: true,
        onTap: () {
        },
      ),
      Marker(
        markerId: MarkerId('북문'),
        position: LatLng(37.28543, 127.0441), // 임의 좌표
        consumeTapEvents: true,
        onTap: () {
        },
      ),
    };
  }
}

