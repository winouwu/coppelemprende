import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/supabase_constants.dart';
import '../widgets/microempresario_card.dart';
import '../../../routes/app_routes.dart';
import 'dart:developer' as developer;

class MicroempresariosScreen extends StatefulWidget {
  const MicroempresariosScreen({super.key});

  @override
  State<MicroempresariosScreen> createState() => _MicroempresariosScreenState();
}

class _MicroempresariosScreenState extends State<MicroempresariosScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> microempresarios = [];
  String? errorMessage;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMicroempresarios();
  }

  Future<void> _loadMicroempresarios() async {
    try {
      developer.log('Cargando microempresarios desde la base de datos');
      
      final response = await supabase
          .from('microempresario')
          .select('id_microempresario, nombre, apellido1, apellido2, cantidad_lecciones');
      
      developer.log('Respuesta de Supabase: $response');
      
      // Procesar los datos para mostrarlos en la UI
      final List<Map<String, dynamic>> processedMicroempresarios = [];
      
      for (final microempresario in response) {
        processedMicroempresarios.add({
          'id': microempresario['id_microempresario'],
          'name': '${microempresario['nombre'] ?? ''} ${microempresario['apellido1'] ?? ''} ${microempresario['apellido2'] ?? ''}',
          'lecciones': microempresario['cantidad_lecciones']?.toString() ?? '0',
          'webinar': '5',
          'llavesCanjeadas': '50',
          'horasSemana': '6',
        });
      }
      
      setState(() {
        microempresarios = processedMicroempresarios;
        isLoading = false;
      });
    } catch (e) {
      developer.log('Error al cargar microempresarios: $e', error: e);
      setState(() {
        errorMessage = 'Error al cargar los datos: $e';
        isLoading = false;
      });
    }
  }

  void _handleSearch(String value) {
    setState(() {
      searchQuery = value.toLowerCase();
    });
  }

  List<Map<String, dynamic>> get filteredMicroempresarios {
    if (searchQuery.isEmpty) {
      return microempresarios;
    }
    
    return microempresarios.where((microempresario) {
      return microempresario['name'].toLowerCase().contains(searchQuery);
    }).toList();
  }

  Widget buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      selected: isSelected,
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 14,
        ),
      ),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF1E3D8F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF1E3D8F) : Colors.grey[300]!,
        ),
      ),
      onSelected: (bool value) {
        if (label == 'Colaborador de Coppel' && !isSelected) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.collaborators,
          );
        }
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.search, color: Colors.grey[600], size: 20),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: _handleSearch,
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.tune, color: Colors.grey[600], size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Filtros
            Row(
              children: [
                buildFilterChip('Colaborador de Coppel', false),
                const SizedBox(width: 8),
                buildFilterChip('Microempresario', true),
              ],
            ),
            const SizedBox(height: 16),
            // Lista de microempresarios
            Expanded(
              child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: filteredMicroempresarios.isEmpty
                          ? const Center(child: Text('No se encontraron microempresarios'))
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final crossAxisCount = constraints.maxWidth > 1200 
                                    ? 4 
                                    : constraints.maxWidth > 800 
                                      ? 3 
                                      : constraints.maxWidth > 600 
                                        ? 2 
                                        : 1;
                                
                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: 2.0,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemCount: filteredMicroempresarios.length,
                                  itemBuilder: (context, index) {
                                    final microempresario = filteredMicroempresarios[index];
                                    return MicroempresarioCard(
                                      name: microempresario['name'],
                                      lecciones: microempresario['lecciones'],
                                      webinar: microempresario['webinar'],
                                      llavesCanjeadas: microempresario['llavesCanjeadas'],
                                      horasSemana: microempresario['horasSemana'],
                                    );
                                  },
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 