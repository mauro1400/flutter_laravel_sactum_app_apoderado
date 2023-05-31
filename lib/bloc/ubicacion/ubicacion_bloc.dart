import 'dart:convert';
import 'package:flutter_apoderado/bloc/auth/auth_bloc.dart';
import 'package:flutter_apoderado/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'ubicacion_event.dart';
part 'ubicacion_state.dart';

class UbicacionBloc extends Bloc<UbicacionEvent, UbicacionState> {
  final box = GetStorage();
  UbicacionBloc(BuildContext context) : super(UbicacionInitial()) {
    on<ObtenrUbicacionEvent>((event, emit) async {
      var authenticationState = BlocProvider.of<AuthBloc>(context).state;
      if (authenticationState is AuthSuccess) {
        var idPersona = authenticationState.idPersona;
        var idPersonaApoderado = idPersona;
        try {
          var data = {
            'id_persona_apoderado': idPersonaApoderado,
          };
          var respuesta = await http.wpost(
            Uri.parse('${url}id_persona_chofer'),
            headers: {
              'Accept': 'application/json',
            },
            body: data,
          );

          if (respuesta.statusCode == 200) {
            var idPersonaChofer = json
                .decode(respuesta.body)['id_persona_chofer']['id_persona']
                .toString();
            var idPersona = idPersonaChofer;
            var dato = {
              'id_persona': idPersona,
            };
            var response = await http.wpost(
              Uri.parse('${url}enviarUbicacion'),
              headers: {
                'Accept': 'application/json',
              },
              body: dato,
            );
            if (response.statusCode == 200) {
              var ubicacion = json.decode(response.body);
              var latDouble = ubicacion['data'][0]['lat'];
              var lngDouble = ubicacion['data'][0]['lng'];
              double lat = double.parse(latDouble);
              double lng = double.parse(lngDouble);
              emit(Ubicacion(latitud: lat, longitud: lng));
            } else {
              emit(
                  UbicacionFailure(json.decode(response.body)['errorMessage']));
            }
          } else {
            emit(UbicacionFailure(json.decode(respuesta.body)['errorMessage']));
          }
        } catch (e) {
          debugPrint(e.toString());
          emit(const UbicacionFailure('Algo salió mal. Inténtalo de nuevo.'));
        }
      }
    });
  }
}
