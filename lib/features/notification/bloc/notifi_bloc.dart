import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifi_event.dart';
part 'notifi_state.dart';
part 'notifi_bloc.freezed.dart';

class NotifiBloc extends Bloc<NotifiEvent, NotifiState> {
  NotifiBloc() : super(_Initial()) {
    on<NotifiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
