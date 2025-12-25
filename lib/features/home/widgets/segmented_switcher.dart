import 'package:flutter/material.dart';

class SegmentedSwitcher extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final int index;
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
      width: 220,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _segButton(label: leftLabel, selected: index == 0, onTap: () => onChanged(0)),
          _segButton(label: rightLabel, selected: index == 1, onTap: () => onChanged(1)),
        ],
      ),
    );
  }

  Widget _segButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
