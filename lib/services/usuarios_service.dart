import 'package:cloud_firestore/cloud_firestore.dart';

class UsuariosService {
  static final CollectionReference<Map<String, dynamic>> _coleccion =
      FirebaseFirestore.instance.collection('usuarios');

  static Future<void> guardarUsuario(String nombre) async {
    await _coleccion.doc().set(<String, dynamic>{'Nombre': nombre});
  }
}
