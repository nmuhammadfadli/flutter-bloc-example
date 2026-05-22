import 'package:flutter/material.dart';
import 'package:flutter_bloc_example/posts/presentation/posts_page.dart';
import 'package:flutter_bloc_example/todo/presentation/todo_page.dart';

import '../counter/presentation/counter_page.dart';
import '../login/presentation/login_page.dart';
import 'overview_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    OverviewPage(),
    CounterPage(),
    LoginPage(),
    TodoPage(),
    PostsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.exposure_plus_1_outlined), selectedIcon: Icon(Icons.exposure_plus_1), label: 'Counter'),
          NavigationDestination(icon: Icon(Icons.lock_outline), selectedIcon: Icon(Icons.lock), label: 'Login'),
          NavigationDestination(icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), label: 'Todo'),
          NavigationDestination(icon: Icon(Icons.cloud_outlined), selectedIcon: Icon(Icons.cloud), label: 'API'),
        ],
      ),
    );
  }
}
