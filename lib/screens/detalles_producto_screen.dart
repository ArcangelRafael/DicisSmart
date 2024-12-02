import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'carrito_screen.dart'; // Importar la clase carrito

class DetallesProductoScreen extends StatefulWidget {
  final String productoId; // ID del producto

  const DetallesProductoScreen({super.key, required this.productoId});

  @override
  State<DetallesProductoScreen> createState() => _DetallesProductoScreenState();
}

class _DetallesProductoScreenState extends State<DetallesProductoScreen> {
  Map<String, dynamic>? producto;
  int cantidad = 1; // Variable para la cantidad seleccionada

  @override
  void initState() {
    super.initState();
    _cargarDetallesProducto();
  }

  // Cargar detalles del producto desde Firestore
  Future<void> _cargarDetallesProducto() async {
    final doc = await FirebaseFirestore.instance
        .collection('productos')
        .doc(widget.productoId)
        .get();

    setState(() {
      producto = doc.data();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (producto == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalles del Producto')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Nombre del producto sin la palabra "Nombre:"
            Text(
              producto!['nombre'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Descripción del producto
            Text(
              producto!['descripcion'] ?? 'Sin descripción disponible',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Precio del producto
            Text('Precio: \$${producto!['precio']}'),
            const SizedBox(height: 10),

            // Disponibilidad del producto
            Text(
              'Disponibilidad: ${producto!['disponibilidad'] ? 'Disponible' : 'No disponible'}',
            ),
            const SizedBox(height: 20),

            // Selector de cantidad
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cantidad: $cantidad',
                  style: const TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (cantidad > 1) cantidad--;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          cantidad++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botones de acción
            ElevatedButton(
              onPressed: () {
                _agregarAlCarrito();
              },
              child: const Text('Añadir al carrito'),
            ),
            ElevatedButton(
              onPressed: () {
                _comprarProducto();
              },
              child: const Text('Comprar ahora'),
            ),
          ],
        ),
      ),
    );
  }

  void _agregarAlCarrito() {
    // Crear el producto que será agregado al carrito
    final productoCarrito = {
      'id': widget.productoId,
      'nombre': producto!['nombre'],
      'precio': producto!['precio'],
      'cantidad': cantidad, // Usamos la cantidad seleccionada
    };

    // Agregar el producto al carrito global
    carrito.agregarProducto(productoCarrito);

    // Navegar al carrito
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CarritoScreen(), // Navegar a la pantalla del carrito
      ),
    );
  }

  void _comprarProducto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto comprado exitosamente!')),
    );
  }
}
