import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../../../core/widgets/section_scaffold.dart';
import '../../../core/widgets/status_view.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Login Validation',
      subtitle: 'Validasi email dan password sederhana.',
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return ListView(
            children: [
              TextField(
                onChanged:
                    (value) =>
                        context.read<LoginBloc>().add(LoginEmailChanged(value)),
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText:
                      state.email.isEmpty || state.isEmailValid
                          ? null
                          : 'Email tidak valid',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                onChanged:
                    (value) => context.read<LoginBloc>().add(
                      LoginPasswordChanged(value),
                    ),
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText:
                      state.password.isEmpty || state.isPasswordValid
                          ? null
                          : 'Minimal 6 karakter',
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed:
                    state.status == LoadStatus.loading
                        ? null
                        : () => context.read<LoginBloc>().add(LoginSubmitted()),
                child:
                    state.status == LoadStatus.loading
                        ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Submit'),
              ),
              const SizedBox(height: 16),
              if (state.status == LoadStatus.failure && state.message != null)
                StatusView(text: state.message!),
              if (state.status == LoadStatus.success && state.message != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(state.message!),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
