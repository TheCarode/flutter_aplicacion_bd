import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/ninos_service.dart';
import '../services/sesion.dart';
import '../utils/validators.dart';
import '../widgets/campos.dart';

class RegistroNinoScreen extends StatefulWidget {
  const RegistroNinoScreen({super.key});

  @override
  State<RegistroNinoScreen> createState() => _RegistroNinoScreenState();
}

class _RegistroNinoScreenState extends State<RegistroNinoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _apellido = TextEditingController();
  final TextEditingController _edad = TextEditingController();
  DateTime? _fechaNacimiento;
  String? _sexo;
  bool _cargando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _apellido.dispose();
    _edad.dispose();
    super.dispose();
  }

  String _formatear(DateTime fecha) =>
      '${fecha.day.toString().padLeft(2, '0')}/'
      '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

  Future<void> _elegirFecha() async {
    final DateTime ahora = DateTime.now();
    final DateTime? elegida = await showDatePicker(
      context: context,
      initialDate: DateTime(ahora.year - 9, ahora.month, ahora.day),
      firstDate: DateTime(ahora.year - 18),
      lastDate: ahora,
      helpText: 'Fecha de nacimiento',
    );
    if (elegida != null) setState(() => _fechaNacimiento = elegida);
  }

  Future<void> _registrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la fecha de nacimiento')),
      );
      return;
    }
    setState(() => _cargando = true);

    try {
      await NinosService.crear(<String, dynamic>{
        'nombre': _nombre.text.trim(),
        'apellido': _apellido.text.trim(),
        'fechaNacimiento': Timestamp.fromDate(_fechaNacimiento!),
        'edad': int.parse(_edad.text.trim()),
        'sexo': _sexo,
        'apoderadoId': Sesion.actual!.uid,
        'apoderadoNombre': Sesion.actual!.nombreCompleto,
      });
      if (!mounted) return;
      Navigator.of(context).pop();
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
      appBar: AppBar(title: const Text('Registrar Niño')),
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
                  validador: (String? v) =>
                      Validators.requerido(v, 'el nombre'),
                ),
                const SizedBox(height: 16),
                campoTexto(
                  controller: _apellido,
                  etiqueta: 'Apellido',
                  icono: Icons.person_outline,
                  accion: TextInputAction.next,
                  validador: (String? v) =>
                      Validators.requerido(v, 'el apellido'),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _elegirFecha,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      prefixIcon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _fechaNacimiento == null
                          ? 'Selecciona una fecha'
                          : _formatear(_fechaNacimiento!),
                      style: TextStyle(
                        color: _fechaNacimiento == null
                            ? Theme.of(context).hintColor
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                campoTexto(
                  controller: _edad,
                  etiqueta: 'Edad',
                  icono: Icons.numbers,
                  soloNumeros: true,
                  teclado: TextInputType.number,
                  accion: TextInputAction.next,
                  maxLength: 2,
                  validador: Validators.edad,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _sexo,
                  decoration: const InputDecoration(
                    labelText: 'Sexo',
                    prefixIcon: Icon(Icons.wc),
                    border: OutlineInputBorder(),
                  ),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'Niño',
                      child: Text('Niño'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Niña',
                      child: Text('Niña'),
                    ),
                  ],
                  onChanged: (String? v) => setState(() => _sexo = v),
                  validator: (String? v) =>
                      Validators.requerido(v, 'el sexo'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: Sesion.actual!.nombreCompleto,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Apoderado',
                    prefixIcon: Icon(Icons.family_restroom),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? v) =>
                      Validators.requerido(v, 'el apoderado'),
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
                        : const Text('Registrar'),
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