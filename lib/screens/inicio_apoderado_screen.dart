import 'package:flutter/material.dart';

import '../models/perfil.dart';
import '../services/sesion.dart';
import '../widgets/menu_principal.dart';
import 'mis_hijos_screen.dart';
import 'perfil_screen.dart';

class InicioApoderadoScreen extends StatelessWidget {
  const InicioApoderadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Perfil perfil = Sesion.actual!;
    return MenuPrincipalScreen(
      perfil: perfil,
      titulo: 'HappyBee · Apoderado',
      items: <ItemMenu>[
        ItemMenu('Mis hijos', Icons.child_care, () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const MisHijosScreen()),
          );
        }),
        ItemMenu('Mi perfil', Icons.badge, () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PerfilScreen(perfil: perfil),
            ),
          );
        }),
      ],
    );
  }
}