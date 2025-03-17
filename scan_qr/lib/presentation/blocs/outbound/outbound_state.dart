import 'package:scan_qr/domain/entities/outbound_record.dart';

abstract class OutboundState {}

class OutboundInitial extends OutboundState {}

class OutboundLoading extends OutboundState {}

class OutboundLoaded extends OutboundState {
  final List<OutboundRecord> records;
  final String selectedType;

  OutboundLoaded({
    required this.records,
    required this.selectedType,
  });
}

class OutboundError extends OutboundState {
  final String message;

  OutboundError(this.message);
}