import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/supabase_constants.dart';
import 'dart:developer' as developer;

class PerfilScreen extends StatefulWidget {
  final int? userId;

  const PerfilScreen({super.key, this.userId});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? userData;
  int totalRegistros = 0;
  int? _effectiveUserId;
  
  @override
  void initState() {
    super.initState();
    _obtenerIdUsuario();
  }
  
  Future<void> _obtenerIdUsuario() async {
    try {
      developer.log('Iniciando obtención de ID de usuario');
      
      // Si ya tenemos el ID del usuario, usarlo directamente
      if (widget.userId != null) {
        _effectiveUserId = widget.userId;
        developer.log('Usando ID de usuario proporcionado: $_effectiveUserId');
        _cargarDatosUsuario();
        return;
      }
      
      // De lo contrario, intentar obtenerlo desde la sesión actual
      final user = supabase.auth.currentUser;
      
      if (user == null) {
        developer.log('No hay usuario logueado');
        setState(() {
          isLoading = false;
          errorMessage = 'No hay usuario logueado';
        });
        return;
      }
      
      developer.log('Usuario autenticado UUID: ${user.id}');
      
      // Obtener el id_usuario desde la tabla usuario basado en el email
      final userData = await supabase
          .from('usuario')
          .select('id_usuario')
          .eq('email', user.email ?? '')
          .maybeSingle();

      if (userData == null) {
        developer.log('No se encontró el usuario en la tabla usuario');
        setState(() {
          isLoading = false;
          errorMessage = 'No se encontró información del usuario';
        });
        return;
      }

      _effectiveUserId = userData['id_usuario'] as int;
      developer.log('ID de usuario numérico obtenido: $_effectiveUserId');
      
      _cargarDatosUsuario();
    } catch (e) {
      developer.log('Error al obtener ID de usuario: $e', error: e);
      setState(() {
        isLoading = false;
        errorMessage = 'Error al obtener información del usuario: $e';
      });
    }
  }
  
  Future<void> _cargarDatosUsuario() async {
    try {
      if (_effectiveUserId == null) {
        developer.log('No se pudo obtener un ID de usuario válido');
        setState(() {
          isLoading = false;
          errorMessage = 'No se pudo obtener un ID de usuario válido';
        });
        return;
      }
      
      developer.log('Cargando datos del usuario ID: $_effectiveUserId');
      
      // Obtener datos del usuario desde la tabla usuario
      final userDataResponse = await supabase
          .from('usuario')
          .select()
          .eq('id_usuario', _effectiveUserId!)
          .maybeSingle();

      if (userDataResponse == null) {
        developer.log('No se encontró el usuario con ID: $_effectiveUserId');
        setState(() {
          isLoading = false;
          errorMessage = 'No se encontró información del usuario';
        });
        return;
      }
      
      userData = userDataResponse;
      developer.log('Datos de usuario obtenidos: $userData');
      
      // Obtener conteo de registros de microempresarios
      final registrosResponse = await supabase
          .from('microempresario')
          .select()
          .eq('id_usuario_registro', _effectiveUserId!);
      
      // Calcular el total de registros
      totalRegistros = registrosResponse.length;
      
      developer.log('Total de registros: $totalRegistros');
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      developer.log('Error al cargar datos del usuario: $e', error: e);
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar datos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_effectiveUserId != null) {
              Navigator.pushReplacementNamed(
                context, 
                '/registros',
                arguments: _effectiveUserId,
              );
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF2196F3),
                            const Color(0xFF2196F3).darker(),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${userData!['nombre'] ?? ''} ${userData!['apellido'] ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID empleado: ${userData!['usuario'] ?? '000-000-0000'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Puntos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF2196F3),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '500',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Registros',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF2196F3),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$totalRegistros',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildBeneficioItem('Días de vacaciones', 0.75),
                          const SizedBox(height: 16),
                          _buildBeneficioItem('30% de descuento en tienda', 0.45),
                          const SizedBox(height: 16),
                          _buildBeneficioItem('Incentivo en nómina', 0.25),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildBeneficioItem(String titulo, double progreso) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CircularPercentIndicator(
            radius: 20.0,
            lineWidth: 4.0,
            animation: true,
            percent: progreso,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color(0xFF2196F3),
            backgroundColor: Colors.grey[300]!,
          ),
        ],
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darker() {
    const double factor = 0.8;
    return Color.fromARGB(
      alpha,
      (red * factor).round(),
      (green * factor).round(),
      (blue * factor).round(),
    );
  }
} 