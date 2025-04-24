import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/supabase_constants.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'dart:developer' as developer;

class HistorialScreen extends StatefulWidget {
  final int? userId;

  const HistorialScreen({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  bool isLoading = true;
  String? errorMessage;
  int? _effectiveUserId;
  
  // Listas para almacenar los microempresarios por fecha
  List<Map<String, dynamic>> _microempresariosHoy = [];
  List<Map<String, dynamic>> _microempresariosAyer = [];
  List<Map<String, dynamic>> _microempresariosAnteriores = [];
  
  // Variable para almacenar el texto de búsqueda
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _obtenerIdUsuario();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      
      developer.log('Cargando historial de microempresarios para usuario ID: $_effectiveUserId');
      
      final response = await supabase
          .from('microempresario')
          .select()
          .eq('id_usuario_registro', _effectiveUserId!)
          .order('fecharegistros', ascending: false);
      
      developer.log('Microempresarios encontrados: ${response.length}');
      
      // Obtener las fechas de hoy y ayer
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      
      // Filtrar los microempresarios por fecha
      _microempresariosHoy = [];
      _microempresariosAyer = [];
      _microempresariosAnteriores = [];
      
      for (var microempresario in response as List) {
        try {
          // Convertir la fecha de registro a DateTime
          final fechaRegistroStr = microempresario['fecharegistros'] as String?;
          if (fechaRegistroStr == null) continue;
          
          final fechaRegistro = DateTime.parse(fechaRegistroStr);
          final fechaRegistroSinHora = DateTime(fechaRegistro.year, fechaRegistro.month, fechaRegistro.day);
          
          // Clasificar según la fecha
          if (fechaRegistroSinHora.isAtSameMomentAs(today)) {
            _microempresariosHoy.add(microempresario);
          } else if (fechaRegistroSinHora.isAtSameMomentAs(yesterday)) {
            _microempresariosAyer.add(microempresario);
          } else {
            _microempresariosAnteriores.add(microempresario);
          }
        } catch (e) {
          developer.log('Error al procesar fecha de registro: $e', error: e);
          // Continuar con el siguiente microempresario
          continue;
        }
      }
      
      setState(() {
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

  void _handleSearch(String query) {
    // Implementar búsqueda (opcional)
    developer.log('Buscando: $query');
    // Puedes implementar la búsqueda aquí si es necesario
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
        // Ir a avances
        if (_effectiveUserId != null) {
          Navigator.pushReplacementNamed(
            context, 
            '/avances',
            arguments: _effectiveUserId,
          );
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
        break;
      case 2:
        // Ya estamos en historial, no hacer nada
        break;
      case 3:
        // Ir a perfil
        if (_effectiveUserId != null) {
          Navigator.pushReplacementNamed(
            context, 
            '/perfil',
            arguments: _effectiveUserId,
          );
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
        break;
    }
  }
  
  void _handleAddPressed() {
    if (_effectiveUserId != null) {
      Navigator.pushNamed(
        context, 
        '/microempresarioRegister',
        arguments: _effectiveUserId,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener el ID de usuario'),
          backgroundColor: Colors.red,
        ),
      );
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
          'Historial',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF2196F3),
            child: TextField(
              controller: _searchController,
              onChanged: _handleSearch,
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
                    : _buildHistorialListas(),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2, // Índice 2 corresponde a "Historial"
        onTap: _handleNavBarTap,
        onAddPressed: _handleAddPressed,
      ),
    );
  }

  Widget _buildHistorialListas() {
    final bool noHayRegistros = _microempresariosHoy.isEmpty && 
                               _microempresariosAyer.isEmpty && 
                               _microempresariosAnteriores.isEmpty;
    
    if (noHayRegistros) {
      return const Center(
        child: Text(
          'No hay registros de microempresarios',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Sección de hoy
        if (_microempresariosHoy.isNotEmpty) ...[
          const Text(
            'Hoy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ..._microempresariosHoy.map((micro) => 
            Column(
              children: [
                _buildHistorialItem(
                  '${micro['nombre'] ?? ''} ${micro['apellido1'] ?? ''} ${micro['apellido2'] ?? ''}',
                  _formatearFecha(micro['fecharegistros']),
                ),
                const SizedBox(height: 8),
              ],
            )
          ).toList(),
          const SizedBox(height: 8),
        ],
        
        // Sección de ayer
        if (_microempresariosAyer.isNotEmpty) ...[
          const Text(
            'Ayer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ..._microempresariosAyer.map((micro) => 
            Column(
              children: [
                _buildHistorialItem(
                  '${micro['nombre'] ?? ''} ${micro['apellido1'] ?? ''} ${micro['apellido2'] ?? ''}',
                  _formatearFecha(micro['fecharegistros']),
                ),
                const SizedBox(height: 8),
              ],
            )
          ).toList(),
          const SizedBox(height: 8),
        ],
        
        // Sección de anteriores
        if (_microempresariosAnteriores.isNotEmpty) ...[
          const Text(
            'Anteriores',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ..._microempresariosAnteriores.map((micro) => 
            Column(
              children: [
                _buildHistorialItem(
                  '${micro['nombre'] ?? ''} ${micro['apellido1'] ?? ''} ${micro['apellido2'] ?? ''}',
                  _formatearFecha(micro['fecharegistros']),
                ),
                const SizedBox(height: 8),
              ],
            )
          ).toList(),
        ],
      ],
    );
  }

  Widget _buildHistorialItem(String nombre, String fecha) {
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
                  nombre.trim(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  fecha,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatearFecha(String? fechaStr) {
    if (fechaStr == null) return 'Fecha desconocida';
    
    try {
      final fecha = DateTime.parse(fechaStr);
      
      // Lista de meses en español
      final meses = [
        'Enero', 'Febrero', 'Marzo', 'Abril',
        'Mayo', 'Junio', 'Julio', 'Agosto',
        'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
      ];
      
      // Formato manual: DD Mes YYYY
      return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
    } catch (e) {
      developer.log('Error al formatear fecha: $e', error: e);
      return fechaStr;
    }
  }
} 