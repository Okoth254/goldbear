import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';

class FrostedGlassContainer extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;

  const FrostedGlassContainer({
    super.key,
    required this.child,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.backgroundColor,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                ForestManorColors.champagneLinen.withValues(alpha: 0.7),
            borderRadius: borderRadius,
            border:
                border ??
                Border.all(color: Theme.of(context).dividerColor, width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}
