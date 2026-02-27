import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<Map<String, String>> _pages = const [
    {
      'title': 'Design Your Masterpiece',
      'subtitle': 'Curated interiors for elevated living.',
      'icon': 'weekend', // Mapped to Icons.weekend
    },
    {
      'title': 'True Craftsmanship',
      'subtitle': 'Every piece tells a story of heritage and quality.',
      'icon': 'handyman', // Mapped to Icons.handyman
    },
    {
      'title': 'Tailored to You',
      'subtitle': 'Personalize materials and finishes to match your style.',
      'icon': 'palette', // Mapped to Icons.palette
    },
    {
      'title': 'Seamless Delivery',
      'subtitle': 'White-glove service from our door to yours.',
      'icon': 'local_shipping', // Mapped to Icons.local_shipping
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    AuthService.instance.markOnboardingSeen();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _pages.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 260,
                          decoration: BoxDecoration(
                            color: AppTheme.sageMist.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Icon(
                              _getIcon(_pages[i]['icon']!),
                              size: 88,
                              color: AppTheme.deepForest,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          _pages[i]['title']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _pages[i]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index
                        ? AppTheme.deepForest
                        : AppTheme.sageMist,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _index == _pages.length - 1
                      ? _finish
                      : () => _controller.nextPage(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOut,
                        ),
                  child: Text(
                    _index == _pages.length - 1 ? 'Begin Your Journey' : 'Next',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'weekend':
        return Icons.weekend;
      case 'handyman':
        return Icons.handyman;
      case 'palette':
        return Icons.palette;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.star;
    }
  }
}
