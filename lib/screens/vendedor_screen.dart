import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Asegúrate de tener FirebaseAuth importado
import 'package:cloud_firestore/cloud_firestore.dart';
import 'agregar_producto_screen.dart';
import 'editar_productos_screen.dart';
import '../models/producto.dart'; // Asegúrate de importar el modelo Producto

class VendedorScreen extends StatelessWidget {
  const VendedorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ID del vendedor (usuario autenticado)
    String? vendedorId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Vendedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (vendedorId != null) {
                  // Si el vendedor está autenticado, pasamos su ID al siguiente screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GestionProductosScreen(
                        vendedorId:
                            vendedorId, // Pasamos el vendedorId dinámico
                      ),
                    ),
                  );
                } else {
                  // Si no hay usuario autenticado, mostramos un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No hay un vendedor autenticado.'),
                    ),
                  );
                }
              },
              child: const Text('Gestionar Productos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EstadisticasScreen(),
                  ),
                );
              },
              child: const Text('Ver Estadísticas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VentasRegistradasScreen(),
                  ),
                );
              },
              child: const Text('Ventas Registradas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgregarProductoScreen(),
                  ),
                );
              },
              child: const Text('Agregar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}

class GestionProductosScreen extends StatelessWidget {
  final String vendedorId; // Recibimos el vendedorId

  const GestionProductosScreen({super.key, required this.vendedorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Productos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('productos')
            .where('vendedor_id',
                isEqualTo: vendedorId) // Filtramos por el vendedorId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los productos.'));
          }

          // Comprobamos si hay productos
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          final products = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final productData =
                  products[index].data() as Map<String, dynamic>;

              // Mapeamos el producto usando el modelo Producto
              final producto =
                  Producto.fromMap(products[index].id, productData);

              return ListTile(
                title: Text(producto.nombre),
                subtitle: Text('\$${producto.precio.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarProductosScreen(
                          idProducto: producto.id,
                          nombreInicial: producto.nombre,
                          precioInicial: producto.precio,
                          descripcionInicial: producto.descripcion,
                          categoriaInicial: producto.categoria,
                          disponibilidadInicial: producto.disponibilidad,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Ventas'),
      ),
      body: const Center(
        child: Text('Aquí se mostrarán las estadísticas de ventas.'),
      ),
    );
  }
}

class VentasRegistradasScreen extends StatelessWidget {
  const VentasRegistradasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Ventas'),
      ),
      body: const Center(
        child: Text('Aquí puedes ver tu historial de ventas.'),
      ),
    );
  }
}
