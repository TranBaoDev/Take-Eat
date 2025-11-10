part of 'payment_bloc.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  PaymentLoaded(
    this.cards,
    this.cardCvv,
    this.cardExpiry,
    this.cardNumber,
    this.nameOnCard,
  );
  final List<UserCreditCardModel> cards;
  final String? cardCvv;
  final String? cardExpiry;
  final String? cardNumber;
  final String? nameOnCard;
}

class PaymentError extends PaymentState {
  PaymentError(this.message);
  final String message;
}

class PaymentAdded extends PaymentState {}
