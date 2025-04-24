import 'package:flutter/material.dart';

class CoppelEmprendeLogo extends StatelessWidget {
  final double fontSize;
  final bool useImage;
  
  const CoppelEmprendeLogo({
    super.key, 
    this.fontSize = 20,
    this.useImage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useImage) {
      return Image.asset(
        'assets/images/coppel_emprende.png',
        height: fontSize * 2,
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Coppel',
          style: TextStyle(
            color: const Color(0xFF375FA0),
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        Text(
          'Emprende',
          style: TextStyle(
            color: const Color(0xFF3890CD),
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
} 