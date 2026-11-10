import 'package:flutter/material.dart';

import 'registro_usuario_screen.dart';

class RegistroSelectorScreen extends StatelessWidget {
  const RegistroSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 12),
              Text(
                '¿Cómo te vas a registrar?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RegistroUsuarioScreen(
                        esDentista: false,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.family_restroom),
                  label: const Text('Registrar Apoderado'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RegistroUsuarioScreen(
                        esDentista: true,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.medical_services),
                  label: const Text('Registrar Dentista'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}