import 'package:flutter/material.dart';

class ProductosScreen extends StatelessWidget {
  const ProductosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: Center(
        child: Text('Aquí van los productos'),
      ),
    );
  }
}
