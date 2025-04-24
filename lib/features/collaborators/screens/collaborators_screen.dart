import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/supabase_constants.dart';
import '../widgets/collaborator_card.dart';
import '../../../routes/app_routes.dart';
import 'dart:developer' as developer;

class CollaboratorsScreen extends StatefulWidget {
  const CollaboratorsScreen({super.key});

  @override
  State<CollaboratorsScreen> createState() => _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends State<CollaboratorsScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> collaborators = [];
  String? errorMessage;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCollaborators();
  }

  Future<void> _loadCollaborators() async {
    try {
      developer.log('Cargando colaboradores desde la base de datos');
      
      final response = await supabase
          .from('usuario')
          .select('id_usuario, nombre, apellido, usuario');
      
      developer.log('Respuesta de Supabase: $response');
      
      // Para cada usuario, obtener el número de registros
      final List<Map<String, dynamic>> processedCollaborators = [];
      
      for (final usuario in response) {
        try {
          // Obtener conteo de registros para este usuario
          final registrosResponse = await supabase
              .from('microempresario')
              .select()
              .eq('id_usuario_registro', usuario['id_usuario']);
          
          final totalRegistros = registrosResponse.length;
          
          processedCollaborators.add({
            'id': usuario['id_usuario'],
            'name': '${usuario['nombre'] ?? ''} ${usuario['apellido'] ?? ''}',
            'registros': totalRegistros.toString(),
            'puntos': '157',
            'puntosCanjeadas': '50',
          });
        } catch (e) {
          developer.log('Error al procesar usuario: $e', error: e);
        }
      }
      
      setState(() {
        collaborators = processedCollaborators;
        isLoading = false;
      });
    } catch (e) {
      developer.log('Error al cargar colaboradores: $e', error: e);
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

  List<Map<String, dynamic>> get filteredCollaborators {
    if (searchQuery.isEmpty) {
      return collaborators;
    }
    
    return collaborators.where((collaborator) {
      return collaborator['name'].toLowerCase().contains(searchQuery);
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
        if (label == 'Microempresario' && !isSelected) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.microempresas,
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
                buildFilterChip('Colaborador de Coppel', true),
                const SizedBox(width: 8),
                buildFilterChip('Microempresario', false),
              ],
            ),
            const SizedBox(height: 16),
            // Lista de colaboradores
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
                      child: filteredCollaborators.isEmpty
                          ? const Center(child: Text('No se encontraron colaboradores'))
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
                                  itemCount: filteredCollaborators.length,
                                  itemBuilder: (context, index) {
                                    final collaborator = filteredCollaborators[index];
                                    return CollaboratorCard(
                                      name: collaborator['name'],
                                      registros: collaborator['registros'],
                                      puntos: collaborator['puntos'],
                                      puntosCanjeadas: collaborator['puntosCanjeadas'],
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