import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            child: const Text('Registrar Usuario'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('productos')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error al cargar los datos.'));
                }

                final productos = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto =
                        productos[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(producto['nombre']),
                      subtitle: Text('\$${producto['precio']}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
