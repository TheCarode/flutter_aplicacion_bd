import 'package:flutter/material.dart';

import '../models/nino.dart';
import '../services/ninos_service.dart';
import '../services/sesion.dart';
import 'detalle_nino_screen.dart';
import 'registro_nino_screen.dart';

class MisHijosScreen extends StatelessWidget {
  const MisHijosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String apoderadoId = Sesion.actual!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis hijos')),
      body: SafeArea(
        child: StreamBuilder<List<Nino>>(
          stream: NinosService.streamDeApoderado(apoderadoId),
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
            final List<Nino> hijos = snapshot.data!;
            if (hijos.isEmpty) {
              return const _BotonRegistrarNino();
            }
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: hijos.length,
                    itemBuilder: (BuildContext context, int i) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            hijos[i].sexo == 'Niña'
                                ? Icons.face_3
                                : Icons.face_6,
                          ),
                        ),
                        title: Text(hijos[i].nombreCompleto),
                        subtitle: Text(
                          'Edad: ${hijos[i].edad} años',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DetalleNinoScreen(nino: hijos[i]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const _BotonRegistrarNino(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BotonRegistrarNino extends StatelessWidget {
  const _BotonRegistrarNino();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const RegistroNinoScreen()),
          ),
          icon: const Icon(Icons.person_add),
          label: const Text('Registrar Niño'),
        ),
      ),
    );
  }
}