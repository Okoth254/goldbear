import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../services/mock_auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title settings coming soon.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundLight,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: 'ACCOUNT',
            children: [
              _SettingsTile(
                icon: Icons.person,
                title: 'Personal Information',
                onTap: () => _showComingSoon(context, 'Personal information'),
              ),
              _SettingsTile(
                icon: Icons.lock,
                title: 'Password & Security',
                onTap: () => _showComingSoon(context, 'Password & security'),
              ),
              _SettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () => context.push('/notification-preferences'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'PREFERENCES',
            children: [
              _SettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () => _showComingSoon(context, 'Language'),
              ),
              _SettingsTile(
                icon: Icons.attach_money,
                title: 'Currency',
                subtitle: 'KES',
                onTap: () => _showComingSoon(context, 'Currency'),
              ),
              _SettingsTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                onTap: () => _showComingSoon(context, 'Theme'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'SUPPORT',
            children: [
              _SettingsTile(
                icon: Icons.help,
                title: 'Help Center',
                onTap: () => context.push('/concierge'),
              ),
              _SettingsTile(
                icon: Icons.description,
                title: 'Terms & Conditions',
                onTap: () => _showComingSoon(context, 'Terms & conditions'),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () => _showComingSoon(context, 'Privacy policy'),
              ),
              _SettingsTile(
                icon: Icons.store_mall_directory,
                title: 'Store Locator',
                onTap: () => context.push('/store-locator'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () async {
                await MockAuthService.instance.signOut();
                if (!context.mounted) return;
                context.go('/login');
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.ochreEarth,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppTheme.deepForest),
      title: Text(title),
      trailing: subtitle != null
          ? Text(subtitle!, style: const TextStyle(color: AppTheme.ochreEarth))
          : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}
