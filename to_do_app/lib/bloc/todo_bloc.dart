import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';


class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  List<Todo> _todos = [
    Todo(
      id: '1',
      time: '8:00 AM',
      title: 'Breakfast With Tim',
    ),
    Todo(
      id: '2',
      time: '6:00 PM',
      title: 'Coding',
    ),
  ];

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) {
    emit(TodoLoading());
    try {
      emit(TodoLoaded(todos: List.from(_todos)));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    try {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: event.time,
        title: event.title,
      );
      _todos.add(newTodo);
      emit(TodoLoaded(todos: List.from(_todos)));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) {
    try {
      final index = _todos.indexWhere((todo) => todo.id == event.id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(
          time: event.time,
          title: event.title,
          isCompleted: event.isCompleted,
        );
        emit(TodoLoaded(todos: List.from(_todos)));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    try {
      _todos.removeWhere((todo) => todo.id == event.id);
      emit(TodoLoaded(todos: List.from(_todos)));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }
}