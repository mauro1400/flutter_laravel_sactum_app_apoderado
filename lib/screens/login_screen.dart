import 'package:flutter/material.dart';
import 'package:flutter_apoderado/bloc/auth/auth_bloc.dart';
import 'package:flutter_apoderado/widget/input_widget_e.dart';
import 'package:flutter_apoderado/widget/input_widget_p.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final bool _passwordObscure = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'ACCESO APODERADO',
              style: GoogleFonts.poppins(fontSize: size * 0.080),
            ),
            Text(
              '¡Por favor, introduce tu usuario y contraseña!',
              style: GoogleFonts.poppins(fontSize: size * 0.040),
            ),
            const SizedBox(
              height: 30,
            ),
            InputWidgetEmail(
              hintText: 'Email',
              obscureText: false,
              controller: emailController,
            ),
            const SizedBox(
              height: 20,
            ),
            InputWidgetPassword(
              hintText: 'Password',
              obscureText: _passwordObscure,
              controller: passwordController,
            ),
            const SizedBox(
              height: 30,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                    ),
                  );
                } else if (state is AuthSuccess) {
                  // navigate to home page or any other page
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      )),
                  onPressed: () async {
                    context.read<AuthBloc>().add(LoginEvent(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ));
                  },
                  child: state is AuthLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Iniciar Sesion',
                          style: GoogleFonts.poppins(fontSize: size * 0.040),
                        ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
