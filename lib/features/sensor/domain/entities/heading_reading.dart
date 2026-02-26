import 'package:equatable/equatable.dart';

class HeadingReading extends Equatable {
  final double degrees;
  final DateTime timestamp;

  const HeadingReading({required this.degrees, required this.timestamp});

  @override
  List<Object?> get props => [degrees, timestamp];
}
