import 'package:flutter/material.dart';

import '../../core/widgets/section_scaffold.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Flutter Bloc Demo',
      subtitle: 'Template clean untuk technical test. Struktur sudah dipisah per fitur.',
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: const [
          _FeatureCard(title: 'Counter', icon: Icons.exposure_plus_1, body: 'Bloc sederhana untuk increment/decrement/reset.'),
          _FeatureCard(title: 'Login', icon: Icons.lock, body: 'Validasi email dan password dengan state form.'),
          _FeatureCard(title: 'Todo CRUD', icon: Icons.checklist, body: 'Tambah, toggle, hapus, dan search item lokal.'),
          _FeatureCard(title: 'Fetch API', icon: Icons.cloud, body: 'Ambil data, pagination, search, dan error handling.'),
          _FeatureCard(title: 'Loading State', icon: Icons.hourglass_bottom, body: 'Semua flow punya loading/success/error.'),
          _FeatureCard(title: 'Clean Structure', icon: Icons.folder, body: 'Folder dipisah per feature agar mudah dijelaskan.'),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String body;

  const _FeatureCard({required this.title, required this.icon, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
