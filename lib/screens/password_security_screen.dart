import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PasswordSecurityScreen extends StatelessWidget {
  const PasswordSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password & Security')),
      backgroundColor: AppTheme.backgroundLight,
      body: const Center(child: Text('Password Management Coming Soon')),
    );
  }
}
