import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/pages/main_screen/main_screen.dart';
import 'package:social_media/features/presentation/pages/search/search_widget.dart';
import 'package:social_media/features/presentation/widgets/bottom_container_widget.dart';

class MapPage extends StatefulWidget {
  final String uid;
  const MapPage({required this.uid, super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController searchController = SearchController();
  final MapController _mapController = MapController();

  LatLng currentCenter = const LatLng(9.94548, 76.31810);

  void _updateCenter(LatLng newCenter) {
    setState(() {
      currentCenter = newCenter;
    });
    _mapController.move(newCenter, _mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// **Full-Screen Map**
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentCenter,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
             
            ],
          ),

          /// **Search Bar**
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: SearchWidget(controller: searchController,),
          ),

          /// **Bottom Navigation Button**
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: BottomContainerWidget(
              color: blueColor,
              text: 'Continue',
              onTapListener: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(uid: widget.uid)),
                (route) => false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
