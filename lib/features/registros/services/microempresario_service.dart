import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

class MicroempresarioService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Obtener todos los microempresarios registrados por un usuario específico
  Future<List<Map<String, dynamic>>> getMicroempresariosByUsuario(int userId) async {
    try {
      developer.log('Consultando microempresarios para usuario ID: $userId');
      
      final response = await _supabase
          .from('microempresario')
          .select('*, tipo_cliente(tipo)')
          .eq('id_usuario_registro', userId);
      
      developer.log('Consulta SQL: microempresario.select().eq("id_usuario_registro", $userId)');
      developer.log('Microempresarios encontrados: ${response.length}');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      developer.log('Error al consultar microempresarios: $e', error: e);
      throw Exception('Error al consultar microempresarios: $e');
    }
  }
  
  // Registrar una sincronización en el historial
  Future<void> registrarSincronizacion(int userId, int cantidadRegistros, String estado, int recompensa) async {
    try {
      await _supabase.from('historial_sincronizaciones').insert({
        'id_usuario': userId,
        'registros_enviados': cantidadRegistros,
        'estado': estado,
        'recompensa': recompensa
      });
      
      developer.log('Sincronización registrada para usuario ID: $userId');
    } catch (e) {
      developer.log('Error al registrar sincronización: $e', error: e);
      throw Exception('Error al registrar sincronización: $e');
    }
  }
  
  // Obtener información de un usuario por su ID
  Future<Map<String, dynamic>> getUsuarioById(int userId) async {
    try {
      final response = await _supabase
          .from('usuario')
          .select()
          .eq('id_usuario', userId)
          .single();
      
      developer.log('Usuario encontrado: $response');
      return response;
    } catch (e) {
      developer.log('Error al obtener usuario: $e', error: e);
      throw Exception('Error al obtener usuario: $e');
    }
  }
} 