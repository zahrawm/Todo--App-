import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/todo_bloc.dart';
import 'package:to_do_app/bloc/todo_event.dart';
import 'package:to_do_app/screen/login_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc()..add(LoadTodos()),
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData.dark(),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
