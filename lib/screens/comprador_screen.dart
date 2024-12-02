import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detalles_producto_screen.dart';

class CompradorScreen extends StatelessWidget {
  const CompradorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Disponibles'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, snapshot) {
          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // No hay productos
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          // Productos disponibles
          final productos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              final data = producto.data() as Map<String, dynamic>;

              // Generar el widget para cada producto
              return ListTile(
                title: Text(data['nombre']),
                subtitle: Text(
                    'Precio: \$${data['precio']} - Categoría: ${data['categoria']}'),
                trailing: data['disponibilidad']
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.cancel, color: Colors.red),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesProductoScreen(
                        productoId: producto.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
