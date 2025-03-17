import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/domain/usescases/get_outbound_records_usecase.dart';
import 'package:scan_qr/presentation/blocs/outbound/outbound_event.dart';
import 'package:scan_qr/presentation/blocs/outbound/outbound_state.dart';

class OutboundBloc extends Bloc<OutboundEvent, OutboundState> {
  final GetOutboundRecordsUseCase getOutboundRecordsUseCase;

  OutboundBloc({required this.getOutboundRecordsUseCase}) : super(OutboundInitial()) {
    on<OutboundTypeSelected>(_onOutboundTypeSelected);
    on<OutboundInitialized>(_onOutboundInitialized);
  }

  void _onOutboundTypeSelected(
    OutboundTypeSelected event,
    Emitter<OutboundState> emit,
  ) {
    emit(OutboundLoading());
    try {
      final records = getOutboundRecordsUseCase.execute(event.selectedType);
      emit(OutboundLoaded(records: records, selectedType: event.selectedType));
    } catch (e) {
      emit(OutboundError('Failed to load outbound records: ${e.toString()}'));
    }
  }

  void _onOutboundInitialized(
    OutboundInitialized event,
    Emitter<OutboundState> emit,
  ) {
    emit(OutboundInitial());
  }
}