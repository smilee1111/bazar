import 'package:bazar/features/sensor/domain/entities/heading_reading.dart';
import 'package:bazar/features/sensor/domain/entities/motion_reading.dart';

abstract interface class ISensorRepository {
  Stream<MotionReading> watchMotion();
  Stream<HeadingReading> watchHeading();
}
