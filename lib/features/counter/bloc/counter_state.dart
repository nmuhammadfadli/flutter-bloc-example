import 'package:equatable/equatable.dart';

class CounterState extends Equatable{
  final int value;

  const CounterState(this.value);

  CounterState copyWith({int? value}) => CounterState(value ?? this.value);

  @override
  List<Object?> get props => [value];
}