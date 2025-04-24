import 'package:flutter/material.dart';
import 'app_bottom_nav_bar.dart';

class AppScaffoldWithNav extends StatefulWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final void Function(int) onNavTap;
  final VoidCallback onAddPressed;
  final List<Widget>? actions;
  final Widget? appBarContent;

  const AppScaffoldWithNav({
    super.key,
    required this.body,
    required this.title,
    required this.currentIndex,
    required this.onNavTap,
    required this.onAddPressed,
    this.actions,
    this.appBarContent,
  });

  @override
  State<AppScaffoldWithNav> createState() => _AppScaffoldWithNavState();
}

class _AppScaffoldWithNavState extends State<AppScaffoldWithNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.appBarContent ?? Text(widget.title),
        backgroundColor: widget.appBarContent != null ? Colors.white : const Color(0xFF0078D4),
        foregroundColor: widget.appBarContent != null ? Colors.black : Colors.white,
        elevation: widget.appBarContent != null ? 0 : null,
        centerTitle: widget.appBarContent != null ? true : false,
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