import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddPressed;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Tamaño del botón flotante
    const double buttonSize = 60;
    // Calculamos cuánto del botón debe sobresalir
    const double buttonOverlap = buttonSize / 2;

    return Stack(
      clipBehavior: Clip.none, // Importante para permitir que el botón sobresalga
      alignment: Alignment.topCenter,
      children: [
        // Barra de navegación principal
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Inicio
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  label: 'Inicio',
                  isActive: currentIndex == 0,
                ),
                // Avances
                _buildNavItem(
                  index: 1,
                  icon: Icons.bar_chart_outlined, 
                  label: 'Avances',
                  isActive: currentIndex == 1,
                ),
                // Espacio para el botón flotante
                const SizedBox(width: 70),
                // Historial
                _buildNavItem(
                  index: 2,
                  icon: Icons.history_outlined, 
                  label: 'Historial',
                  isActive: currentIndex == 2,
                ),
                // Perfil
                _buildNavItem(
                  index: 3,
                  icon: Icons.person_outline, 
                  label: 'Perfil',
                  isActive: currentIndex == 3,
                ),
              ],
            ),
          ),
        ),
        
        // Botón flotante con signo más
        Positioned(
          top: -buttonOverlap, // Colocamos el botón para que sobresalga la mitad
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: const Color(0xFF0078D4),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAddPressed,
                borderRadius: BorderRadius.circular(buttonSize / 2),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    final Color activeColor = const Color(0xFF0078D4);
    final Color inactiveColor = Colors.grey.shade500;
    
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
} 