import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/features/payment/data/model/credit_card_model.dart';
import 'package:take_eat/features/payment/data/repository/credit_card_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(this.repo) : super(PaymentInitial()) {
    on<LoadUserCardsEvent>(_onLoadUserCards);
    on<AddCreditCardEvent>(_onAddCreditCard);
    on<DeleteCreditCardEvent>(_onDeleteCreditCard);
  }
  final CreditCardRepository repo;

  Future<void> _onLoadUserCards(
    LoadUserCardsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    await emit.forEach<List<UserCreditCardModel>>(
      repo.getUserCreditCards(event.uid),
      onData: PaymentLoaded.new,
      onError: (_, _) => PaymentError('Failed to load cards'),
    );
  }

  Future<void> _onAddCreditCard(
    AddCreditCardEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      await repo.addCreditCard(event.uid, event.card);
      // Notify listeners that a card was added successfully
      emit(PaymentAdded());
    } catch (e) {
      emit(PaymentError('Failed to add card: $e'));
    }
  }

  Future<void> _onDeleteCreditCard(
    DeleteCreditCardEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      await repo.deleteCreditCard(event.uid, event.cardId);
    } catch (e) {
      emit(PaymentError('Failed to delete card: $e'));
    }
  }
}
