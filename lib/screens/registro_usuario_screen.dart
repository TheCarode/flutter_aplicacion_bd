import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/sesion.dart';
import '../utils/validators.dart';
import '../widgets/campos.dart';
import 'inicio_apoderado_screen.dart';
import 'inicio_dentista_screen.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({super.key, required this.esDentista});

  final bool esDentista;

  @override
  State<RegistroUsuarioScreen> createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _apellido = TextEditingController();
  final TextEditingController _rut = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _especialidad = TextEditingController();
  final TextEditingController _numeroRegistro = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  final TextEditingController _confirmar = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _apellido.dispose();
    _rut.dispose();
    _email.dispose();
    _telefono.dispose();
    _especialidad.dispose();
    _numeroRegistro.dispose();
    _contrasena.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  String? _validarConfirmacion(String? valor) {
    if (valor == null || valor.isEmpty) return 'Confirma tu contraseña';
    if (valor != _contrasena.text) return 'Las contraseñas no coinciden';
    return null;
  }

  Future<void> _registrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _cargando = true);

    final Map<String, dynamic> datos = <String, dynamic>{
      'nombre': _nombre.text.trim(),
      'apellido': _apellido.text.trim(),
      'rut': _rut.text.trim(),
      'email': _email.text.trim(),
      'telefono': _telefono.text.trim(),
      'contrasena': _contrasena.text,
      if (widget.esDentista) ...<String, dynamic>{
        'especialidad': _especialidad.text.trim(),
        'numeroRegistro': _numeroRegistro.text.trim(),
      },
    };

    try {
      final perfil = await AuthService.registrar(
        widget.esDentista ? Rol.dentista : Rol.apoderado,
        datos,
      );
      Sesion.abrir(perfil);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => widget.esDentista
              ? const InicioDentistaScreen()
              : const InicioApoderadoScreen(),
        ),
        (Route<void> _) => false,
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
      appBar: AppBar(
        title: Text(
          widget.esDentista ? 'Registro de Dentista' : 'Registro de Apoderado',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                campoTexto(
                  controller: _nombre,
                  etiqueta: 'Nombre',
                  icono: Icons.person,
                  accion: TextInputAction.next,
                  validador: (String? v) => Validators.requerido(v, 'tu nombre'),
                ),
                const SizedBox(height: 16),
                campoTexto(
                  controller: _apellido,
                  etiqueta: 'Apellido',
                  icono: Icons.person_outline,
                  accion: TextInputAction.next,
                  validador: (String? v) =>
                      Validators.requerido(v, 'tu apellido'),
                ),
                const SizedBox(height: 16),
                campoTexto(
                  controller: _rut,
                  etiqueta: 'Rut',
                  icono: Icons.badge,
                  accion: TextInputAction.next,
                  validador: (String? v) => Validators.requerido(v, 'tu RUT'),
                ),
                const SizedBox(height: 16),
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
                  controller: _telefono,
                  etiqueta: 'Telefono',
                  icono: Icons.phone,
                  teclado: TextInputType.phone,
                  accion: TextInputAction.next,
                  validador: (String? v) => Validators.requerido(v, 'tu telefono'),
                ),
                if (widget.esDentista) ...<Widget>[
                  const SizedBox(height: 16),
                  campoTexto(
                    controller: _especialidad,
                    etiqueta: 'Especialidad',
                    icono: Icons.local_hospital,
                    accion: TextInputAction.next,
                    validador: (String? v) =>
                        Validators.requerido(v, 'tu especialidad'),
                  ),
                  const SizedBox(height: 16),
                  campoTexto(
                    controller: _numeroRegistro,
                    etiqueta: 'Numero de registro profesional',
                    icono: Icons.numbers,
                    accion: TextInputAction.next,
                    validador: (String? v) =>
                        Validators.requerido(v, 'tu numero de registro'),
                  ),
                ],
                const SizedBox(height: 16),
                campoTexto(
                  controller: _contrasena,
                  etiqueta: 'Contraseña',
                  icono: Icons.lock,
                  oculto: true,
                  accion: TextInputAction.next,
                  validador: Validators.contrasena,
                ),
                const SizedBox(height: 16),
                campoTexto(
                  controller: _confirmar,
                  etiqueta: 'Confirmar contraseña',
                  icono: Icons.lock_reset,
                  oculto: true,
                  accion: TextInputAction.done,
                  alEnviar: (_) => _registrar(),
                  validador: _validarConfirmacion,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _cargando ? null : _registrar,
                    child: _cargando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Registrarse'),
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
