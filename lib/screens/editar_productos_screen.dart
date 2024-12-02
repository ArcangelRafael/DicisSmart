import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarProductosScreen extends StatefulWidget {
  final String idProducto;
  final String nombreInicial;
  final double precioInicial;
  final String descripcionInicial;
  final String categoriaInicial;
  final bool disponibilidadInicial;

  const EditarProductosScreen({
    required this.idProducto,
    required this.nombreInicial,
    required this.precioInicial,
    required this.descripcionInicial,
    required this.categoriaInicial,
    required this.disponibilidadInicial,
    Key? key,
  }) : super(key: key);

  @override
  _EditarProductosScreenState createState() => _EditarProductosScreenState();
}

class _EditarProductosScreenState extends State<EditarProductosScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _descripcionController;
  String? _categoriaSeleccionada;
  bool _disponibilidad = false;

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

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores existentes
    _nombreController = TextEditingController(text: widget.nombreInicial);
    _precioController =
        TextEditingController(text: widget.precioInicial.toString());
    _descripcionController =
        TextEditingController(text: widget.descripcionInicial);

    // Verificamos si la categoria inicial está en la lista de categorías
    if (_categorias.contains(widget.categoriaInicial)) {
      _categoriaSeleccionada = widget.categoriaInicial;
    } else {
      // Si no se encuentra, se puede asignar un valor predeterminado
      _categoriaSeleccionada = _categorias.isNotEmpty ? _categorias[0] : null;
    }
    _disponibilidad = widget.disponibilidadInicial;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Función para actualizar el producto
  Future<void> _actualizarProducto() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('productos')
            .doc(widget.idProducto)
            .update({
          'nombre': _nombreController.text,
          'precio': double.parse(_precioController.text),
          'descripcion': _descripcionController.text, // Corregido aquí
          'categoria': _categoriaSeleccionada,
          'disponibilidad': _disponibilidad,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto actualizado correctamente')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el producto: $e')),
        );
      }
    }
  }

  // Función para eliminar el producto
  Future<void> _eliminarProducto() async {
    try {
      await FirebaseFirestore.instance
          .collection('productos')
          .doc(widget.idProducto)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto eliminado correctamente')),
      );

      Navigator.pop(context); // Regresamos a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el producto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de texto para el nombre del producto
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              // Campo de texto para el precio
              TextFormField(
                controller: _precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              // Campo de texto para la descripción
              TextFormField(
                controller:
                    _descripcionController, // Controlador de descripción
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              // Selector de categoría
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                onChanged: (newValue) {
                  setState(() {
                    _categoriaSeleccionada = newValue;
                  });
                },
                items: _categorias
                    .map((categoria) => DropdownMenuItem<String>(
                          value: categoria,
                          child: Text(categoria),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una categoría';
                  }
                  return null;
                },
              ),
              // Switch para la disponibilidad
              SwitchListTile(
                title: const Text('Disponible'),
                value: _disponibilidad,
                onChanged: (value) {
                  setState(() {
                    _disponibilidad = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Botón para guardar los cambios
              ElevatedButton(
                onPressed: _actualizarProducto,
                child: const Text('Guardar Cambios'),
              ),
              const SizedBox(height: 20),
              // Botón para eliminar el producto
              ElevatedButton(
                onPressed: _eliminarProducto,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
