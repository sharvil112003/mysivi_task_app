import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/app/utils/app_avatar.dart';

enum AppSnackType { success, info, error }

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    AppSnackType type = AppSnackType.info,
    String? avatarText,
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    final bg = _bgColor(type);
    final icon = _icon(type);

    Get.rawSnackbar(
      duration: duration,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(12),
      padding: EdgeInsets.zero,
      borderRadius: 16,
      isDismissible: true,
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 220),
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
      messageText: _SnackCard(
        background: bg,
        icon: icon,
        title: title,
        message: message,
        avatarText: avatarText,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }

  static Color _bgColor(AppSnackType type) {
    switch (type) {
      case AppSnackType.success:
        return const Color(0xFF1F7A3A);
      case AppSnackType.error:
        return const Color(0xFFB3261E);
      case AppSnackType.info:
        return const Color(0xFF1A4B8C);
    }
  }

  static IconData _icon(AppSnackType type) {
    switch (type) {
      case AppSnackType.success:
        return Icons.check_circle;
      case AppSnackType.error:
        return Icons.error;
      case AppSnackType.info:
        return Icons.info;
    }
  }
}

class _SnackCard extends StatelessWidget {
  final Color background;
  final IconData icon;
  final String title;
  final String message;
  final String? avatarText;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SnackCard({
    required this.background,
    required this.icon,
    required this.title,
    required this.message,
    this.avatarText,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final initials = (avatarText?.trim().isNotEmpty ?? false) ? avatarText!.trim() : null;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              spreadRadius: 0,
              offset: Offset(0, 8),
              color: Colors.black26,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (initials != null)
              AppAvatar(
                initials: initials,
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.18),
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 13, height: 1.2),
                  ),
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: BorderSide(color: Colors.white.withOpacity(0.35)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Get.closeAllSnackbars();
                          onAction?.call();
                        },
                        child: Text(
                          actionLabel!,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: Get.closeAllSnackbars,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.close, color: Colors.white.withOpacity(0.9), size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
