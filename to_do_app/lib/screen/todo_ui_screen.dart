import 'package:flutter/material.dart';

class ToDoUi extends StatelessWidget {
  final String id;
  final String time;
  final String title;
  final bool isCompleted;
  final Function(String, String)? onUpdate;
  final Function(bool)? onToggleComplete;

  const ToDoUi({
    super.key,
    required this.id,
    required this.time,
    required this.title,
    this.isCompleted = false,
    this.onUpdate,
    this.onToggleComplete,
  });

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
         
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

           
            Expanded(
              child: GestureDetector(
                onTap: () => _editTitle(context),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

           
            Checkbox(
              value: isCompleted,
              onChanged: (value) {
                if (onToggleComplete != null) {
                  onToggleComplete!(value ?? false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(time),
    );

    if (picked != null && onUpdate != null) {
      onUpdate!(picked.format(context), title);
    }
  }

  Future<void> _editTitle(BuildContext context) async {
    TextEditingController controller = TextEditingController(text: title);

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

    if (newTitle != null && newTitle.isNotEmpty && onUpdate != null) {
      onUpdate!(time, newTitle);
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