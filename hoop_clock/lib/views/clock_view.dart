// Copyright 2020 Duc Son Nguyen. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:hoop_clock/segments/clock_segment.dart';
import 'package:hoop_clock/segments/foreground_segment.dart';
import 'package:flutter/material.dart';

/// The clock view that is dependent on the given animation cycles.
class ClockView extends StatelessWidget {
  ClockView({
    Key key,
    @required this.isDay,
    @required this.pulseAnimation,
    @required this.hoursAnimation,
    @required this.minutesAnimation,
    @required this.secondsAnimation,
  })  : assert(pulseAnimation != null),
        assert(hoursAnimation != null),
        assert(minutesAnimation != null),
        assert(secondsAnimation != null),
        super(key: key);

  final bool isDay;
  final Animation<double> pulseAnimation;
  final Animation<double> hoursAnimation;
  final Animation<double> minutesAnimation;
  final Animation<double> secondsAnimation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ForegroundSegment(
          animation: pulseAnimation,
          isDay: isDay,
          pathSize: 0.4,
        ),
        ClockSegment(
          animation: hoursAnimation,
          pointSize: 10,
          pathSize: 0.4,
        ),
        ClockSegment(
          animation: minutesAnimation,
          pointSize: 8,
          pathSize: 0.7,
        ),
        ClockSegment(
          animation: secondsAnimation,
          pointSize: 6,
          pathSize: 1,
        ),
      ],
    );
  }
}
