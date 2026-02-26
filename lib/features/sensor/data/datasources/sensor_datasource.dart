import 'dart:math' as math;

import 'package:bazar/features/sensor/domain/entities/heading_reading.dart';
import 'package:bazar/features/sensor/domain/entities/motion_reading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

abstract interface class ISensorDataSource {
  Stream<MotionReading> watchMotion();
  Stream<HeadingReading> watchHeading();
}

final sensorDataSourceProvider = Provider<ISensorDataSource>((ref) {
  return SensorDataSource();
});

class SensorDataSource implements ISensorDataSource {
  @override
  Stream<MotionReading> watchMotion() {
    return accelerometerEventStream().map(
      (event) => MotionReading(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Stream<HeadingReading> watchHeading() {
    return magnetometerEventStream().map((event) {
      final heading = (math.atan2(event.y, event.x) * 180 / math.pi + 360) %
          360;
      return HeadingReading(degrees: heading, timestamp: DateTime.now());
    });
  }
}
