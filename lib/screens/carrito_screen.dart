import 'package:flutter/material.dart';

// Clase para manejar el carrito
class Carrito {
  List<Map<String, dynamic>> productos = [];

  // Agregar un producto al carrito
  void agregarProducto(Map<String, dynamic> producto) {
    productos.add(producto);
  }

  // Eliminar un producto del carrito
  void eliminarProducto(int index) {
    productos.removeAt(index);
  }

  // Obtener el total del carrito
  double obtenerTotal() {
    double total = 0;
    for (var item in productos) {
      total += item['precio'] * item['cantidad'];
    }
    return total;
  }

  // Limpiar el carrito
  void vaciarCarrito() {
    productos.clear();
  }
}

// Crear una instancia global del carrito
final carrito = Carrito(); // Instancia global del carrito

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  bool _notaActivada = false; // Controla si la casilla de nota está activada
  TextEditingController _notaController =
      TextEditingController(); // Controlador para el campo de texto

  @override
  Widget build(BuildContext context) {
    double total = carrito.obtenerTotal(); // Obtener el total desde el carrito

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Carrito'),
      ),
      body: carrito.productos.isEmpty
          ? const Center(child: Text('El carrito está vacío.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: carrito.productos.length,
                    itemBuilder: (context, index) {
                      final item = carrito.productos[index];

                      return ListTile(
                        title: Text(item['nombre']),
                        subtitle: Text(
                            'Cantidad: ${item['cantidad']} - \$${item['precio']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              carrito.eliminarProducto(
                                  index); // Eliminar producto del carrito
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                // Casilla de verificación para dejar una nota
                CheckboxListTile(
                  title: const Text('Deja una nota para el vendedor'),
                  value: _notaActivada,
                  onChanged: (bool? value) {
                    setState(() {
                      _notaActivada = value ?? false;
                    });
                  },
                ),
                // Campo de texto para la nota (deshabilitado si la casilla no está marcada)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _notaController,
                    enabled:
                        _notaActivada, // Habilitar solo si la casilla está marcada
                    decoration: const InputDecoration(
                      labelText: 'Escribe tu nota aquí...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _realizarCompra();
                  },
                  child: const Text('Finalizar Compra'),
                ),
              ],
            ),
    );
  }

  void _realizarCompra() {
    // Lógica para realizar la compra
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compra realizada con éxito!')),
    );
    setState(() {
      carrito.vaciarCarrito(); // Limpiar el carrito después de la compra
    });
  }
}
