import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_apoderado/bloc/ubicacion/ubicacion_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_apoderado/bloc/auth/auth_bloc.dart';

import '../main.dart';

// ignore: constant_identifier_names
const MAPBOX_DOWNLOADS_TOKEN =
    'sk.eyJ1IjoiaGFtZXItMSIsImEiOiJjbGg1Z2plNXMxYndyM3JwajRsNGhudHZoIn0.Rc--5gsSS2uvEQFahKq48w';

class LiveLocationPage extends StatefulWidget {
  const LiveLocationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  late final UbicacionBloc _ubicacionBloc;

  late final MapController _mapController;
  final satelite = '/hamer-1/cldvc6hyn007a01o3dp4i26fh';
  final claro = 'hamer-1/cldvbrb05000401lbc4pddtpo';

  bool _liveUpdate = true;

  final String _serviceError = '';

  int interActiveFlags = InteractiveFlag.all;

  late LatLng currentLatLng;

  late final Timer _timer;

  double latitud = 0.0;

  double longitud = 0.0;

  @override
  void initState() {
    super.initState();
    _liveUpdate = true;
    _mapController = MapController();
    _ubicacionBloc = BlocProvider.of<UbicacionBloc>(context);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      context.read<UbicacionBloc>().add(const ObtenrUbicacionEvent());
    });
    initLocationService();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void initLocationService() async {
    try {
      final location = Location();
      final hasPermission = await location.requestPermission();
      if (hasPermission == PermissionStatus.granted) {
        final currentLocation = await location.getLocation();
        latitud = currentLocation.latitude!;
        longitud = currentLocation.longitude!;
        _mapController.move(LatLng(latitud, longitud), _mapController.zoom);
      }
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UbicacionBloc, UbicacionState>(
        builder: (context, state) {
      if (state is Ubicacion) {
        final latitud = state.latitud;
        final longitud = state.longitud;
        currentLatLng = LatLng(latitud!, longitud!);
      } else {
        currentLatLng = LatLng(latitud, longitud);
      }

      final markers = <Marker>[
        Marker(
          width: 80,
          height: 80,
          point: currentLatLng,
          builder: (ctx) => CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.withOpacity(0.3),
            child: const Icon(Icons.directions_car,

                color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ];

      var size = MediaQuery.of(context).size.width;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ubicacion Actual',
            style: GoogleFonts.poppins(
              fontSize: size * 0.050,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _serviceError.isEmpty
                        ? Text(
                            'Ubicacion actual: (${currentLatLng.latitude}, ${currentLatLng.longitude}).')
                        : Text(
                            'Ocurrió un error al adquirir la ubicación. Mensaje de error: $_serviceError'),
                  ],
                ),
              ),
              Flexible(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center:
                        LatLng(currentLatLng.latitude, currentLatLng.longitude),
                    minZoom: 5,
                    maxZoom: 25,
                    zoom: 18,
                    interactiveFlags: interActiveFlags,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                      additionalOptions: const {
                        'accessToken': MAPBOX_DOWNLOADS_TOKEN,
                        'id': 'hamer-1/cldvbrb05000401lbc4pddtpo'
                      },
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "cerrarSesion",
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutEvent());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: const Icon(Icons.logout),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: "posicion",
              onPressed: () {
                setState(() {
                  _liveUpdate = !_liveUpdate;

                  if (_liveUpdate) {
                    interActiveFlags = InteractiveFlag.rotate |
                        InteractiveFlag.pinchZoom |
                        InteractiveFlag.doubleTapZoom;

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Ubicacion...'),
                    ));
                  } else {
                    interActiveFlags = InteractiveFlag.all;
                  }
                });
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: _liveUpdate
                  ? const Icon(Icons.location_on)
                  : const Icon(Icons.location_off),
            ),
          ],
        ),
      );
    });
  }
}
