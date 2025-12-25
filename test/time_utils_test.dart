import 'package:flutter_test/flutter_test.dart';
import 'package:mysivi_task_app/app/utils/time_utils.dart';

void main() {
  final ref = DateTime(2025, 12, 25, 12, 0, 0);

  test('future times are "just now"', () {
    final future = ref.add(const Duration(seconds: 10));
    expect(formatRelativeTime(future, reference: ref), 'just now');
  });

  test('just now threshold', () {
    expect(formatRelativeTime(ref.subtract(const Duration(seconds: 1)), reference: ref), 'just now');
    expect(formatRelativeTime(ref.subtract(const Duration(seconds: 4)), reference: ref), 'just now');
  });

  test('seconds ago', () {
    expect(formatRelativeTime(ref.subtract(const Duration(seconds: 10)), reference: ref), '10 seconds ago');
    expect(formatRelativeTime(ref.subtract(const Duration(seconds: 59)), reference: ref), '59 seconds ago');
  });

  test('minutes ago', () {
    expect(formatRelativeTime(ref.subtract(const Duration(minutes: 1)), reference: ref), '1 minute ago');
    expect(formatRelativeTime(ref.subtract(const Duration(minutes: 30)), reference: ref), '30 minutes ago');
  });

  test('hours ago', () {
    expect(formatRelativeTime(ref.subtract(const Duration(hours: 1)), reference: ref), '1 hour ago');
    expect(formatRelativeTime(ref.subtract(const Duration(hours: 23)), reference: ref), '23 hours ago');
  });

  test('days ago', () {
    expect(formatRelativeTime(ref.subtract(const Duration(days: 1)), reference: ref), '1 day ago');
    expect(formatRelativeTime(ref.subtract(const Duration(days: 29)), reference: ref), '29 days ago');
  });

  test('months ago', () {
    expect(formatRelativeTime(ref.subtract(const Duration(days: 30)), reference: ref), '1 month ago');
    expect(formatRelativeTime(ref.subtract(const Duration(days: 90)), reference: ref), '3 months ago');
  });
}
