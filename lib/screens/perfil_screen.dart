import 'package:flutter/material.dart';

import '../models/perfil.dart';
import '../services/auth_service.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key, required this.perfil});

  final Perfil perfil;

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> datos =
        <MapEntry<String, String>>[
          MapEntry<String, String>('Nombre', perfil.nombreCompleto),
          if (perfil.rol == Rol.dentista)
            MapEntry<String, String>('Correo', perfil.email),
          if (perfil.rol == Rol.dentista)
            MapEntry<String, String>('Especialidad',
                perfil.especialidad ?? ''),
          if (perfil.rol == Rol.apoderado)
            MapEntry<String, String>('RUT', perfil.rut),
          if (perfil.rol == Rol.apoderado)
            MapEntry<String, String>('Correo', perfil.email),
          if (perfil.rol == Rol.apoderado)
            MapEntry<String, String>('Teléfono', perfil.telefono),
        ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 44,
                child: Text(
                  perfil.nombre.characters.first.toUpperCase(),
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: 24),
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