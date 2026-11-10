import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/nino.dart';

class NinosService {
  NinosService._();

  static final CollectionReference<Map<String, dynamic>> _coleccion =
      FirebaseFirestore.instance.collection('ninos');

  static Stream<List<Nino>> streamTodos() => _coleccion
      .orderBy('creadoEn', descending: true)
      .snapshots()
      .map(
        (QuerySnapshot<Map<String, dynamic>> s) =>
            s.docs.map((d) => Nino.desdeDocumento(d.id, d.data())).toList(),
      );

  static Stream<List<Nino>> streamDeApoderado(String apoderadoId) => _coleccion
      .where('apoderadoId', isEqualTo: apoderadoId)
      .snapshots()
      .map(
        (QuerySnapshot<Map<String, dynamic>> s) =>
            s.docs.map((d) => Nino.desdeDocumento(d.id, d.data())).toList(),
      );

  static Future<void> crear(Map<String, dynamic> datos) => _coleccion.doc().set(
    <String, dynamic>{
      ...datos,
      'estado': 'Bueno',
      'creadoEn': FieldValue.serverTimestamp(),
    },
  );
}