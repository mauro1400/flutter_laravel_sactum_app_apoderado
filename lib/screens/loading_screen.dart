import 'package:flutter/material.dart';
import 'package:flutter_apoderado/bloc/auth/auth_bloc.dart';
import 'package:flutter_apoderado/screens/login_screen.dart';
import 'package:flutter_apoderado/screens/map_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return const LiveLocationPage();
          } else {
            return const LoginForm();
          }
        },
      ),
    );
  }
}
