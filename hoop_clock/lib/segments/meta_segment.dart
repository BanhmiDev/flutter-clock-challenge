// Copyright 2020 Duc Son Nguyen. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:hoop_clock/meteocons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

/// A meta segment that uses data from the given model.
///
/// This segment is used to build the stats portion of the clock.
class MetaSegment extends StatelessWidget {
  MetaSegment({
    Key key,
    @required this.time,
    @required this.weatherCondition,
    @required this.weather,
    @required this.temperature,
    @required this.temperatureLow,
    @required this.temperatureHigh,
    @required this.location,
  })  : assert(time != null),
        assert(weatherCondition != null),
        assert(weather != null),
        assert(temperature != null),
        assert(temperatureLow != null),
        assert(temperatureHigh != null),
        assert(location != null),
        super(key: key);

  final DateTime time;
  final WeatherCondition weatherCondition;
  final String weather;
  final String temperature;
  final String temperatureLow;
  final String temperatureHigh;
  final String location;

  /// The formatter for the date display.
  final DateFormat _dateFormatter = DateFormat("EEEE, MMM d");

  /// The hardcoded weather condition/symbol mapping.
  IconData _weatherIcon(WeatherCondition weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        return Meteocons.clouds;
      case WeatherCondition.foggy:
        return Meteocons.fog_cloud;
      case WeatherCondition.rainy:
        return Meteocons.rain;
      case WeatherCondition.thunderstorm:
        return Meteocons.cloud_flash_alt;
      case WeatherCondition.windy:
        return Meteocons.windy;
      case WeatherCondition.snowy:
        return Meteocons.snow_heavy;
      case WeatherCondition.sunny:
        return Meteocons.sun;
    }
    assert(false, 'Invalid weather condition: $weatherCondition');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.white,
        letterSpacing: 1.4,
        height: 1.5,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_dateFormatter.format(time).toUpperCase()),
          Text(location.toUpperCase()),
          Chip(
            backgroundColor: Colors.yellow,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Semantics(
                    label: '$weather',
                    child: Icon(
                      _weatherIcon(weatherCondition),
                      size: 17,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  temperature,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Semantics(
                    label: 'Low temperature',
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  temperatureLow,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Semantics(
                    label: 'High temperature',
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  temperatureHigh,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
