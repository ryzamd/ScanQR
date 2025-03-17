abstract class ProcessEvent {}

class ProcessInitialized extends ProcessEvent {}

class ProcessRowTapped extends ProcessEvent {
  final String processId;

  ProcessRowTapped(this.processId);
}