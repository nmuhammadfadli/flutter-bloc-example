import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState>{
  CounterBloc() : super(const CounterState(0)) {
    on<CounterIncrementPressed>(((event, emit) => emit(state.copyWith(value: state.value + 1))));
    on<CounterDecrementPressed>(((event, emit) => emit(state.copyWith(value: state.value -1))));
    on<CounterResetPressed>((event, emit) => emit(const CounterState(0)));
  }
}