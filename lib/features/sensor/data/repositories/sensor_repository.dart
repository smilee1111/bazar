import 'package:bazar/features/sensor/data/datasources/sensor_datasource.dart';
import 'package:bazar/features/sensor/domain/entities/heading_reading.dart';
import 'package:bazar/features/sensor/domain/entities/motion_reading.dart';
import 'package:bazar/features/sensor/domain/repositories/sensor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sensorRepositoryProvider = Provider<ISensorRepository>((ref) {
  return SensorRepository(dataSource: ref.read(sensorDataSourceProvider));
});

class SensorRepository implements ISensorRepository {
  final ISensorDataSource _dataSource;

  SensorRepository({required ISensorDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Stream<HeadingReading> watchHeading() {
    return _dataSource.watchHeading();
  }

  @override
  Stream<MotionReading> watchMotion() {
    return _dataSource.watchMotion();
  }
}
