import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/core/models/load_status.dart';
import 'package:flutter_bloc_example/features/login/bloc/login_event.dart';
import 'package:flutter_bloc_example/features/login/bloc/login_state.dart';
import 'package:flutter_bloc_example/features/login/presentation/login_page.dart';
import 'package:flutter_bloc_example/features/products/bloc/cart_bloc.dart';
import 'package:flutter_bloc_example/features/products/bloc/cart_event.dart';
import 'package:flutter_bloc_example/features/products/bloc/products_bloc.dart';
import 'package:flutter_bloc_example/features/products/bloc/products_event.dart';
import 'package:flutter_bloc_example/features/products/data/cart_repository.dart';
import 'package:flutter_bloc_example/features/products/data/product_repository.dart';
import 'package:flutter_bloc_example/features/products/presentation/product_page.dart';
import 'package:flutter_bloc_example/posts/bloc/posts_bloc.dart';
import 'package:flutter_bloc_example/posts/bloc/posts_event.dart';
import 'package:flutter_bloc_example/posts/data/post_repository.dart';
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
        RepositoryProvider(create: (_) => PostRepository()),
        RepositoryProvider(create: (_) => ProductRepository()),
        RepositoryProvider(create: (_) => CartRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          
          BlocProvider(
            create: (context) => LoginBloc(context.read<SessionRepository>())..add(const LoginStarted()),
          ),
           BlocProvider(
            create: (context) => ProductsBloc(context.read<ProductRepository>())..add(const ProductsStarted()),
          ),
             BlocProvider(
            create: (context) => CartBloc(context.read<CartRepository>())..add(const CartStarted()),
          ),
          BlocProvider(
            create: (context) => PostsBloc(context.read<PostRepository>())..add(const PostsStarted()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Bloc Demo',
          theme: AppTheme.light(),
          home: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (!state.sessionLoaded ||
                state.status == LoadStatus.loading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state.isAuthenticated) {
              return const HomeShell();
            }

            return const LoginPage();
          },
        ),
        ),
      ),
    );
  }
}
