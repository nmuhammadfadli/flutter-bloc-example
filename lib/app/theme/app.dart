import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/app/theme/app_theme.dart';
import 'package:flutter_bloc_example/features/counter/bloc/counter_bloc.dart';
import 'package:flutter_bloc_example/features/home/home_shell.dart';
import 'package:flutter_bloc_example/features/login/bloc/login_bloc.dart';
import 'package:flutter_bloc_example/posts/bloc/posts_event.dart';
import 'package:flutter_bloc_example/posts/data/post_repository.dart';
import 'package:flutter_bloc_example/todo/bloc/todo_bloc.dart';
import 'package:flutter_bloc_example/todo/bloc/todo_event.dart';
import 'package:flutter_bloc_example/todo/data/todo_repository.dart';

import '../../posts/bloc/posts_bloc.dart';


class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => TodoRepository()),
        RepositoryProvider(create: (_) => PostRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CounterBloc()),
          BlocProvider(create: (_) => LoginBloc()),
          BlocProvider(create: (context) => TodoBloc(context.read<TodoRepository>())..add(const TodoStarted())),
          BlocProvider(create: (context) => PostsBloc(context.read<PostRepository>())..add(const PostsStarted())),
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
