import 'package:flutter/material.dart';
import 'package:flutter_apoderado/bloc/ubicacion/ubicacion_bloc.dart';
import 'package:flutter_apoderado/screens/loading_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_apoderado/bloc/auth/auth_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => UbicacionBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}
