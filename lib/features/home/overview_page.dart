import 'package:flutter/material.dart';

import '../../core/widgets/section_scaffold.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return SectionScaffold(
      title: 'Nur Muhammad Fadli',
      subtitle: 'Project untuk Technical Test Mobile Developer',
      child: GridView.count(
        crossAxisCount: isDesktop ? 3 : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: const [
          _InfoCard(
            icon: Icons.person_outline,
            title: 'Posisi Dilamar',
            value: 'Flutter Mobile Developer',
          ),
          _InfoCard(
            icon: Icons.email_outlined,
            title: 'Email',
            value: 'nmuhammadfadli48@gmail.com',
          ),
        
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}