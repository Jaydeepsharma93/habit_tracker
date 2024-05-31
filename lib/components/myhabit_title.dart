import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  final void Function(bool?)? onChanged;

  const MyHabitTile(
      {super.key,
      required this.text,
      required this.isCompleted,
      required this.onChanged,
      this.editHabit,
      this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade700,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ), // BoxDecoration
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(text,
                  style: TextStyle(
                      color: isCompleted
                          ? Colors.white
                          : Theme.of(context).colorScheme.inversePrimary)),
              leading: Checkbox(
                  activeColor: Colors.green,
                  value: isCompleted,
                  onChanged: onChanged),
            ),
          ),
        ),
      ),
    ); // Container
  }
}
