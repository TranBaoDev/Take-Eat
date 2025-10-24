
import 'package:take_eat/shared/data/model/address/address.dart';

abstract class AddressRepository {
  Future<void> addAddress(Address address);
  Future<Address?> getLatestAddress(String userId);
}
