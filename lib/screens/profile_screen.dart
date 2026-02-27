import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/wishlist_provider.dart';
import '../providers/orders_provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.deepForest, Color(0xFF0A2E7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.deepForest.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'JD',
                        style: TextStyle(
                          fontSize: 36,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.sageMist.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: AppTheme.deepForest,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // User info
              Column(
                children: [
                  const Text(
                    'MEMBER SINCE 2023',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.ochreEarth,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Julian Davies',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'julian.davies@example.com',
                    style: TextStyle(fontSize: 14, color: AppTheme.ochreEarth),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Stats row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.sageMist.withValues(alpha: 0.3),
                    ),
                    bottom: BorderSide(
                      color: AppTheme.sageMist.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    orders.when(
                      data: (ordersList) => _StatItem(
                        count: ordersList.length.toString().padLeft(2, '0'),
                        label: 'Orders',
                      ),
                      loading: () =>
                          const _StatItem(count: '--', label: 'Orders'),
                      error: (error, stack) =>
                          const _StatItem(count: '00', label: 'Orders'),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      color: AppTheme.sageMist.withValues(alpha: 0.3),
                    ),
                    wishlist.when(
                      data: (wishlistItems) => _StatItem(
                        count: wishlistItems.length.toString().padLeft(2, '0'),
                        label: 'Saved',
                      ),
                      loading: () =>
                          const _StatItem(count: '--', label: 'Saved'),
                      error: (error, stack) =>
                          const _StatItem(count: '00', label: 'Saved'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Menu items
              _MenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                onTap: () => context.push('/orders'),
              ),
              _MenuItem(
                icon: Icons.favorite_border,
                title: 'Wishlist',
                onTap: () => context.push('/wishlist'),
              ),
              _MenuItem(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                onTap: () => context.push('/addresses'),
              ),
              _MenuItem(
                icon: Icons.room_service_outlined,
                title: 'Concierge',
                subtitle: 'VIP Service',
                onTap: () => context.push('/concierge'),
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () => context.push('/settings'),
              ),
              const SizedBox(height: 32),
              // Sign out button
              TextButton(
                onPressed: () async {
                  await AuthService.instance.signOut();
                  if (!context.mounted) return;
                  context.go('/login');
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: AppTheme.deepForest,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Version 4.2.0 • Build 8921',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.ochreEarth.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(color: AppTheme.sageMist.withValues(alpha: 0.3)),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  isSelected: false,
                  onTap: () => context.go('/home'),
                ),
                _NavItem(
                  icon: Icons.grid_view_outlined,
                  label: 'Gallery',
                  isSelected: false,
                  onTap: () => context.push('/gallery'),
                ),
                _NavItem(
                  icon: Icons.search,
                  label: 'Search',
                  isSelected: false,
                  isCenter: true,
                  onTap: () => context.push('/search'),
                ),
                _NavItem(
                  icon: Icons.chat_bubble_outline,
                  label: 'Inbox',
                  isSelected: false,
                  onTap: () => context.push('/chat'),
                ),
                _NavItem(
                  icon: Icons.person,
                  label: 'Profile',
                  isSelected: true,
                  onTap: () => context.go('/profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: AppTheme.deepForest,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 0.15,
            color: AppTheme.ochreEarth.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.sageMist.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: AppTheme.charcoalBark, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.charcoalBark,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepForest,
                        letterSpacing: 0.1,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.sageMist.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCenter;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCenter) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.deepForest,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.deepForest.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 4),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppTheme.deepForest : AppTheme.sageMist,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? AppTheme.deepForest : AppTheme.sageMist,
            ),
          ),
        ],
      ),
    );
  }
}
