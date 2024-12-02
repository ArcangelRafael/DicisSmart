import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Asegúrate de tener FirebaseAuth importado

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  String _categoriaSeleccionada = 'Dulces'; // Valor inicial de la categoría
  bool _disponibilidad = true;

  // Lista de categorías
  final List<String> _categorias = [
    'Dulces',
    'Papas/Cacahuates',
    'Bebidas',
    'Postres',
    'Comida',
    'FIT',
    'Otros',
  ];

  // Método para agregar producto
  Future<void> _agregarProducto() async {
    try {
      // Obtener el vendedorId (ID del usuario autenticado)
      String? vendedorId = FirebaseAuth.instance.currentUser?.uid;

      // Verificar si el usuario está autenticado
      if (vendedorId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay un vendedor autenticado.')),
        );
        return;
      }

      final producto = {
        'nombre': _nombreController.text,
        'precio': double.parse(_precioController.text),
        'categoria': _categoriaSeleccionada,
        'vendedor_id': vendedorId, // Usamos el ID del vendedor autenticado
        'registro_fecha': DateTime.now().toIso8601String(),
        'disponibilidad': _disponibilidad,
      };

      // Guardar el producto en Firestore
      await FirebaseFirestore.instance.collection('productos').add(producto);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado correctamente.')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar producto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del Producto'),
            ),
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _categoriaSeleccionada,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: _categorias.map((categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSeleccionada = value!;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Disponible'),
              value: _disponibilidad,
              onChanged: (value) {
                setState(() {
                  _disponibilidad = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _agregarProducto,
              child: const Text('Guardar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
