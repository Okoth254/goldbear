import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      backgroundColor: AppTheme.backgroundLight,
      body: const Center(child: Text('Personal Information Form Coming Soon')),
    );
  }
}
