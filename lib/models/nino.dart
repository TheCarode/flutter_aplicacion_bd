import 'package:cloud_firestore/cloud_firestore.dart';

class Nino {
  const Nino({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.edad,
    required this.sexo,
    required this.estado,
    required this.apoderadoId,
    required this.apoderadoNombre,
  });

  final String id;
  final String nombre;
  final String apellido;
  final DateTime fechaNacimiento;
  final int edad;
  final String sexo;
  final String estado;
  final String apoderadoId;
  final String apoderadoNombre;

  String get nombreCompleto => '$nombre $apellido';

  factory Nino.desdeDocumento(String id, Map<String, dynamic> datos) {
    final dynamic fecha = datos['fechaNacimiento'];
    return Nino(
      id: id,
      nombre: (datos['nombre'] ?? '').toString(),
      apellido: (datos['apellido'] ?? '').toString(),
      fechaNacimiento: fecha is Timestamp
          ? fecha.toDate()
          : DateTime.now(),
      edad: (datos['edad'] as num?)?.toInt() ?? 0,
      sexo: (datos['sexo'] ?? '').toString(),
      estado: (datos['estado'] ?? 'Bueno').toString(),
      apoderadoId: (datos['apoderadoId'] ?? '').toString(),
      apoderadoNombre: (datos['apoderadoNombre'] ?? '').toString(),
    );
  }
}