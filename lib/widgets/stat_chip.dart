import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// 아이콘 + 텍스트 pill 칩.
class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.icon,
    required this.text,
    this.color = AppTheme.text,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color == AppTheme.text ? AppTheme.primary : color,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
                fontFeatures: AppTheme.tabular,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
