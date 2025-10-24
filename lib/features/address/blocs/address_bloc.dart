import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/model/address/address.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository.dart';
import 'package:uuid/uuid.dart';

part 'address_bloc.freezed.dart';
part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository repository;

  AddressBloc(this.repository) : super(const AddressState.loading()) {
    on<_LoadLatestAddress>(_onLoadLatestAddress);
    on<_AddAddress>(_onAddAddress);
  }

  Future<void> _onLoadLatestAddress(
    _LoadLatestAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressState.loading());
    try {
      final latest = await repository.getLatestAddress(event.userId);
      if (latest != null) {
        emit(AddressState.loaded(latest));
      } else {
        emit(const AddressState.empty());
      }
    } catch (e) {
      emit(AddressState.error(e.toString()));
    }
  }

  Future<void> _onAddAddress(
    _AddAddress event,
    Emitter<AddressState> emit,
  ) async {
    try {
      final newAddress = Address(
        id: const Uuid().v4(),
        userId: event.userId,
        fullAddress: event.fullAddress,
        createdAt: DateTime.now(),
      );
      await repository.addAddress(newAddress);
      emit(AddressState.loaded(newAddress));
    } catch (e) {
      emit(AddressState.error(e.toString()));
    }
  }
}
