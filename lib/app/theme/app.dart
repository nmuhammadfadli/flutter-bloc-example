import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/features/login/bloc/login_event.dart';
import 'package:flutter_bloc_example/posts/bloc/posts_bloc.dart';
import 'package:flutter_bloc_example/posts/bloc/posts_event.dart';
import 'package:flutter_bloc_example/posts/data/post_repository.dart';
import 'package:flutter_bloc_example/todo/bloc/todo_bloc.dart';
import 'package:flutter_bloc_example/todo/bloc/todo_event.dart';
import 'package:flutter_bloc_example/todo/data/todo_repository.dart';

import '../../features/counter/bloc/counter_bloc.dart';
import '../../features/home/home_shell.dart';
import '../../features/login/bloc/login_bloc.dart';
import '../../features/login/data/session_repository.dart';
import '../theme/app_theme.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => SessionRepository()),
        RepositoryProvider(create: (_) => TodoRepository()),
        RepositoryProvider(create: (_) => PostRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CounterBloc()),
          BlocProvider(
            create: (context) => LoginBloc(context.read<SessionRepository>())..add(const LoginStarted()),
          ),
          BlocProvider(
            create: (context) => TodoBloc(context.read<TodoRepository>())..add(const TodoStarted()),
          ),
          BlocProvider(
            create: (context) => PostsBloc(context.read<PostRepository>())..add(const PostsStarted()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Bloc Demo',
          theme: AppTheme.light(),
          home: const HomeShell(),
        ),
      ),
    );
  }
}
