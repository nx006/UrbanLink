import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:urbanlink_project/pages/postpage/postspage.dart';
import 'dart:async';
import 'package:get/get.dart';

import 'package:urbanlink_project/pages/postpage/postspage.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  TextEditingController textController = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  List<Marker> _markers = [];
  LatLng startLocation = LatLng(37.552635722509, 126.92436042413);

  static const CameraPosition _hongik = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.552635722509, 126.92436042413),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );

  void initState() {
    super.initState();
    addMarkers();
  }
  addMarkers() async {
    BitmapDescriptor customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(120,80),),
        'assets/images/blueround.png',
    );
    _markers.add(Marker(
      markerId: MarkerId("1"),
      onTap: () => {
        print("1"),
        Get.to(const PostsPage()),
      },
      position: LatLng(	37.552635722509, 126.92436042413),
      icon: customMarkerIcon,
      alpha: 0.4,
    ));
    _markers.add(Marker(
      markerId: MarkerId("2"),
      onTap: () => {
        print("2"),
        Get.to(const PostsPage()),
      },
      position: LatLng(	37.565643683342, 126.95524147826),
      icon: customMarkerIcon,
      alpha: 0.4,
    ));
    _markers.add(Marker(
      markerId: MarkerId("3"),
      onTap: () => {
        print("3"),
        Get.to(const PostsPage()),
      },
      position: LatLng(	37.495172947072, 126.95453489844),
      icon: customMarkerIcon,
      alpha: 0.4,
    ));
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Map'),
        ),

        body: Stack(
          children: <Widget>[

            GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition( //innital position in map
                target: startLocation, //initial position
                zoom: 12.0, //initial zoom level
              ),
              markers: Set.from(_markers),
            ),

            Positioned(
              top: 5,
              right: 15,
              left: 15,
              child: AnimSearchBar(
                width: MediaQuery.of(context).size.width,
                textController: textController,
                onSuffixTap: () {
                  setState(() {
                    textController.clear();
                  });
                },
                onSubmitted: (String _) {},
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheHome,
        label: const Text('To the home!'),
        //icon: const Icon(Icons.abc_rounded),
      ),
    );
  }
  Future<void> _goToTheHome() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_hongik));
  }
}
