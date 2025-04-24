import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_routes.dart';
import 'dart:developer' as developer;
import '../../../core/constants/supabase_constants.dart';

class LoginAlternativoScreen extends StatefulWidget {
  const LoginAlternativoScreen({super.key});

  @override
  State<LoginAlternativoScreen> createState() => _LoginAlternativoScreenState();
}

class _LoginAlternativoScreenState extends State<LoginAlternativoScreen> {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    if (_userIdController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor ingresa todos los campos';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      developer.log('Iniciando proceso de login alternativo');
      developer.log('Usuario: ${_userIdController.text}');
      
      // Intentamos el login verificando usuario, contraseña y tipo_usuario
      final response = await supabase
          .from('usuario')
          .select()
          .eq('usuario', _userIdController.text)
          .eq('password', _passwordController.text)
          .eq('tipo_usuario', true) // Añadimos la verificación de tipo_usuario = true
          .maybeSingle();

      developer.log('Respuesta de Supabase: $response');

      if (response == null) {
        throw Exception('Credenciales inválidas o usuario sin permisos');
      }

      if (mounted) {
        final userId = response['id_usuario'] as int;
        developer.log('Login exitoso. ID de usuario: $userId');
        
        // Navegar a la pantalla de registros pasando el ID del usuario
        Navigator.pushReplacementNamed(
          context,
          '/registros',
          arguments: userId,
        );
      }
    } catch (e) {
      developer.log('Error durante el login: $e', error: e);
      if (mounted) {
        setState(() {
          _errorMessage = 'Usuario o contraseña incorrectos, o no tienes permisos de acceso';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                          controller: _userIdController,
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
                          controller: _passwordController,
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
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 24),
                        // Botón de iniciar sesión
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3D8F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
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
  
  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 