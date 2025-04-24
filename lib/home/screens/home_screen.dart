import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold_with_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
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
    setState(() {
      _currentIndex = index;
    });
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