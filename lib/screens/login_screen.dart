import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/sesion.dart';
import '../utils/validators.dart';
import '../widgets/campos.dart';
import 'inicio_apoderado_screen.dart';
import 'inicio_dentista_screen.dart';
import 'registro_selector_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  Rol _rol = Rol.apoderado;
  bool _cargando = false;

  @override
  void dispose() {
    _email.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _cargando = true);

    try {
      final perfil = await AuthService.iniciarSesion(
        _rol,
        _email.text,
        _contrasena.text,
      );
      Sesion.abrir(perfil);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => perfil.rol == Rol.dentista
              ? const InicioDentistaScreen()
              : const InicioApoderadoScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesion')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SegmentedButton<Rol>(
                  segments: const <ButtonSegment<Rol>>[
                    ButtonSegment<Rol>(
                      value: Rol.apoderado,
                      label: Text('Apoderado'),
                      icon: Icon(Icons.family_restroom),
                    ),
                    ButtonSegment<Rol>(
                      value: Rol.dentista,
                      label: Text('Dentista'),
                      icon: Icon(Icons.medical_services),
                    ),
                  ],
                  selected: <Rol>{_rol},
                  onSelectionChanged: (Set<Rol> s) =>
                      setState(() => _rol = s.first),
                ),
                const SizedBox(height: 24),
                campoTexto(
                  controller: _email,
                  etiqueta: 'Correo electronico',
                  icono: Icons.email,
                  teclado: TextInputType.emailAddress,
                  accion: TextInputAction.next,
                  validador: Validators.correo,
                ),
                const SizedBox(height: 16),
                campoTexto(
                  controller: _contrasena,
                  etiqueta: 'Contraseña',
                  icono: Icons.lock,
                  oculto: true,
                  accion: TextInputAction.done,
                  alEnviar: (_) => _entrar(),
                  validador: (String? v) =>
                      Validators.requerido(v, 'tu contraseña'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _cargando ? null : _entrar,
                    child: _cargando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Entrar'),
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: _cargando
                      ? null
                      : () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => const RegistroSelectorScreen(),
                            ),
                          ),
                  child: const Text(
                    '¿No estas registrado? Registrate aqui',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}