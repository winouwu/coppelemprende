import 'package:flutter/material.dart';
import '../../../core/widgets/app_scaffold_with_nav.dart';

class MicroempresasScreen extends StatefulWidget {
  const MicroempresasScreen({super.key});

  @override
  State<MicroempresasScreen> createState() => _MicroempresasScreenState();
}

class _MicroempresasScreenState extends State<MicroempresasScreen> {
  int _currentIndex = 0;

  void _handleNavBarTap(int index) {
    if (index != _currentIndex) {
      // Navegar a la pantalla correspondiente según el índice
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        // Otros casos según sea necesario
      }
    }
  }

  void _handleAddPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar nueva Microempresa'),
        content: const Text('Aquí puedes añadir el formulario para registrar una nueva microempresa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNav(
      title: 'Microempresas',
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF0078D4),
                child: Text('${index + 1}'),
              ),
              title: Text('Microempresa ${index + 1}'),
              subtitle: Text('Categoría: ${index % 3 == 0 ? 'Alimentos' : index % 3 == 1 ? 'Servicios' : 'Manufactura'}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Acción al seleccionar una microempresa
              },
            ),
          );
        },
      ),
      currentIndex: _currentIndex,
      onNavTap: _handleNavBarTap,
      onAddPressed: _handleAddPressed,
    );
  }
} 