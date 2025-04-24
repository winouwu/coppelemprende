import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../home/screens/home_screen.dart';
import '../features/micro_empresarios/screens/microempresas_screen.dart';
import '../features/avances/screens/avances_screen.dart';
import '../features/registros/screens/registros_screen.dart';
import '../features/micro_empresarios/screens/microempresario_register_screen.dart';
import '../features/micro_empresarios/screens/ine_scanner_screen.dart';
import '../features/historial/screens/historial_screen.dart';
import '../features/perfil/screens/perfil_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/auth/screens/login_alternativo_screen.dart';
import '../features/collaborators/screens/collaborators_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String initial = splash;
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String registros = '/registros';
  static const String microempresas = '/microempresas';
  static const String microempresarioRegister = '/microempresarioRegister';
  static const String ineScannerScreen = '/ineScannerScreen';
  static const String avances = '/avances';
  static const String historial = '/historial';
  static const String perfil = '/perfil';
  static const String loginAlternativo = '/login_alternativo';
  static const String collaborators = '/collaborators';
  static const String microempresarios = '/microempresarios';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
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
      historial: (context) {
        // Obtener el userId de los argumentos si está disponible
        final userId = ModalRoute.of(context)?.settings.arguments as int?;
        return HistorialScreen(userId: userId);
      },
      perfil: (context) {
        // Obtener el userId de los argumentos si está disponible
        final userId = ModalRoute.of(context)?.settings.arguments as int?;
        return PerfilScreen(userId: userId);
      },
      loginAlternativo: (context) => const LoginAlternativoScreen(),
      collaborators: (context) => const CollaboratorsScreen(),
    };
  }
} 