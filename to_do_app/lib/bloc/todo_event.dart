import 'package:equatable/equatable.dart';


abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String time;
  final String title;

  const AddTodo({required this.time, required this.title});

  @override
  List<Object?> get props => [time, title];
}

class UpdateTodo extends TodoEvent {
  final String id;
  final String? time;
  final String? title;
  final bool? isCompleted;

  const UpdateTodo({
    required this.id,
    this.time,
    this.title,
    this.isCompleted,
  });

  @override
  List<Object?> get props => [id, time, title, isCompleted];
}

class DeleteTodo extends TodoEvent {
  final String id;

  const DeleteTodo({required this.id});

  @override
  List<Object?> get props => [id];
}
