import 'dart:convert';
import 'package:flutter_apoderado/bloc/auth/auth_bloc.dart';
import 'package:flutter_apoderado/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'notificacion_event.dart';
part 'notificacion_state.dart';

class NotificacionBloc extends Bloc<NotificacionEvent, NotificacionState> {
  final box = GetStorage();
  NotificacionBloc(BuildContext context) : super(NotificacionInitial()) {
    on<ObtenerNotificacionEvent>((event, emit) async {
      var authenticationState = BlocProvider.of<AuthBloc>(context).state;
      if (authenticationState is AuthSuccess) {
        var idPersona = authenticationState.idPersona;
        var idPersonaApoderado = idPersona;
        debugPrint(idPersonaApoderado);
        try {
          var data = {
            'id_persona_apoderado': idPersonaApoderado,
          };
          var respuesta = await http.wpost(
            Uri.parse('${url}enviar_mensaje'),
            headers: {
              'Accept': 'application/json',
            },
            body: data,
          );

          if (respuesta.statusCode == 200) {
            var idEstado = json.decode(respuesta.body)['estadoMensaje'][0]['id_estado'];
            print(idEstado);
            //emit(NotificacionSuccess(idEstado));
          } else {
            emit(NotificacionFailure(
                json.decode(respuesta.body)['errorMessage']));
          }
        } catch (e) {
          debugPrint(e.toString());
          emit(
              const NotificacionFailure('Algo salió mal. Inténtalo de nuevo.'));
        }
      }
    });
  }
}
