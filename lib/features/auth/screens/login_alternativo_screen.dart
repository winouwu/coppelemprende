import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class LoginAlternativoScreen extends StatelessWidget {
  const LoginAlternativoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            height: 600,
            child: Row(
              children: [
                // Imagen de la izquierda
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                    child: Image.asset(
                      'assets/images/woman.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF1E3D8F),
                          child: Center(
                            child: Text(
                              ' ',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Formulario de inicio de sesión
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Título "Inicia sesión"
                        const Text(
                          'Inicia sesión',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3D8F), // Color azul corporativo
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Campo ID empleado
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'ID empleado',
                            hintText: '000-000-0000',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Campo Contraseña
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                        // Link "¿Olvidaste tu contraseña?"
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Botón de iniciar sesión
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/registros',
                              arguments: 1, // ID usuario de prueba
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3D8F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 