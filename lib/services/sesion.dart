import '../models/perfil.dart';

class Sesion {
  Sesion._();

  static Perfil? actual;

  static void abrir(Perfil perfil) => actual = perfil;

  static void cerrar() => actual = null;
}