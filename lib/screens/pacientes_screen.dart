import 'package:flutter/material.dart';

import '../models/nino.dart';
import '../services/ninos_service.dart';

class PacientesScreen extends StatelessWidget {
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: SafeArea(
        child: StreamBuilder<List<Nino>>(
          stream: NinosService.streamTodos(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Nino>> snapshot,
          ) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<Nino> ninos = snapshot.data!;
            if (ninos.isEmpty) {
              return const Center(
                child: Text('Todavía no hay niños registrados'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ninos.length,
              itemBuilder: (BuildContext context, int i) =>
                  TarjetaNino(nino: ninos[i], mostrarApoderado: true),
            );
          },
        ),
      ),
    );
  }
}

class TarjetaNino extends StatelessWidget {
  const TarjetaNino({super.key, required this.nino, this.mostrarApoderado = false});

  final Nino nino;
  final bool mostrarApoderado;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(nino.sexo == 'Niña' ? Icons.face_3 : Icons.face_6),
        ),
        title: Text(nino.nombreCompleto),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Edad: ${nino.edad} años'),
            Text('Estado: ${nino.estado}'),
            if (mostrarApoderado)
              Text('Apoderado: ${nino.apoderadoNombre}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}