import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_apoderado/utils/constants.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final box = GetStorage();
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        var data = {
          'email': event.email,
          'password': event.password,
        };
        var response = await http.wpost(
          Uri.parse('${url}login'),
          headers: {
            'Accept': 'application/json',
          },
          body: data,
        );
        if (response.statusCode == 200) {
          var token = json.decode(response.body)['token'];
          var idPersona = json.decode(response.body)['user']['id_persona'].toString();
          box.write('id_persona', idPersona);
          box.write('token', token);
          emit(AuthSuccess(token,idPersona));
        } else {
          AuthFailure(json.decode(response.body)['errorMessage']);
        }
      } catch (e) {
        debugPrint(e.toString());
        const AuthFailure('Algo salió mal. Inténtalo de nuevo.');
      }
    });
    on<LogoutEvent>((event, emit) async {
      var token = box.read('token');
      var response = await http.wpost(
        Uri.parse('${url}logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        box.remove('token');
        emit(AuthInitial());
      } else {
        emit(AuthFailure(json.decode(response.body)['errorMessage']));
      }
    });
  }
}
