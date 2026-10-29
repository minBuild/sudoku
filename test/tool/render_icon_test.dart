// 런처 아이콘 PNG 생성기. 평소에는 skip 되고 다음으로 실행한다:
//   $env:RENDER_ICON='1'; flutter test test/tool/render_icon_test.dart; Remove-Item Env:RENDER_ICON
// 출력: design/icon/*.png (앱 번들에 들어가지 않음). 그다음 dart run flutter_launcher_icons.
@Tags(['tool'])
library;

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/widgets/brand/brand_mark_painter.dart';

const _px = 1024.0;
const _primary = Color(0xFF3B5BDB);
const _white = Color(0xFFFFFFFF);

/// 1024 캔버스 기준 글리프 폭. iOS 풀블리드 0.60, Android 전경·모노크롬 0.42 (D16).
const _gIos = 0.60;
const _gAdaptive = 0.42;

BrandMarkPainter _ios({Color? bg, double radius = 0}) => BrandMarkPainter(
  style: BrandMarkStyle.onPrimary,
  glyphFraction: _gIos,
  background: bg,
  backgroundRadiusFraction: radius,
);

BrandMarkPainter _fg() => BrandMarkPainter(
  style: BrandMarkStyle.onPrimary,
  glyphFraction: _gAdaptive,
);

BrandMarkPainter _mono() => BrandMarkPainter(
  style: BrandMarkStyle.onPrimary,
  glyphFraction: _gAdaptive,
  centerColor: _white,
);

Future<void> _save(String name, Size size, void Function(Canvas) draw) async {
  final rec = ui.PictureRecorder();
  draw(Canvas(rec));
  final pic = rec.endRecording();
  final img = await pic.toImage(size.width.round(), size.height.round());
  final png = await img.toByteData(format: ui.ImageByteFormat.png);
  img.dispose();
  pic.dispose();
  final file = File('design/icon/$name');
  await file.parent.create(recursive: true);
  await file.writeAsBytes(png!.buffer.asUint8List());
}

/// [p] 를 (x, y) 에 s×s 로 그린다.
void _paintAt(Canvas c, CustomPainter p, double x, double y, double s) {
  c.save();
  c.translate(x, y);
  p.paint(c, Size.square(s));
  c.restore();
}

/// 초타원(n=5) 근사 스쿼클.
Path _squircle(Rect r) {
  const n = 5.0;
  final path = Path();
  for (var k = 0; k <= 96; k++) {
    final t = k / 96 * 2 * math.pi;
    final ct = math.cos(t), st = math.sin(t);
    final x = ct.sign * math.pow(ct.abs(), 2 / n) * r.width / 2;
    final y = st.sign * math.pow(st.abs(), 2 / n) * r.height / 2;
    final o = r.center + Offset(x, y);
    k == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
  }
  return path..close();
}

const _grayscale = ColorFilter.matrix([
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0,
]);

void _contactSheet(Canvas c, Size size) {
  c.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF2F3F7));
  const pad = 24.0;
  var y = pad;

  // 1. iOS 라이트 · 다크 · 틴트 × 180 · 60 · 29 · 20 (마스크 r = 0.2237·size)
  var x = pad;
  for (final variant in ['light', 'dark', 'tinted']) {
    for (final s in const [180.0, 60.0, 29.0, 20.0]) {
      final rect = Rect.fromLTWH(x, y, s, s);
      c.save();
      c.clipRRect(RRect.fromRectAndRadius(rect, Radius.circular(0.2237 * s)));
      switch (variant) {
        case 'light':
          _paintAt(c, _ios(bg: _primary), x, y, s);
        case 'dark':
          c.drawRect(rect, Paint()..color = const Color(0xFF1C1C1E));
          _paintAt(c, _ios(), x, y, s);
        case 'tinted':
          c.drawRect(rect, Paint()..color = const Color(0xFF1C1C1E));
          c.saveLayer(rect, Paint()..colorFilter = _grayscale);
          _paintAt(c, _ios(), x, y, s);
          c.restore();
      }
      c.restore();
      x += s + pad;
    }
    x += pad;
  }
  y += 180 + pad * 2;

  // 2. Android adaptive: 108dp 레이어(배경 + 전경 inset 0)에서 중앙 72dp 를 자른다.
  x = pad;
  var first = true;
  for (final mask in ['circle', 'squircle', 'rrect']) {
    for (final s in const [48.0, 96.0, 192.0]) {
      final rect = Rect.fromLTWH(x, y, s, s);
      final layer = s * 108 / 72;
      final lx = x - (layer - s) / 2, ly = y - (layer - s) / 2;
      c.save();
      switch (mask) {
        case 'circle':
          c.clipPath(Path()..addOval(rect));
        case 'squircle':
          c.clipPath(_squircle(rect));
        case 'rrect':
          c.clipRRect(RRect.fromRectAndRadius(rect, Radius.circular(0.2 * s)));
      }
      c.drawRect(rect, Paint()..color = _primary);
      _paintAt(c, _fg(), lx, ly, layer);
      c.restore();
      if (first && s == 192) {
        // 66dp 안전원
        c.drawCircle(
          rect.center,
          s * 33 / 72,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5
            ..color = const Color(0xFFFF2D55),
        );
        first = false;
      }
      x += s + pad;
    }
    x += pad;
  }
  y += 192 + pad * 2;

  // 3. legacy 48px (API 24·25, 마스크 없음)
  _paintAt(c, _ios(bg: _primary, radius: 0.18), pad, y, 48);

  // 4. Themed: 모노크롬을 #005AC1 on #D8E2FF 로 틴트
  x = pad + 48 + pad * 2;
  for (final s in const [48.0, 96.0, 192.0]) {
    final rect = Rect.fromLTWH(x, y, s, s);
    final layer = s * 108 / 72;
    c.save();
    c.clipPath(Path()..addOval(rect));
    c.drawRect(rect, Paint()..color = const Color(0xFFD8E2FF));
    c.saveLayer(
      rect,
      Paint()
        ..colorFilter = const ColorFilter.mode(
          Color(0xFF005AC1),
          BlendMode.srcIn,
        ),
    );
    _paintAt(c, _mono(), x - (layer - s) / 2, y - (layer - s) / 2, layer);
    c.restore();
    c.restore();
    x += s + pad;
  }
}

void main() {
  test('런처 아이콘 PNG 렌더', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // 전경 마크가 66dp 안전원(108dp 캔버스의 33/108) 안에 있다.
    expect(
      BrandMarkPainter.outerReach(_gAdaptive * _px) <= _px * 33 / 108,
      isTrue,
    );

    const full = Size.square(_px);
    await _save('icon.png', full, (c) => _ios(bg: _primary).paint(c, full));
    await _save('icon_ios_dark.png', full, (c) => _ios().paint(c, full));
    await _save(
      'icon_legacy.png',
      full,
      (c) => _ios(bg: _primary, radius: 0.18).paint(c, full),
    );
    await _save('icon_fg.png', full, (c) => _fg().paint(c, full));
    await _save('icon_mono.png', full, (c) => _mono().paint(c, full));

    const sheet = Size(1340, 720);
    await _save('contact_sheet.png', sheet, (c) => _contactSheet(c, sheet));
  }, skip: Platform.environment['RENDER_ICON'] != '1');
}
