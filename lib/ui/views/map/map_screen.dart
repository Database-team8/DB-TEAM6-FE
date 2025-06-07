import 'package:ajoufinder/data/services/google_map_service.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/filter_state_view_model.dart';
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
    final filterStateViewModel = Provider.of<FilterStateViewModel>(context, listen: false);

    return {
      Marker(
        markerId: MarkerId('팔달관'),
        position: LatLng(37.28448, 127.0444),
        consumeTapEvents: true,
        onTap: () async {
          if (filterStateViewModel.availableItemTypes.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
                ).showSnackBar(SnackBar(content: Text('유효하지 않습니다.')));
              } else {
                return;
              }
            }
          final loc = filterStateViewModel.availableLocations.firstWhere(
            (location) => location.locationName == '팔달관',
          );
          filterStateViewModel.setSelectedLocation(loc);
          navigatorBarViewModel.updateCurrentPage(0);

          await filterStateViewModel.sendQuery(
            Provider.of<BoardViewModel>(context, listen: false),
            navigatorBarViewModel.currentIndex,
          );
        },
      ),
      Marker(
        markerId: MarkerId('중앙도서관'),
        position: LatLng(37.28153, 127.0442),
        consumeTapEvents: true,
        onTap: () async {
          if (filterStateViewModel.availableItemTypes.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
                ).showSnackBar(SnackBar(content: Text('유효하지 않습니다.')));
              } else {
                return;
              }
            }
          final loc = filterStateViewModel.availableLocations.firstWhere(
            (location) => location.locationName == '중앙도서관',
          );
          filterStateViewModel.setSelectedLocation(loc);
          navigatorBarViewModel.updateCurrentPage(0);

          await filterStateViewModel.sendQuery(
            Provider.of<BoardViewModel>(context, listen: false),
            navigatorBarViewModel.currentIndex,
          );
        },
      ),
      Marker(
        markerId: MarkerId('체육관'),
        position: LatLng(37.27996, 127.0454),
        consumeTapEvents: true,
        onTap: () async {
          if (filterStateViewModel.availableItemTypes.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
                ).showSnackBar(SnackBar(content: Text('유효하지 않습니다.')));
              } else {
                return;
              }
            }
          final loc = filterStateViewModel.availableLocations.firstWhere(
            (location) => location.locationName == '체육관',
          );
          filterStateViewModel.setSelectedLocation(loc);
          navigatorBarViewModel.updateCurrentPage(0);

          await filterStateViewModel.sendQuery(
            Provider.of<BoardViewModel>(context, listen: false),
            navigatorBarViewModel.currentIndex,
          );
        },
      ),
    };
  }
}

