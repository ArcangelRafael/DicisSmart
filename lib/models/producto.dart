class Producto {
  String id;
  String nombre;
  double precio;
  String descripcion; // Agregamos la propiedad descripcion
  String categoria;
  String vendedorId;
  DateTime registroFecha;
  bool disponibilidad; // El campo disponibilidad ya está presente

  // Constructor actualizado para incluir descripcion
  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion, // Agregar descripcion en el constructor
    required this.categoria,
    required this.vendedorId,
    required this.registroFecha,
    required this.disponibilidad, // Inicializamos disponibilidad en el constructor
  });

  // Método toMap para convertir el objeto a un mapa de datos
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion, // Asegúrate de incluir descripcion en el mapa
      'categoria': categoria,
      'vendedor_id': vendedorId,
      'registro_fecha': registroFecha.toIso8601String(),
      'disponibilidad':
          disponibilidad, // Asegúrate de incluir disponibilidad en el mapa
    };
  }

  // Factory constructor para crear una instancia de Producto desde un mapa
  factory Producto.fromMap(String id, Map<String, dynamic> data) {
    return Producto(
      id: id,
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] ?? 0).toDouble(),
      descripcion:
          data['descripcion'] ?? '', // Asegúrate de tomar descripcion del mapa
      categoria: data['categoria'] ?? '',
      vendedorId: data['vendedor_id'] ?? '',
      registroFecha: DateTime.parse(
        data['registro_fecha'] ?? DateTime.now().toIso8601String(),
      ),
      disponibilidad: data['disponibilidad'] ??
          false, // Asegúrate de incluir disponibilidad en el modelo
    );
  }
}
