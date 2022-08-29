import 'dart:async';
import 'dart:convert';

import 'package:checkpoint_segursat/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  var locationMessage = "";
  double _latitude = 0;
  double _longitude = 0;
  bool _visible = false;
  // ignore: prefer_typing_uninitialized_variables
  var args;
  final List<Marker> _marker = [];

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(-9.189967, -75.015152), zoom: 8);

  @override
  void initState() {
    _updatePosition();
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _visible = !_visible;
      });
    });

    // _marker.addAll(_list);
  }

  Future<void> _updatePosition() async {
    Position pos = await _determinePosition();

    locationMessage = 'Lat: $_latitude, Long: $_longitude';
    // ignore: avoid_print
    print(locationMessage);

    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(1, 5)),
      'assets/images/marker.png',
    );

    setState(() {
      _latitude = pos.latitude;
      _longitude = pos.longitude;
    });

    _marker.add(Marker(
      markerId: const MarkerId('1'),
      icon: markerbitmap,
      // position: const LatLng(-12.0937474, -77.0604817),
      position: LatLng(_latitude, _longitude),
      // infoWindow: const InfoWindow(title: 'User'),
    ));

    CameraPosition cameraPosition = CameraPosition(
      zoom: 16,
      target: LatLng(_latitude, _longitude),
      // target: LatLng(-12.0937474, -77.0604817),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // final List<Marker> _list = const [
  //   Marker(
  //       markerId: MarkerId('1'),
  //       position: LatLng(-9.189967, -75.015152),
  //       infoWindow: InfoWindow(title: 'My current location')),
  // ];

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        await Geolocator.openLocationSettings();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await Geolocator.openLocationSettings();
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments
        as Map<String, Map<String, dynamic>>;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(child: _createMap()),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(children: [
                  SizedBox(
                    width: 50,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFFF8951D),
                      onPressed: _updatePosition,
                      child: const Icon(Icons.location_disabled_outlined,
                          color: Colors.white),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _visible ? 1.0 : 0.0,
          child: ElevatedButton(
              onPressed: () async {
                try {
                  ApiServices.getGeolocation(_latitude, _longitude).then((res) {
                    if (res.statusCode == 200) {
                      setState(() {
                        var resFormat = json.decode(res.body);
                        if (resFormat['status'] == false) {
                          _invalidCheck(
                              text: "Estas fuera del punto de control",
                              image: 'perdido.png');
                        } else {
                          args['geozone']['name'] = resFormat['geofence_name'];
                          _validCheck(resFormat['geofence_name']);
                        }
                      });
                    }
                  });
                } catch (e) {
                  // ignore: avoid_print
                  print('->> fallo de conexion: $e');
                  _invalidCheck();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: const Color(0xFFF8951D),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Text('Validar',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 16,
                    )),
              )),
        ),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       const Icon(Icons.location_on,
        //           size: 46.0, color: Color(0xFFF8951D)),
        //       const SizedBox(
        //         height: 20.0,
        //       ),
        //       const Text(
        //         'Get user location',
        //         style: TextStyle(
        //             fontSize: 26.0,
        //             fontWeight: FontWeight.bold,
        //             color: Color(0xFFF4F4F8)),
        //       ),
        //       const SizedBox(
        //         height: 20.0,
        //       ),
        //       Text("Position : $locationMessage",
        //           style: const TextStyle(color: Color(0xFFF4F4F8))),
        //       const SizedBox(
        //         height: 20.0,
        //       ),
        //       TextButton(
        //         onPressed: _updatePosition,
        //         style: TextButton.styleFrom(
        //             primary: const Color(0xFFF4F4F8),
        //             backgroundColor: const Color(0xFFF8951D)),
        //         child: const Text('Get Current Location'),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Widget _createMap() {
    return GoogleMap(
      initialCameraPosition: _kGooglePlex,
      myLocationButtonEnabled: false,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      markers: Set<Marker>.of(_marker),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  _validCheck(String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2)),
                    child: Image.asset('assets/images/validado.jpg')),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'POSICIÓN CORRECTAMENTE VALIDADA',
                      style: GoogleFonts.openSans(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      text,
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          args['statement']['lat'] = _latitude;
                          args['statement']['long'] = _longitude;

                          args['statement']['state'] = true;
                          args['geozone']['state'] = true;

                          Navigator.pushNamed(context, '/gallery',
                              arguments: args);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: const Color(0xFFF8951D),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Text('Aceptar',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 16,
                              )),
                        )),
                  ],
                ),
              ),
            ));
  }

  _invalidCheck(
      {String text = "Hubo un problema con la conexión a internet",
      String image = "lost.jpg"}) {
    showDialog(
        context: context,
        builder: (_) => WillPopScope(
              onWillPop: () async => true,
              child: AlertDialog(
                title: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2)),
                    child: Image.asset('assets/images/$image')),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(),
                        child: Text(
                          text,
                          style: GoogleFonts.openSans(fontSize: 22),
                          textAlign: TextAlign.center,
                        )),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: const Color(0xFFF8951D),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Text('Aceptar',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 16,
                              )),
                        )),
                  ],
                ),
              ),
            ));
  }
}
