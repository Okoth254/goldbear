import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DesignConsultationScreen extends StatelessWidget {
  const DesignConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Design Consultation'),
        backgroundColor: AppTheme.backgroundLight,
      ),
      body: Center(
        child: Text(
          'Design Consultation Form Coming Soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
