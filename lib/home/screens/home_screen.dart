import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold_with_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  // Agregar el ID del usuario
  final int? userId;
  
  // Constructor que inicializa el userId desde el constructor padre
  _HomeScreenState() : userId = null;
  
  final List<Widget> _pages = [
    // Página de inicio
    const Center(
      child: Text(
        'Página de Inicio',
        style: TextStyle(fontSize: 24),
      ),
    ),
    // Página de avances
    const Center(
      child: Text(
        'Página de Avances',
        style: TextStyle(fontSize: 24),
      ),
    ),
    // Página de historial
    const Center(
      child: Text(
        'Página de Historial',
        style: TextStyle(fontSize: 24),
      ),
    ),
    // Página de perfil
    const Center(
      child: Text(
        'Página de Perfil',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];

  void _handleNavBarTap(int index) {
    if (index != _currentIndex) {
      // Navegar a la pantalla correspondiente según el índice
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/registros');
          break;
        case 1:
          Navigator.pushReplacementNamed(
            context, 
            '/avances',
            arguments: userId, // Pasar el ID del usuario
          );
          break;
        case 2:
          Navigator.pushReplacementNamed(
            context, 
            '/historial',
            arguments: userId,
          );
          break;
        case 3:
          Navigator.pushReplacementNamed(
            context, 
            '/perfil',
            arguments: userId,
          );
          break;
        default:
          setState(() {
            _currentIndex = index;
          });
      }
    }
  }

  void _handleAddPressed() {
    Navigator.pushNamed(context, '/microempresas');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNav(
      title: 'CoppelEmprende',
      body: _pages[_currentIndex],
      currentIndex: _currentIndex,
      onNavTap: _handleNavBarTap,
      onAddPressed: _handleAddPressed,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Acción de búsqueda
          },
        ),
      ],
    );
  }
} 