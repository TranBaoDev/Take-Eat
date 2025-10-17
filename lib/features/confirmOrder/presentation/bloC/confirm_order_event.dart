abstract class ConfirmOrderEvent {}

class LoadConfirmOrder extends ConfirmOrderEvent {}

class IncreaseQuantity extends ConfirmOrderEvent {
  final String id;
  IncreaseQuantity(this.id);
}

class DecreaseQuantity extends ConfirmOrderEvent {
  final String id;
  DecreaseQuantity(this.id);
}

class CancelItem extends ConfirmOrderEvent {
  final String id;
  CancelItem(this.id);
}

class UpdateAddress extends ConfirmOrderEvent {
  final String newAddress;
  UpdateAddress(this.newAddress);
}
