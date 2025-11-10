import 'package:cloud_firestore/cloud_firestore.dart'; // Import để dùng WriteBatch
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/model/address/address.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository.dart';
import 'package:uuid/uuid.dart';

part 'address_bloc.freezed.dart';
part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(this.repository) : super(const AddressState.loading()) {
    on<_LoadLatestAddress>(_onLoadLatestAddress);
    on<_AddAddress>(_onAddAddress);
    on<_LoadAllAddresses>(_onLoadAllAddresses);
    on<_SelectAddress>(_onSelectAddress);
  }
  final AddressRepository repository;

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
        title: event.title,
        userId: event.userId,
        fullAddress: event.fullAddress,
        isSelected: event.isSelected,
        createdAt: DateTime.now(),
      );
      await repository.addAddress(newAddress);
      emit(AddressState.loaded(newAddress));
      // Optional: Reload list after adding
      add(AddressEvent.loadAllAddresses(event.userId));
    } catch (e) {
      emit(AddressState.error(e.toString()));
    }
  }

  Future<void> _onLoadAllAddresses(
    _LoadAllAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressState.loading());
    try {
      final addresses = await repository.getAllAddresses(event.userId);
      if (addresses.isNotEmpty) {
        emit(AddressState.loadedList(addresses));
      } else {
        emit(const AddressState.empty());
      }
    } catch (e) {
      emit(AddressState.error(e.toString()));
    }
  }

  Future<void> _onSelectAddress(
    _SelectAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressState.loading());
    try {
      final addresses = await repository.getAllAddresses(event.userId);
      if (addresses.isEmpty) {
        emit(const AddressState.empty());
        return;
      }

      // Update local list
      final updatedAddresses = addresses.map((addr) {
        return addr.copyWith(isSelected: addr.id == event.addressId);
      }).toList();

      // Batch update on Firestore
      final batch = FirebaseFirestore.instance.batch();
      for (final addr in updatedAddresses) {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .collection('addresses')
            .doc(addr.id);
        batch.update(docRef, {'isSelected': addr.isSelected});
      }
      await batch.commit();

      emit(AddressState.loadedList(updatedAddresses));
    } catch (e) {
      emit(AddressState.error(e.toString()));
    }
  }
}
