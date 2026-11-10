import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/inicio_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    // Ocurre cuando el proyecto nativo ya tiene una app "[DEFAULT]" creada
    // con otra configuracion (por ejemplo, un google-services.json de otro
    // proyecto de Firebase). Se muestra el detalle en vez de romper la app.
    runApp(ErrorFirebaseApp(mensaje: e.message ?? e.code));
    return;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HappyBee!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const InicioScreen(),
    );
  }
}

/// Pantalla mostrada cuando Firebase no pudo inicializarse.
class ErrorFirebaseApp extends StatelessWidget {
  const ErrorFirebaseApp({super.key, required this.mensaje});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      useMaterial3: true,
    );
    return MaterialApp(
      title: 'HappyBee',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        appBar: AppBar(title: const Text('HappyBee')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.error_outline, size: 56),
                const SizedBox(height: 16),
                Text(
                  'No se pudo conectar con Firebase',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  mensaje,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Verifica que lib/firebase_options.dart y la configuracion de '
                  'Android pertenezcan al mismo proyecto de Firebase.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
