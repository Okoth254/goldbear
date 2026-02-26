import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool orderUpdates = true;
  bool promotions = false;
  bool newCollections = true;
  bool designInspiration = false;
  bool restockAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'NOTIFICATIONS',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Stay Updated',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage what messages you want to receive from us.',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 32),
          _buildSwitchTile(
            'Order Updates',
            'Get notified about your order status.',
            orderUpdates,
            (v) => setState(() => orderUpdates = v),
          ),
          _buildSwitchTile(
            'Promotions & Offers',
            'Exclusive deals and sales events.',
            promotions,
            (v) => setState(() => promotions = v),
          ),
          _buildSwitchTile(
            'New Collections',
            'Be the first to know about new arrivals.',
            newCollections,
            (v) => setState(() => newCollections = v),
          ),
          _buildSwitchTile(
            'Design Inspiration',
            'Tips, trends, and interior ideas.',
            designInspiration,
            (v) => setState(() => designInspiration = v),
          ),
          _buildSwitchTile(
            'Restock Alerts',
            'Get notified when your favorites are back.',
            restockAlerts,
            (v) => setState(() => restockAlerts = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        activeThumbColor: AppTheme.primary,
        activeTrackColor: AppTheme.primary.withValues(alpha: 0.3),
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
