
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String time;
  final String title;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.time,
    required this.title,
    this.isCompleted = false,
  });

  Todo copyWith({
    String? id,
    String? time,
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      time: time ?? this.time,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, time, title, isCompleted];
}
