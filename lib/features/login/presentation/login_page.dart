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
      title: 'Login + SharedPreferences',
      subtitle: 'Validasi email/password dan simpan session login secara lokal.',
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (!state.sessionLoaded && state.status == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              _SessionBanner(state: state),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => context.read<LoginBloc>().add(LoginEmailChanged(value)),
                decoration: InputDecoration(
                  labelText: 'Email',
                  helperText: 'Gunakan format email valid.',
                  errorText: state.email.isEmpty || state.isEmailValid ? null : 'Email tidak valid',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                onChanged: (value) => context.read<LoginBloc>().add(LoginPasswordChanged(value)),
                decoration: InputDecoration(
                  labelText: 'Password',
                  helperText: 'Minimal 6 karakter.',
                  errorText: state.password.isEmpty || state.isPasswordValid ? null : 'Minimal 6 karakter',
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: state.status == LoadStatus.loading ? null : () => context.read<LoginBloc>().add(const LoginSubmitted()),
                child: state.status == LoadStatus.loading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Submit'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: state.isAuthenticated ? () => context.read<LoginBloc>().add(const LoginLoggedOut()) : null,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
              const SizedBox(height: 16),
              if (state.status == LoadStatus.failure && state.message != null)
                StatusView(
                  title: 'Validasi gagal',
                  text: state.message!,
                  icon: Icons.error_outline,
                ),
              if (state.status == LoadStatus.success && state.message != null)
                StatusView(
                  title: 'Berhasil',
                  text: state.message!,
                  icon: Icons.verified_outlined,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SessionBanner extends StatelessWidget {
  final LoginState state;

  const _SessionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              state.isAuthenticated ? Icons.lock_open : Icons.lock_outline,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.isAuthenticated ? 'Session aktif' : 'Belum login',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.isAuthenticated
                        ? 'Email tersimpan: ${state.savedEmail ?? state.email}'
                        : 'Login akan disimpan secara lokal melalui SharedPreferences.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
