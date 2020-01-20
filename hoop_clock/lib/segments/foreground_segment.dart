// Copyright 2020 Duc Son Nguyen. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A foreground segment that is drawn with [ForegroundPainter]
///
/// This segment is used to build the inner circle (sun/moon).
class ForegroundSegment extends StatelessWidget {
  const ForegroundSegment({
    @required this.isDay,
    @required this.animation,
    @required this.pathSize,
  })  : assert(animation != null),
        assert(pathSize != null);

  /// Determines the color of the sun/moon
  final bool isDay;

  /// The animation used for smooth tracking.
  final Animation<double> animation;

  /// The circular path size/center offset factor.
  final double pathSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ForegroundPainter(
        isDay: isDay,
        animation: animation,
        pathSize: pathSize,
      ),
    );
  }
}

class ForegroundPainter extends CustomPainter {
  ForegroundPainter({
    @required this.isDay,
    @required this.animation,
    @required this.pathSize,
  });

  final bool isDay;
  final Animation<double> animation;
  final double pathSize;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = (Offset.zero & size).center;
    final double length = size.shortestSide * 0.5 * pathSize;

    // Star color is based on time.
    final Color color = (isDay) ? Colors.yellow : Colors.white;

    // Second (outer) radial gradient.
    canvas.drawCircle(
      center,
      length,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(0.3 + 0.3 * animation.value),
            color.withOpacity(0.1),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: length),
        ),
    );
    // First (inner) radial gradient.
    canvas.drawCircle(
      center,
      length * 0.7,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(0.1 * animation.value),
            color.withOpacity(0.1),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: length * 1.2),
        ),
    );
    // Main inner circle.
    canvas.drawCircle(center, length * 0.4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(ForegroundPainter oldDelegate) =>
      oldDelegate.animation.value != animation.value;
}
