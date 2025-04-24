import 'package:flutter/material.dart';

class MicroempresarioCard extends StatelessWidget {
  final String name;
  final String lecciones;
  final String webinar;
  final String llavesCanjeadas;
  final String horasSemana;

  const MicroempresarioCard({
    super.key,
    required this.name,
    required this.lecciones,
    required this.webinar,
    required this.llavesCanjeadas,
    required this.horasSemana,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del microempresario con estilo de título
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3D8F),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Estadísticas en formato de tabla
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatistic('Lecciones', lecciones),
                _buildStatistic('Webinar', webinar),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatistic('Llaves', llavesCanjeadas),
                _buildStatistic('Hrs/Sem', horasSemana),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 