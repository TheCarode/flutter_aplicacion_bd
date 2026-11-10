import 'package:flutter/material.dart';

import '../models/perfil.dart';
import '../services/sesion.dart';
import '../widgets/menu_principal.dart';
import 'pacientes_screen.dart';
import 'perfil_screen.dart';

class InicioDentistaScreen extends StatelessWidget {
  const InicioDentistaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Perfil perfil = Sesion.actual!;
    return MenuPrincipalScreen(
      perfil: perfil,
      titulo: 'HappyBee · Dentista',
      items: <ItemMenu>[
        ItemMenu('Mi perfil', Icons.badge, () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PerfilScreen(perfil: perfil),
            ),
          );
        }),
        ItemMenu('Pacientes', Icons.child_care, () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const PacientesScreen()),
          );
        }),
      ],
    );
  }
}