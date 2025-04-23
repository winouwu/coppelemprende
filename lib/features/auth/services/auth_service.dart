import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      developer.log('Iniciando proceso de login desde AuthService');
      developer.log('Usuario: $username');
      
      final response = await _supabase
          .from('usuario')
          .select()
          .eq('usuario', username)
          .eq('password', password)
          .single();
      
      developer.log('Respuesta de Supabase: $response');
      return response;
    } catch (e) {
      developer.log('Error durante el login: $e', error: e);
      return null;
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await _supabase
          .from('usuario')
          .select()
          .order('id_usuario');
      
      return response;
    } catch (e) {
      developer.log('Error al obtener usuarios: $e', error: e);
      return [];
    }
  }
} 