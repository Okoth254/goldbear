import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ShowroomVisitScreen extends StatelessWidget {
  const ShowroomVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Showroom Visit'),
        backgroundColor: AppTheme.backgroundLight,
      ),
      body: Center(
        child: Text(
          'Showroom Booking Calendar Coming Soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
