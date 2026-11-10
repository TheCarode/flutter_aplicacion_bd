import 'package:flutter/material.dart';

import '../models/perfil.dart';
import '../screens/inicio_screen.dart';
import '../services/sesion.dart';
import 'bienvenido.dart';
import 'dialogo_cerrar_sesion.dart';

class ItemMenu {
  const ItemMenu(this.etiqueta, this.icono, this.alPresionar);

  final String etiqueta;
  final IconData icono;
  final VoidCallback alPresionar;
}

class MenuPrincipalScreen extends StatefulWidget {
  const MenuPrincipalScreen({
    super.key,
    required this.perfil,
    required this.titulo,
    required this.items,
  });

  final Perfil perfil;
  final String titulo;
  final List<ItemMenu> items;

  @override
  State<MenuPrincipalScreen> createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) mostrarBienvenido(context, widget.perfil.nombre);
    });
  }

  Future<void> _cerrarSesion() async {
    final bool salir = await confirmarCerrarSesion(context);
    if (!salir || !mounted) return;
    Sesion.cerrar();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const InicioScreen()),
      (Route<void> _) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Hola, ${widget.perfil.nombreCompleto}',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              for (final ItemMenu item in widget.items) ...<Widget>[
                SizedBox(
                  height: 52,
                  child: FilledButton.tonalIcon(
                    onPressed: item.alPresionar,
                    icon: Icon(item.icono),
                    label: Text(item.etiqueta),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _cerrarSesion,
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}