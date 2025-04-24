import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/supabase_constants.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'dart:developer' as developer;

class AvancesScreen extends StatefulWidget {
  final int? userId; // Id de usuario opcional

  const AvancesScreen({super.key, this.userId});

  @override
  State<AvancesScreen> createState() => _AvancesScreenState();
}

class _AvancesScreenState extends State<AvancesScreen> {
  List<Map<String, dynamic>> microempresarios = [];
  bool isLoading = true;
  String? errorMessage;
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
        _cargarMicroempresarios();
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
      
      _cargarMicroempresarios();
    } catch (e) {
      developer.log('Error al obtener ID de usuario: $e', error: e);
      setState(() {
        isLoading = false;
        errorMessage = 'Error al obtener información del usuario: $e';
      });
    }
  }

  Future<void> _cargarMicroempresarios() async {
    try {
      if (_effectiveUserId == null) {
        developer.log('No se pudo obtener un ID de usuario válido');
        setState(() {
          isLoading = false;
          errorMessage = 'No se pudo obtener un ID de usuario válido';
        });
        return;
      }
      
      developer.log('Cargando microempresarios para usuario ID: $_effectiveUserId');
      
      final response = await supabase
          .from('microempresario')
          .select()
          .eq('id_usuario_registro', _effectiveUserId!);
      
      developer.log('Microempresarios encontrados: ${response.length}');
      
      setState(() {
        microempresarios = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      developer.log('Error al cargar microempresarios: $e', error: e);
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
          'Avances',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF2196F3),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : microempresarios.isEmpty
                        ? const Center(child: Text('No hay microempresarios registrados'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: microempresarios.length,
                            itemBuilder: (context, index) {
                              final microempresario = microempresarios[index];
                              final nombre = microempresario['nombre'] ?? 'Sin nombre';
                              final cantidadLecciones = microempresario['cantidad_lecciones'] ?? 0;
                              
                              return Column(
                                children: [
                                  EstudianteAvanceCard(
                                    nombre: nombre,
                                    leccionesCompletadas: cantidadLecciones,
                                    totalLecciones: 20,
                                  ),
                                  // Añadir espacio entre elementos, excepto después del último
                                  if (index < microempresarios.length - 1)
                                    const SizedBox(height: 8),
                                ],
                              );
                            },
                          ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1, // Índice 1 corresponde a "Avances"
        onTap: _handleNavBarTap,
        onAddPressed: _handleAddPressed,
      ),
    );
  }
  
  void _handleNavBarTap(int index) {
    switch (index) {
      case 0:
        // Ir a la pantalla de inicio (registros)
        if (_effectiveUserId != null) {
          Navigator.pushReplacementNamed(
            context, 
            '/registros',
            arguments: _effectiveUserId,
          );
        } else {
          // Si no hay ID de usuario, ir al login
          Navigator.pushReplacementNamed(context, '/login');
        }
        break;
      case 1:
        // Ya estamos en avances, no hacer nada
        break;
      case 2:
        // Ir a historial
        Navigator.pushReplacementNamed(context, '/historial');
        break;
      case 3:
        // Ir a perfil
        Navigator.pushReplacementNamed(context, '/perfil');
        break;
    }
  }
  
  void _handleAddPressed() {
    Navigator.pushNamed(context, '/microempresas');
  }
}

class EstudianteAvanceCard extends StatelessWidget {
  final String nombre;
  final int leccionesCompletadas;
  final int totalLecciones;

  const EstudianteAvanceCard({
    super.key,
    required this.nombre,
    required this.leccionesCompletadas,
    required this.totalLecciones,
  });

  @override
  Widget build(BuildContext context) {
    final double progreso = leccionesCompletadas / totalLecciones;
    final int porcentaje = (progreso * 100).round();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$leccionesCompletadas lecciones completadas de $totalLecciones lecciones',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularPercentIndicator(
            radius: 20.0,
            lineWidth: 4.0,
            animation: true,
            percent: progreso,
            center: Text(
              '$porcentaje%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color(0xFF2196F3),
            backgroundColor: Colors.grey[300]!,
          ),
        ],
      ),
    );
  }
} 