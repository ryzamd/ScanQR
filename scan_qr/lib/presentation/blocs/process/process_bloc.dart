import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/domain/entities/process_record.dart';
import 'package:scan_qr/presentation/blocs/process/process_event.dart';
import 'package:scan_qr/presentation/blocs/process/process_state.dart';

class ProcessBloc extends Bloc<ProcessEvent, ProcessState> {
  ProcessBloc() : super(ProcessInitial()) {
    on<ProcessInitialized>(_onProcessInitialized);
    on<ProcessRowTapped>(_onProcessRowTapped);
  }

  void _onProcessInitialized(
    ProcessInitialized event,
    Emitter<ProcessState> emit,
  ) {
    emit(ProcessLoading());
    
    try {
      final records = [
        ProcessRecord(
          sn: "1",
          supplier: "PRIMO",
          time: "17:11:00 PM",
          date: "02/28/25",
          status: "SUCCESS",
          total: "50"
        ),
        ProcessRecord(
          sn: "2",
          supplier: "PRIMO",
          time: "17:11:00 PM",
          date: "02/28/25",
          status: "FAILED",
          total: "50"
        ),
        ProcessRecord(
          sn: "3",
          supplier: "PRIMO",
          time: "17:11:00 PM",
          date: "02/28/25",
          status: "PENDDING",
          total: "50"
        ),
      ];
      
      emit(ProcessLoaded(records));
    } catch (e) {
      emit(ProcessError('Failed to load process records: ${e.toString()}'));
    }
  }

  void _onProcessRowTapped(
    ProcessRowTapped event,
    Emitter<ProcessState> emit,
  ) {
    if (state is ProcessLoaded) {
      final currentState = state as ProcessLoaded;
      final record = currentState.records.firstWhere(
        (r) => r.sn == event.processId,
        orElse: () => ProcessRecord(
          sn: "",
          supplier: "",
          time: "",
          date: "",
          status: "",
          total: ""
        ),
      );
      
      if (record.sn.isNotEmpty) {
        emit(ProcessDetailLoaded(record));
      }
    }
  }
}