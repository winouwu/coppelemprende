import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../home/screens/home_screen.dart';
import '../features/micro_empresarios/screens/microempresas_screen.dart';
import '../features/registros/screens/registros_screen.dart';

class AppRoutes {
  static const String initial = '/login';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String microempresas = '/microempresas';
  static const String registros = '/registros';
  static const String avances = '/avances';
  static const String historial = '/historial';
  static const String perfil = '/perfil';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(userId: 0),
      home: (context) => const HomeScreen(),
      microempresas: (context) => const MicroempresasScreen(),
      registros: (context) => const RegistrosScreen(userId: 1),
    };
  }
} 