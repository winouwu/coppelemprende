import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/widgets/app_scaffold_with_nav.dart';
import '../../../core/widgets/coppel_emprende_logo.dart';
import 'dart:developer' as developer;

class RegistrosScreen extends StatefulWidget {
  final int userId;
  
  const RegistrosScreen({
    super.key,
    required this.userId,
  });

  @override
  State<RegistrosScreen> createState() => _RegistrosScreenState();
}

class _RegistrosScreenState extends State<RegistrosScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _microempresarios = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarMicroempresarios();
  }

  Future<void> _cargarMicroempresarios() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      developer.log('Cargando microempresarios para usuario ID: ${widget.userId}');
      
      final response = await _supabase
          .from('microempresario')
          .select('*, tipo_cliente(tipo)')
          .eq('id_usuario_registro', widget.userId);
      
      developer.log('Microempresarios obtenidos: $response');
      
      setState(() {
        _microempresarios = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Error al cargar microempresarios: $e', error: e);
      setState(() {
        _error = 'Error al cargar registros: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _sincronizarTodos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Aquí implementaríamos la lógica para sincronizar los registros
      // Por ahora simularemos un retraso
      await Future.delayed(const Duration(seconds: 2));
      
      // Registrar la sincronización en historial_sincronizaciones
      await _supabase.from('historial_sincronizaciones').insert({
        'id_usuario': widget.userId,
        'registros_enviados': _microempresarios.length,
        'estado': 'completado',
        'recompensa': _microempresarios.length * 10 // Ejemplo de cálculo de recompensa
      });
      
      // Recargar datos
      await _cargarMicroempresarios();
      
      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registros sincronizados correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      developer.log('Error al sincronizar: $e', error: e);
      setState(() {
        _error = 'Error al sincronizar: $e';
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al sincronizar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleNavBarTap(int index) {
    if (index != 0) {
      // Navegar a otras pantallas según el índice
      switch (index) {
        case 1:
          Navigator.pushReplacementNamed(context, '/avances');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/historial');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/perfil');
          break;
      }
    }
  }

  void _handleAddPressed() {
    Navigator.pushNamed(context, '/microempresas');
  }

  String _formatearFecha(DateTime fecha) {
    // Lista de meses en español
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril',
      'Mayo', 'Junio', 'Julio', 'Agosto',
      'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNav(
      title: '',
      currentIndex: 0,
      onNavTap: _handleNavBarTap,
      onAddPressed: _handleAddPressed,
      appBarContent: const CoppelEmprendeLogo(
        useImage: true, // Utilizamos la imagen del logo si está disponible
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registros no sincronizados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _microempresarios.isEmpty || _isLoading ? null : _sincronizarTodos,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Sincronizar todos',
                          style: TextStyle(fontSize: 14),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(
                        child: Text(
                          _error,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : _microempresarios.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay registros pendientes de sincronización',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _microempresarios.length,
                            itemBuilder: (context, index) {
                              final microempresario = _microempresarios[index];
                              final nombre = '${microempresario['nombre'] ?? ''} ${microempresario['apellido1'] ?? ''} ${microempresario['apellido2'] ?? ''}';
                              
                              // Convertir la fecha de registro a DateTime
                              final fechaRegistro = microempresario['fecharegistros'] != null
                                  ? DateTime.parse(microempresario['fecharegistros'])
                                  : DateTime.now();
                              
                              // Comprobar si está sincronizado (podría implementarse con un campo en la BD)
                              final isSincronizado = false; // Por defecto, consideramos que no está sincronizado
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: _buildRegistroItem(
                                  nombre.trim(),
                                  _formatearFecha(fechaRegistro),
                                  isSincronizado,
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistroItem(String nombre, String fecha, bool isSync) {
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
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSync ? const Color(0xFF2196F3) : const Color(0xFF4CAF50),
            ),
            child: Icon(
              isSync ? Icons.sync : Icons.add,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
} 