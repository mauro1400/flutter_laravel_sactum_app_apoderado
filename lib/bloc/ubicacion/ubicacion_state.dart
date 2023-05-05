part of 'ubicacion_bloc.dart';

class UbicacionState extends Equatable {
  const UbicacionState();
  @override
  List<Object?> get props => [];
}

class Ubicacion extends UbicacionState {
  final double? latitud;
  final double? longitud;

  const Ubicacion({this.latitud, this.longitud});

  @override
  List<Object?> get props => [latitud, longitud];
}

class UbicacionInitial extends UbicacionState {}

class UbicacionLoading extends UbicacionState {}

class UbicacionSuccess extends UbicacionState {
  final String token;

  const UbicacionSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class UbicacionFailure extends UbicacionState {
  final String errorMessage;

  const UbicacionFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  void get error => 'error';
}

