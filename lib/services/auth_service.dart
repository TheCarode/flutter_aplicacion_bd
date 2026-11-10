import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/perfil.dart';

enum Rol {
  dentista('dentista', 'Dentista'),
  apoderado('apoderado', 'Apoderado');

  const Rol(this.id, this.etiqueta);

  final String id;
  final String etiqueta;

  static Rol desdeId(String valor) =>
      values.firstWhere((Rol r) => r.id == valor, orElse: () => Rol.apoderado);
}

class AuthError implements Exception {
  const AuthError(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

class AuthService {
  AuthService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> _coleccion(Rol rol) =>
      _db.collection(rol == Rol.dentista ? 'dentistas' : 'apoderados');

  static Future<Perfil> registrar(Rol rol, Map<String, dynamic> datos) async {
    final DocumentReference<Map<String, dynamic>> ref =
        _coleccion(rol).doc();
    await ref.set(<String, dynamic>{
      ...datos,
      'rol': rol.id,
      'creadoEn': FieldValue.serverTimestamp(),
    });
    return Perfil.desdeDocumento(ref.id, datos);
  }

  static Future<Perfil> iniciarSesion(
    Rol rol,
    String email,
    String contrasena,
  ) async {
    final QuerySnapshot<Map<String, dynamic>> consulta = await _coleccion(rol)
        .where('email', isEqualTo: email.trim())
        .limit(1)
        .get();

    if (consulta.docs.isEmpty) {
      throw const AuthError(
        'No existe ninguna cuenta registrada con ese correo',
      );
    }

    final DocumentSnapshot<Map<String, dynamic>> doc = consulta.docs.first;
    final Map<String, dynamic> datos = doc.data()!;

    if ((datos['contrasena'] ?? '').toString() != contrasena) {
      throw const AuthError('La contraseña es incorrecta');
    }

    return Perfil.desdeDocumento(doc.id, datos);
  }
}