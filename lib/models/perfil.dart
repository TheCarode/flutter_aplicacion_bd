import '../services/auth_service.dart';

class Perfil {
  const Perfil({
    required this.uid,
    required this.rol,
    required this.nombre,
    required this.apellido,
    required this.rut,
    required this.email,
    required this.telefono,
    this.especialidad,
  });

  final String uid;
  final Rol rol;
  final String nombre;
  final String apellido;
  final String rut;
  final String email;
  final String telefono;
  final String? especialidad;

  String get nombreCompleto => '$nombre $apellido';

  factory Perfil.desdeDocumento(String uid, Map<String, dynamic> datos) {
    return Perfil(
      uid: uid,
      rol: Rol.desdeId(datos['rol'] as String? ?? 'apoderado'),
      nombre: (datos['nombre'] ?? '').toString(),
      apellido: (datos['apellido'] ?? '').toString(),
      rut: (datos['rut'] ?? '').toString(),
      email: (datos['email'] ?? '').toString(),
      telefono: (datos['telefono'] ?? '').toString(),
      especialidad: datos['especialidad']?.toString(),
    );
  }
}