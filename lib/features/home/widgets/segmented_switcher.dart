import 'package:flutter/material.dart';

class SegmentedSwitcher extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final int index; // 0 or 1
  final ValueChanged<int> onChanged;

  const SegmentedSwitcher({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final innerWidth = c.maxWidth;
          final pillWidth = (innerWidth) / 2; // 4 padding each side
          final left = index == 0 ? 0.0 : pillWidth;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                left: left,
                top: 0,
                bottom: 0,
                width: pillWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Row(
                children: [
                          _tapArea(context,
                    label: leftLabel,
                    selected: index == 0,
                    onTap: () => onChanged(0),
                  ),
                  _tapArea(context,
                    label: rightLabel,
                    selected: index == 1,
                    onTap: () => onChanged(1),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tapArea(BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? Colors.black : Colors.grey.shade600,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
