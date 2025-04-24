import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../home/screens/home_screen.dart';
import '../features/micro_empresarios/screens/microempresas_screen.dart';
import '../features/avances/screens/avances_screen.dart';
import '../features/registros/screens/registros_screen.dart';
import '../features/micro_empresarios/screens/microempresario_register_screen.dart';

class AppRoutes {
  static const String initial = '/login';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String registros = '/registros';
  static const String microempresas = '/microempresas';
  static const String microempresarioRegister = '/microempresarioRegister';
  static const String avances = '/avances';
  static const String historial = '/historial';
  static const String perfil = '/perfil';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(userId: 0),
      home: (context) => const HomeScreen(),
      registros: (context) {
        // Obtener el userId de los argumentos si está disponible
        final userId = ModalRoute.of(context)?.settings.arguments as int?;
        // Si no hay un userId válido, redirigir al login
        if (userId == null) {
          return const LoginScreen();
        }
        return RegistrosScreen(userId: userId);
      },
      microempresas: (context) => const MicroempresasScreen(),
      microempresarioRegister: (context) {
        // Obtener el userId de los argumentos
        final userId = ModalRoute.of(context)?.settings.arguments as int?;
        // Si no hay un userId válido, redirigir al login
        if (userId == null) {
          return const LoginScreen();
        }
        return MicroempresarioRegisterScreen(userId: userId);
      },
      avances: (context) {
        // Obtener el userId de los argumentos si está disponible
        final userId = ModalRoute.of(context)?.settings.arguments as int?;
        return AvancesScreen(userId: userId);
      },
    };
  }
} 