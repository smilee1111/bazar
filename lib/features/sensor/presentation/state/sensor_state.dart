import 'package:equatable/equatable.dart';

class SensorState extends Equatable {
  final bool isActive;
  final bool isMoving;
  final double headingDegrees;
  final DateTime? lastShakeAt;
  final int shakeCount;

  const SensorState({
    this.isActive = false,
    this.isMoving = false,
    this.headingDegrees = 0,
    this.lastShakeAt,
    this.shakeCount = 0,
  });

  SensorState copyWith({
    bool? isActive,
    bool? isMoving,
    double? headingDegrees,
    DateTime? lastShakeAt,
    bool clearLastShake = false,
    int? shakeCount,
  }) {
    return SensorState(
      isActive: isActive ?? this.isActive,
      isMoving: isMoving ?? this.isMoving,
      headingDegrees: headingDegrees ?? this.headingDegrees,
      lastShakeAt: clearLastShake ? null : (lastShakeAt ?? this.lastShakeAt),
      shakeCount: shakeCount ?? this.shakeCount,
    );
  }

  @override
  List<Object?> get props => [
    isActive,
    isMoving,
    headingDegrees,
    lastShakeAt,
    shakeCount,
  ];
}
