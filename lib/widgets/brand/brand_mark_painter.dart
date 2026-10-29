import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// [BrandMarkStyle.onPrimary] 는 파란 바탕(런처 아이콘), [BrandMarkStyle.onTint] 는 앱 안 연한 바탕.
enum BrandMarkStyle { onPrimary, onTint }

/// 3×3 타일 브랜드 마크. 모서리 1.0, 변 0.35, 중앙 앰버 점. 글자는 그리지 않는다.
/// 앱 로고와 런처 아이콘 PNG(test/tool/render_icon_test.dart)가 같이 쓴다.
class BrandMarkPainter extends CustomPainter {
  BrandMarkPainter({
    required this.style,
    this.glyphFraction = 0.60,
    this.background,
    this.backgroundRadiusFraction = 0,
    this.centerColor,
  });

  final BrandMarkStyle style;

  /// 캔버스 짧은 변 대비 글리프 폭 G.
  final double glyphFraction;

  /// null 이면 투명.
  final Color? background;

  /// 배경 모서리 반지름 / 짧은 변.
  final double backgroundRadiusFraction;

  /// 중앙 점 색을 바꾼다 (모노크롬 아이콘은 흰색).
  final Color? centerColor;

  static const edgeOpacity = 0.35;

  static double _gap(double g) => 0.11 * g;
  static double _tile(double g) => (g - 2 * _gap(g)) / 3;
  static double _radius(double g) => 0.24 * _tile(g);

  /// 글리프 중심에서 바깥 모서리 타일 둥근 끝까지 거리. 어댑티브 안전원 검사용.
  static double outerReach(double g) {
    final r = _radius(g);
    return (g / 2 - r) * math.sqrt2 + r;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    if (background case final bg?) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(side * backgroundRadiusFraction),
        ),
        Paint()..color = bg,
      );
    }

    final g = side * glyphFraction;
    final gap = _gap(g), tile = _tile(g), r = Radius.circular(_radius(g));
    final origin = Offset((size.width - g) / 2, (size.height - g) / 2);
    final (tileColor, amber) = switch (style) {
      BrandMarkStyle.onPrimary => (
        const Color(0xFFFFFFFF),
        const Color(0xFFFFC94D),
      ),
      BrandMarkStyle.onTint => (
        const Color(0xFF3B5BDB),
        const Color(0xFFF59F00),
      ),
    };
    final paint = Paint()..isAntiAlias = true;
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        final center = row == 1 && col == 1;
        final corner = row != 1 && col != 1;
        paint.color = center
            ? (centerColor ?? amber)
            : tileColor.withValues(alpha: corner ? 1.0 : edgeOpacity);
        final rect = Rect.fromLTWH(
          origin.dx + col * (tile + gap),
          origin.dy + row * (tile + gap),
          tile,
          tile,
        );
        canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);
      }
    }
  }

  @override
  bool shouldRepaint(BrandMarkPainter old) =>
      old.style != style ||
      old.glyphFraction != glyphFraction ||
      old.background != background ||
      old.backgroundRadiusFraction != backgroundRadiusFraction ||
      old.centerColor != centerColor;
}
