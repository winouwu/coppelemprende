import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final int userId;
  
  const RegisterScreen({
    super.key, 
    required this.userId,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Microempresario'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenido, Usuario ID: ${widget.userId}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aquí puedes registrar a un nuevo microempresario',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 