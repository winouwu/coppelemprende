import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/supabase_constants.dart';
import 'dart:developer' as developer;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Esperar 3 segundos para mostrar la pantalla de carga
    await Future.delayed(const Duration(seconds: 3));
    
    // Verificar si hay un usuario autenticado
    try {
      final user = supabase.auth.currentUser;
      
      if (user == null) {
        // Si no hay usuario, navegar a login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }
      
      // Obtener el ID del usuario de la tabla usuario
      final userData = await supabase
          .from('usuario')
          .select('id_usuario')
          .eq('email', user.email ?? '')
          .maybeSingle();
      
      if (userData == null) {
        // Si no hay información del usuario, ir a login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }
      
      final userId = userData['id_usuario'] as int;
      
      // Navegar a la pantalla principal con el ID del usuario
      if (mounted) {
        Navigator.pushReplacementNamed(
          context, 
          '/registros',
          arguments: userId,
        );
      }
    } catch (e) {
      developer.log('Error en splash screen: $e', error: e);
      // En caso de error, ir a login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo principal de CoppelEmprende
              Expanded(
                flex: 4,
                child: Center(
                  child: Image.asset(
                    'assets/images/coppel_emprende.png',
                    width: size.width * 0.8,
                  ),
                ),
              ),
              
              // Logo de Fundación Coppel en la parte inferior
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: SvgPicture.asset(
                    'assets/images/logo-fundacion-coppel.svg',
                    width: size.width * 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 