// Copyright 2020 Duc Son Nguyen. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:hoop_clock/segments/meta_segment.dart';
import 'package:hoop_clock/views/background_view.dart';
import 'package:hoop_clock/views/clock_view.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class HoopClock extends StatefulWidget {
  const HoopClock(this.model) : assert(model != null);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<HoopClock> with TickerProviderStateMixin {
  Timer _timer;

  /// Meta-data presented next to the main clock.
  DateTime _time = DateTime.now();
  WeatherCondition _weatherCondition = WeatherCondition.sunny;
  String _weather = '';
  String _temperature = '';
  String _temperatureLow = '';
  String _temperatureHigh = '';
  String _location = '';

  /// Clock handle and subtle pulse animations
  AnimationController _hoursController,
      _minutesController,
      _secondsController,
      _pulseController;
  Animation<double> _hoursAnimation,
      _minutesAnimation,
      _secondsAnimation,
      _pulseAnimation;

  /// Background animation for color transitions
  AnimationController _bgController;

  @override
  void initState() {
    super.initState();

    // Setup clock animations.
    _bgController = AnimationController(
      duration: const Duration(hours: 24),
      vsync: this,
    );
    _bgController.forward(from: _time.hour / 24);
    _bgController.repeat();

    _hoursController = AnimationController(
      duration: const Duration(hours: 12),
      vsync: this,
    );
    _hoursAnimation = Tween(begin: 0.0, end: 1.0).animate(_hoursController);
    _hoursController.forward(from: (_time.hour % 12) / 12);
    _hoursController.repeat();

    _minutesController = AnimationController(
      duration: const Duration(minutes: 60),
      vsync: this,
    );
    _minutesAnimation = Tween(begin: 0.0, end: 1.0).animate(_minutesController);
    _minutesController.forward(from: _time.minute / 60);
    _minutesController.repeat();

    _secondsController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
    _secondsAnimation = Tween(begin: 0.0, end: 1.0).animate(_secondsController);
    _secondsController.forward(from: _time.second / 60);
    _secondsController.repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween(begin: 0.0, end: 1.0).animate(_pulseController);
    _pulseController.forward();
    _pulseController.repeat(reverse: true);

    // Setup data values.
    widget.model.addListener(_updateModel);
    _updateModel();

    // Setup initial time.
    _updateTime();
  }

  @override
  void didUpdateWidget(HoopClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _bgController.dispose();
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _weatherCondition = widget.model.weatherCondition;
      _weather = widget.model.weatherString;
      _temperature = widget.model.temperatureString;
      _temperatureLow = widget.model.lowString;
      _temperatureHigh = widget.model.highString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _time = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _time.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDay = _time.hour > 3 && _time.hour <= 20;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: "${_time.hour}:${_time.minute}:${_time.second}",
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackgroundView(
              animationValue: _bgController.value,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ClockView(
                      isDay: isDay,
                      pulseAnimation: _pulseAnimation,
                      hoursAnimation: _hoursAnimation,
                      minutesAnimation: _minutesAnimation,
                      secondsAnimation: _secondsAnimation,
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 25,
                  ),
                  Expanded(
                    child: MetaSegment(
                      time: _time,
                      weatherCondition: _weatherCondition,
                      weather: _weather,
                      temperature: _temperature,
                      temperatureLow: _temperatureLow,
                      temperatureHigh: _temperatureHigh,
                      location: _location,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
