class Validators {
  Validators._();

  static String? requerido(String? valor, String etiqueta) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Ingresa $etiqueta';
    }
    return null;
  }

  static String? correo(String? valor) {
    final String v = valor?.trim() ?? '';
    if (v.isEmpty) return 'Ingresa tu correo';
    if (!v.contains('@') || !v.contains('.')) {
      return 'El correo debe contener "@" y "."';
    }
    return null;
  }

  static String? contrasena(String? valor) {
    if (valor == null || valor.isEmpty) return 'Ingresa tu contraseña';
    if (valor.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
    return null;
  }

  static String? edad(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Ingresa la edad';
    final int? numero = int.tryParse(valor.trim());
    if (numero == null) return 'La edad debe ser un número';
    if (numero < 7 || numero > 12) {
      return 'La edad debe estar entre 7 y 12 años';
    }
    return null;
  }
}