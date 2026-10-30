import 'dart:math';

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Decorative route illustration, matching the pale map treatment in Pixso.
/// It represents the local demo order, not live map or GPS data.
class MapArt extends StatelessWidget {
  const MapArt({super.key, this.tracking = false});
  final bool tracking;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _MapPainter(tracking), size: Size.infinite);
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.tracking);
  final bool tracking;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFF9F9F9));
    final roads = Paint()
      ..color = Colors.white
      ..strokeWidth = 7;
    for (var i = -4; i < 12; i++) {
      c.drawLine(Offset(i * 74, 0), Offset(i * 74 - 230, s.height), roads);
      c.drawLine(Offset(0, i * 98), Offset(s.width, i * 98 + 240), roads);
    }
    final a = Offset(s.width * .37, s.height * .29);
    final b = Offset(s.width * .63, s.height * .48);
    final d = Offset(s.width * .57, s.height * .64);
    final route = [a, b, Offset(s.width * .45, s.height * .59), d];
    final dot = Paint()..color = orange;
    for (var i = 0; i < route.length - 1; i++) {
      final delta = route[i + 1] - route[i];
      final steps = max(1, (delta.distance / 13).floor());
      for (var j = 0; j < steps; j++) {
        c.drawCircle(route[i] + delta * (j / steps), 1.6, dot);
      }
    }
    for (final p in [a, d]) {
      c.drawShadow(
        Path()..addOval(Rect.fromCircle(center: p, radius: 23)),
        orange,
        6,
        true,
      );
      c.drawCircle(p, 23, dot);
      _icon(c, p, Icons.location_on, Colors.white, 26);
    }
    if (tracking) {
      c.drawCircle(b, 23, Paint()..color = ink);
      _icon(c, b, Icons.delivery_dining, Colors.white, 26);
      final bubble = Rect.fromLTWH(b.dx + 12, b.dy - 83, 98, 44);
      c.drawRRect(
        RRect.fromRectAndRadius(bubble, const Radius.circular(5)),
        Paint()..color = ink,
      );
      final tp = TextPainter(
        text: const TextSpan(
          text: '10 min away',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Barlow',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(c, Offset(bubble.left + 15, bubble.top + 13));
    }
  }

  void _icon(Canvas c, Offset at, IconData icon, Color color, double size) {
    final p = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          fontSize: size,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    p.paint(c, at - Offset(p.width / 2, p.height / 2));
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) =>
      oldDelegate.tracking != tracking;
}
