// Copyright 2020 Duc Son Nguyen. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// The background view that is dependent on the given animation cycle.
class BackgroundView extends StatelessWidget {
  BackgroundView({
    Key key,
    @required this.animationValue,
  })  : assert(animationValue != null),
        super(key: key);

  /// The current progress of the day, affecting background color.
  final double animationValue;

  final Animatable<Color> _bgColors = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Color(0xFF09071E),
        end: Color(0xFF171240),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Color(0xFF171240),
        end: Color(0xFF538edb),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Color(0xFF538edb),
        end: Color(0xFF28256b),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Color(0xFF28256b),
        end: Color(0xFF09071E),
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _bgColors.evaluate(AlwaysStoppedAnimation(animationValue)),
            _bgColors
                .evaluate(AlwaysStoppedAnimation(animationValue))
                .withOpacity(0.65),
          ],
          begin: const FractionalOffset(0.6, 1.0),
          end: const FractionalOffset(0.0, 0.4),
        ),
      ),
    );
  }
}
