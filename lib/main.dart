import 'package:flutter/material.dart';
import 'core/supabase/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await SupabaseClientManager.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoppelEmprende',
      theme: AppTheme.lightTheme,
      // Configuración de la ruta inicial
      // Para usar la pantalla de carga original, descomentar la siguiente línea:
       initialRoute: AppRoutes.splash,
      // Para usar la pantalla de login alternativa:
      //initialRoute: AppRoutes.loginAlternativo,
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
