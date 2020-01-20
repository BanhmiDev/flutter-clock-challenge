// Copyright 2020 Duc Son Nguyen. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A clock segment that is drawn with [ClockSegmentPainter]
///
/// The segment's length scales based on the clock's size.
/// This segment is used to build the second, minute and hour segments.
class ClockSegment extends StatelessWidget {
  const ClockSegment({
    @required this.animation,
    @required this.pathSize,
    @required this.pointSize,
  })  : assert(animation != null),
        assert(pathSize != null),
        assert(pointSize != null);

  /// The animation used for smooth position tracking.
  final Animation<double> animation;

  /// The circular path size/center offset factor.
  final double pathSize;

  /// The indicator size factor.
  final double pointSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockSegmentPainter(
        animation: animation,
        pathSize: pathSize,
        pointSize: pointSize,
      ),
    );
  }
}

/// [ClockSegmentPainter] that draws a clock hand.
class ClockSegmentPainter extends CustomPainter {
  final Animation<double> animation;
  final double pathSize;
  final double pointSize;
  final Paint pathPaint;
  final Paint pointPaint;

  ClockSegmentPainter({
    @required this.animation,
    @required this.pathSize,
    @required this.pointSize,
  })  : this.pathPaint = Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
        this.pointPaint = Paint()..color = Colors.yellow,
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = (Offset.zero & size).center;
    final double length = size.shortestSide * 0.5 * pathSize;

    // The circular path of the current clock segment.
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), length, pathPaint);

    // The indicator of the current clock segment.
    final double pointAngle = animation.value * math.pi * 2 - math.pi / 2.0;
    final Offset pointCenter =
        center + Offset(math.cos(pointAngle), math.sin(pointAngle)) * length;
    canvas.drawCircle(pointCenter, pointSize, pointPaint);
  }

  @override
  bool shouldRepaint(ClockSegmentPainter oldDelegate) =>
      animation.value != oldDelegate.animation.value;
}
