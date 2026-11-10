import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField campoTexto({
  required TextEditingController controller,
  required String etiqueta,
  required IconData icono,
  required String? Function(String?) validador,
  TextInputType? teclado,
  bool oculto = false,
  bool soloNumeros = false,
  TextInputAction? accion,
  void Function(String)? alEnviar,
  int? maxLength,
}) {
  return TextFormField(
    controller: controller,
    obscureText: oculto,
    keyboardType: teclado ??
        (soloNumeros
            ? TextInputType.number
            : (oculto ? TextInputType.text : TextInputType.text)),
    textInputAction: accion,
    onFieldSubmitted: alEnviar,
    maxLength: maxLength,
    inputFormatters: soloNumeros
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
        : null,
    validator: validador,
    decoration: InputDecoration(
      labelText: etiqueta,
      prefixIcon: Icon(icono),
      border: const OutlineInputBorder(),
    ),
  );
}