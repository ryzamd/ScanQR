abstract class OutboundEvent {}

class OutboundTypeSelected extends OutboundEvent {
  final String selectedType;

  OutboundTypeSelected(this.selectedType);
}

class OutboundInitialized extends OutboundEvent {}