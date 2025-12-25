import 'package:intl/intl.dart';

String formatRelativeTime(DateTime time, {DateTime? reference}) {
  final now = reference ?? DateTime.now();

  // If time is in the future, treat it as 'just now'.
  if (time.isAfter(now)) return 'just now';

  final diff = now.difference(time);
  final seconds = diff.inSeconds;
  final minutes = diff.inMinutes;
  final hours = diff.inHours;
  final days = diff.inDays;

  String plural(int v, String unit) => v == 1 ? '1 $unit ago' : '$v ${unit}s ago';

  if (seconds < 5) return 'just now';
  if (seconds < 60) return plural(seconds, 'second');
  if (minutes < 60) return plural(minutes, 'minute');
  if (hours < 24) return plural(hours, 'hour');
  if (days < 30) return plural(days, 'day');

  final months = (days / 30).floor();
  return months <= 1 ? '1 month ago' : '$months months ago';
}

/// Returns the exact time of the message as a localized time string, e.g. "5:08 PM".
String formatExactTime(DateTime time) {
  try {
    return DateFormat.jm().format(time);
  } catch (_) {
    // Fallback to a simple hour:minute representation if intl fails for any reason.
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
