import 'package:bazar/features/sensor/data/repositories/sensor_repository.dart';
import 'package:bazar/features/sensor/domain/entities/heading_reading.dart';
import 'package:bazar/features/sensor/domain/entities/motion_reading.dart';
import 'package:bazar/features/sensor/domain/repositories/sensor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final watchMotionUsecaseProvider = Provider<WatchMotionUsecase>((ref) {
  return WatchMotionUsecase(repository: ref.read(sensorRepositoryProvider));
});

final watchHeadingUsecaseProvider = Provider<WatchHeadingUsecase>((ref) {
  return WatchHeadingUsecase(repository: ref.read(sensorRepositoryProvider));
});

class WatchMotionUsecase {
  final ISensorRepository _repository;

  WatchMotionUsecase({required ISensorRepository repository})
    : _repository = repository;

  Stream<MotionReading> call() => _repository.watchMotion();
}

class WatchHeadingUsecase {
  final ISensorRepository _repository;

  WatchHeadingUsecase({required ISensorRepository repository})
    : _repository = repository;

  Stream<HeadingReading> call() => _repository.watchHeading();
}
