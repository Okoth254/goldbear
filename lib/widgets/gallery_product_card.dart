import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GalleryProductCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? heroTag;

  const GalleryProductCard({
    super.key,
    required this.child,
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: ForestManorColors.galleryShadow,
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    if (heroTag != null) {
      cardContent = Hero(tag: heroTag!, child: cardContent);
    }

    return GestureDetector(onTap: onTap, child: cardContent);
  }
}
