part of 'payment_bloc.dart';

abstract class PaymentEvent {}

class LoadUserCardsEvent extends PaymentEvent {
  LoadUserCardsEvent(this.uid);
  final String uid;
}

class AddCreditCardEvent extends PaymentEvent {
  AddCreditCardEvent(this.uid, this.card);
  final String uid;
  final UserCreditCardModel card;
}

class DeleteCreditCardEvent extends PaymentEvent {
  DeleteCreditCardEvent(this.uid, this.cardId);
  final String uid;
  final String cardId;
}
