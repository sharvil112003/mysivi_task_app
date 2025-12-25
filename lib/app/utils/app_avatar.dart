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

  const AppAvatar({
    super.key,
    this.initials,
    this.child,
    this.radius = 22,
    this.gradientColors,
    this.backgroundColor,
    this.textStyle,
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

    return Container(
      width: size,
      height: size,
      decoration: dec,
      child: Center(
        child: child ?? Text(initials ?? '', style: defaultTextStyle, textAlign: TextAlign.center),
      ),
    );
  }
}
