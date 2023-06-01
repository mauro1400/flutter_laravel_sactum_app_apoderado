import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String message;

  const CustomAlertDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mensaje emergente'),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Aceptar'),
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el diálogo
          },
        ),
      ],
    );
  }
}
