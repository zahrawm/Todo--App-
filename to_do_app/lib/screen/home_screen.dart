import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_app/screen/add_todo_dialog.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widget/to_do_ui.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [Icon(Icons.calendar_month)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            Text(
              'Schedule',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 10),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            SizedBox(height: 30),
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TodoLoaded) {
                    return ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return Column(
                          children: [
                            ToDoUi(
                              id: todo.id,
                              time: todo.time,
                              title: todo.title,
                              isCompleted: todo.isCompleted,
                              onUpdate: (time, title) {
                                context.read<TodoBloc>().add(
                                  UpdateTodo(
                                    id: todo.id,
                                    time: time,
                                    title: title,
                                  ),
                                );
                              },
                              onToggleComplete: (isCompleted) {
                                context.read<TodoBloc>().add(
                                  UpdateTodo(
                                    id: todo.id,
                                    isCompleted: isCompleted,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  } else if (state is TodoError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTodo,
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddTodo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodoScreen(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      context.read<TodoBloc>().add(
        AddTodo(
          time: result['time']!,
          title: result['title']!,
        ),
      );
    }
  }
}
