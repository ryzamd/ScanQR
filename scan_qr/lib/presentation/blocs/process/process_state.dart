import 'package:scan_qr/domain/entities/process_record.dart';

abstract class ProcessState {}

class ProcessInitial extends ProcessState {}

class ProcessLoading extends ProcessState {}

class ProcessLoaded extends ProcessState {
  final List<ProcessRecord> records;

  ProcessLoaded(this.records);
}

class ProcessDetailLoaded extends ProcessState {
  final ProcessRecord record;

  ProcessDetailLoaded(this.record);
}

class ProcessError extends ProcessState {
  final String message;

  ProcessError(this.message);
}
