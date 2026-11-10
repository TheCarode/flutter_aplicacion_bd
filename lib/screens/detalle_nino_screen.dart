import 'package:flutter/material.dart';

import '../models/nino.dart';

class DetalleNinoScreen extends StatelessWidget {
  const DetalleNinoScreen({super.key, required this.nino});

  final Nino nino;

  String _fecha(DateTime fecha) =>
      '${fecha.day.toString().padLeft(2, '0')}/'
      '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> datos = <MapEntry<String, String>>[
      MapEntry<String, String>('Nombre', nino.nombreCompleto),
      MapEntry<String, String>('Fecha de nacimiento', _fecha(nino.fechaNacimiento)),
      MapEntry<String, String>('Edad', '${nino.edad} años'),
      MapEntry<String, String>('Sexo', nino.sexo),
      MapEntry<String, String>('Apoderado', nino.apoderadoNombre),
      MapEntry<String, String>('Estado', nino.estado),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Datos del niño')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            for (final MapEntry<String, String> fila in datos)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    fila.key,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  subtitle: Text(
                    fila.value,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}