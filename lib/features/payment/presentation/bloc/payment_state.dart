part of 'payment_bloc.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  PaymentLoaded(this.cards);
  final List<UserCreditCardModel> cards;
}

class PaymentError extends PaymentState {
  PaymentError(this.message);
  final String message;
}

class PaymentAdded extends PaymentState {}
