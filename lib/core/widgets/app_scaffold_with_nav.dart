import 'package:flutter/material.dart';
import 'app_bottom_nav_bar.dart';

class AppScaffoldWithNav extends StatefulWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final void Function(int) onNavTap;
  final VoidCallback onAddPressed;
  final List<Widget>? actions;

  const AppScaffoldWithNav({
    super.key,
    required this.body,
    required this.title,
    required this.currentIndex,
    required this.onNavTap,
    required this.onAddPressed,
    this.actions,
  });

  @override
  State<AppScaffoldWithNav> createState() => _AppScaffoldWithNavState();
}

class _AppScaffoldWithNavState extends State<AppScaffoldWithNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF0078D4),
        foregroundColor: Colors.white,
        actions: widget.actions,
      ),
      body: widget.body,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavTap,
        onAddPressed: widget.onAddPressed,
      ),
    );
  }
} 