import 'package:equatable/equatable.dart';

sealed class CounterEvent extends Equatable{
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

final class CounterIncrementPressed extends CounterEvent{}
final class CounterDecrementPressed extends CounterEvent{}
final class CounterResetPressed extends CounterEvent{}