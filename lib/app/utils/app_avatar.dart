import 'package:flutter/material.dart';

/// A small reusable avatar widget that supports a gradient or a solid background
/// and shows either a child widget or simple initials text.
class AppAvatar extends StatelessWidget {
  final String? initials;
  final Widget? child;
  final double radius;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final bool isOnline;
  final Color? onlineColor;

  const AppAvatar({
    super.key,
    this.initials,
    this.child,
    this.radius = 22,
    this.gradientColors,
    this.backgroundColor,
    this.textStyle,
    this.isOnline = false,
    this.onlineColor,
  }) : assert(initials != null || child != null, 'Either initials or child must be provided.');

  @override
  Widget build(BuildContext context) {
    final double size = radius * 2;

    final dec = (gradientColors != null)
        ? BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors!,
            ),
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? Theme.of(context).colorScheme.primary,
          );

    final defaultTextStyle = textStyle ?? Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: radius * 0.8);

    // indicator size scales with radius
    final indicatorSize = radius * 0.65;
    final indicatorBorderWidth = (radius * 0.12).clamp(1.0, 4.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: dec,
            child: Center(
              child: child ?? Text(initials ?? '', style: defaultTextStyle, textAlign: TextAlign.center),
            ),
          ),
          if (isOnline)
            Positioned(
              right: -indicatorSize * 0.18,
              bottom: -indicatorSize * 0.18,
              child: Container(
                width: indicatorSize,
                height: indicatorSize,
                decoration: BoxDecoration(
                  color: onlineColor ?? const Color(0xFF34C759),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: indicatorBorderWidth),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
