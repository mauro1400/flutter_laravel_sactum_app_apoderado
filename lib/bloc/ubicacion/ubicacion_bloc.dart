import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_apoderado/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'ubicacion_event.dart';
part 'ubicacion_state.dart';

class UbicacionBloc extends Bloc<UbicacionEvent, UbicacionState> {
  UbicacionBloc() : super(UbicacionInitial()) {
    on<ObtenrUbicacionEvent>((event, emit) async {
      try {
        var response = await http.post(
          Uri.parse('${url}enviarUbicacion'),
          headers: {
            'Accept': 'application/json',
          },
          body: [],
        );
        if (response.statusCode == 200) {
          var ubicacion = json.decode(response.body);
          var latDouble = ubicacion['data'][0]['lat'];
          var lngDouble = ubicacion['data'][0]['lng'];
          double lat = double.parse(latDouble);
          double lng = double.parse(lngDouble);
          emit(Ubicacion(latitud: lat, longitud: lng));
          print(lat);
          print(lng);
        } else {
          emit(UbicacionFailure(json.decode(response.body)['errorMessage']));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(const UbicacionFailure('Algo salió mal. Inténtalo de nuevo.'));
      }
    });
  }
}
