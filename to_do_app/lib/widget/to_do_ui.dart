import 'package:flutter/material.dart';

class ToDoUi extends StatefulWidget {
  final String time;
  final String title;
  final Function(String, String)? onUpdate;
  const ToDoUi({
    super.key,
    required this.time,
    required this.title,
    this.onUpdate, required bool isCompleted, required Null Function(dynamic isCompleted) onToggleComplete, required String id,
  });

  @override
  State<ToDoUi> createState() => _ToDoUiState();
}

class _ToDoUiState extends State<ToDoUi> {
  late String currentTime;
  late String currentTitle;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    currentTime = widget.time;
    currentTitle = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Time - tap to select
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currentTime,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: GestureDetector(
                onTap: _editTitle,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    currentTitle,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            Checkbox(
              value: isCompleted,
              onChanged: (value) {
                setState(() {
                  isCompleted = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(currentTime),
    );

    if (picked != null) {
      setState(() {
        currentTime = picked.format(context);
      });

      if (widget.onUpdate != null) {
        widget.onUpdate!(currentTime, currentTitle);
      }
    }
  }

  Future<void> _editTitle() async {
    TextEditingController controller = TextEditingController(
      text: currentTitle,
    );

    final String? newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Todo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter todo title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Save'),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.isNotEmpty) {
      setState(() {
        currentTitle = newTitle;
      });

      if (widget.onUpdate != null) {
        widget.onUpdate!(currentTime, currentTitle);
      }
    }
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final parts = timeString.replaceAll(RegExp(r'[^\d:]'), '').split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      if (timeString.toLowerCase().contains('pm') && hour != 12) {
        hour += 12;
      } else if (timeString.toLowerCase().contains('am') && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }
}
