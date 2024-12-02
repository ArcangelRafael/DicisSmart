class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final int nua;
  final String rol;
  final String registroFecha;
  final String password;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.nua,
    required this.rol,
    required this.registroFecha,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'nua': nua,
      'rol': rol,
      'registro_fecha': registroFecha,
      'password': password,
    };
  }

  factory Usuario.fromMap(String id, Map<String, dynamic> data) {
    return Usuario(
      id: id,
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
      nua: data['nua'] ?? 0,
      rol: data['rol'] ?? '',
      registroFecha: data['registro_fecha'] ?? '',
      password: data['password'] ?? '',
    );
  }
}
