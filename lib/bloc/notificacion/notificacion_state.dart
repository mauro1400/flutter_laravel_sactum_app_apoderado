part of 'notificacion_bloc.dart';

class NotificacionState extends Equatable {
  const NotificacionState();
  @override
  List<Object?> get props => [];
}

class NotificacionInitial extends NotificacionState {}
class NotificacionSuccess extends AuthState {
  final String idEstado;

  const NotificacionSuccess(this.idEstado);

  @override
  List<Object> get props => [idEstado];
}

class NotificacionFailure extends NotificacionState {
  final String errorMessage;

  const NotificacionFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  void get error => 'error';
}

