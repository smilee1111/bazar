import 'dart:math' as math;

import 'package:equatable/equatable.dart';

class MotionReading extends Equatable {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  const MotionReading({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  double get magnitude => math.sqrt((x * x) + (y * y) + (z * z));

  @override
  List<Object?> get props => [x, y, z, timestamp];
}
