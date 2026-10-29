import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'brand/brand_mark_painter.dart';

/// 3×3 타일 마크 + "스도쿠 [JANG]" 워드마크.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.showTagline = false});

  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primaryTint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomPaint(
              painter: BrandMarkPainter(
                style: BrandMarkStyle.onTint,
                glyphFraction: 0.72,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(context.l10n.appTitle, style: text.displaySmall),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryTint,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.primaryTintPressed),
              ),
              child: Text(
                context.l10n.appBadge,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 6),
          Text(
            context.l10n.tagline,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ],
    );
  }
}
