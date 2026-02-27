import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Options')),
      backgroundColor: AppTheme.backgroundLight,
      body: const Center(child: Text('Light/Dark Mode Toggle Coming Soon')),
    );
  }
}
