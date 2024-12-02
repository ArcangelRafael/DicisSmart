import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Importamos la pantalla de login.

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nuaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'vendedor';

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance.collection('usuarios').add({
          'nombre': _nameController.text,
          'correo': _emailController.text,
          'nua': int.parse(_nuaController.text),
          'rol': _selectedRole,
          'registro_fecha': FieldValue.serverTimestamp(),
          'uid': userCredential.user?.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito')),
        );

        _nameController.clear();
        _emailController.clear();
        _nuaController.clear();
        _passwordController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar usuario: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un correo';
                  }
                  if (!value.contains('@ugto.mx')) {
                    return 'El correo debe ser del dominio @ugto.mx';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nuaController,
                decoration: const InputDecoration(labelText: 'NUA'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu NUA';
                  }
                  if (value.length != 6) {
                    return 'El NUA debe tener 6 dígitos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _selectedRole,
                items: ['vendedor', 'comprador']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text("¿Ya tienes cuenta? Inicia sesión aquí"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
