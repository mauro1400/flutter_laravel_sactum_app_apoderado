import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_apoderado/bloc/auth/auth_bloc.dart';
import 'package:flutter_apoderado/bloc/ubicacion/ubicacion_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';

// Esta constante no necesita ser pública, ya que solo se usa en este archivo.
const _mapboxDownloadsToken =
    'sk.eyJ1IjoiaGFtZXItMSIsImEiOiJjbGg1Z2plNXMxYndyM3JwajRsNGhudHZoIn0.Rc--5gsSS2uvEQFahKq48w';

class LiveLocationPage extends StatefulWidget {
  const LiveLocationPage({Key? key}) : super(key: key);

  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  late final MapController _mapController;

  LatLng _currentLatLng = LatLng(0, 0);
  bool _liveUpdate = true;
  late final Timer _timer;
  int _interactiveFlags = InteractiveFlag.all;
  List<LatLng> _previousLocations = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initLocationService();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      context.read<UbicacionBloc>().add(const ObtenrUbicacionEvent());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initLocationService() {
    final ubicacionBloc = BlocProvider.of<UbicacionBloc>(context);

    ubicacionBloc.stream.listen((state) {
      if (state is Ubicacion) {
        final latitud = state.latitud!;
        final longitud = state.longitud!;
        final newLatLng = LatLng(latitud, longitud);

        if (_liveUpdate) {
          _mapController.move(newLatLng, 18);
          setState(() {
            _interactiveFlags = InteractiveFlag.all;
          });
        }

        setState(() {
          _currentLatLng = newLatLng;
          _previousLocations.add(
              newLatLng); // Agregar la ubicación actual a la lista de ubicaciones previas
        });
      } else if (state is UbicacionFailure) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: _currentLatLng,
        builder: (ctx) => CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.withOpacity(0.3),
          child: const Icon(Icons.directions_car,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
    ];

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
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center:
                      LatLng(_currentLatLng.latitude, _currentLatLng.longitude),
                  minZoom: 5,
                  maxZoom: 25,
                  zoom: 18,
                  interactiveFlags: _interactiveFlags,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                    additionalOptions: const {
                      'accessToken': _mapboxDownloadsToken,
                      'id': 'hamer-1/cldvbrb05000401lbc4pddtpo'
                    },
                  ),
                  MarkerLayer(markers: markers),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _previousLocations,
                        strokeWidth: 5,
                        color: Color.fromARGB(255, 255, 0, 0).withOpacity(0.5),
                      ),
                    ],
                  ),
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
                  _interactiveFlags = InteractiveFlag.rotate |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom;

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Ubicacion...'),
                  ));
                } else {
                  _interactiveFlags = InteractiveFlag.all;
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
  }
}
