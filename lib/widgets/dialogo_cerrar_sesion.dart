import 'package:flutter/material.dart';

Future<bool> confirmarCerrarSesion(BuildContext context) async {
  final bool? resultado = await showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Estás seguro de cerrar sesión?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );
  return resultado ?? false;
}