import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/section_scaffold.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';

class CounterPage extends StatelessWidget{
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context){
    return SectionScaffold(title: 'Counter', subtitle: 'Contoh event -> bloc -> state -> UI rebuild',
     child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state)=> Text('${state.value}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w700
            )),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                FilledButton(onPressed: () => context.read<CounterBloc>().add(CounterIncrementPressed()), child: const Text('Tambah')),
                FilledButton.tonal(onPressed: () => context.read<CounterBloc>().add(CounterDecrementPressed()), child: const Text('Kurang')),
                OutlinedButton(onPressed: () => context.read<CounterBloc>().add(CounterResetPressed()), child: const Text('Reset')),
              ],
            )
        ],
      ),
     )
     );
  }

}