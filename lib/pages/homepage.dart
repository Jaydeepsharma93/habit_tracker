import 'package:flutter/material.dart';
import 'package:habit_tracker/components/drawer.dart';
import 'package:provider/provider.dart';

import '../components/myhabit_title.dart';
import '../components/myheatmap.dart';
import '../database/habtidatabase.dart';
import '../models/habit.dart';
import '../utils/habitutils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create a new habit"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().addHabit(newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(
                habit.id,
              );
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(
        children: [_buildHeatMap(), _buildHabitList()],
      ),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final habit = currentHabits[index];
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
          return MyHabitTile(
            text: habit.name,
            isCompleted: isCompletedToday,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (context) => editHabitBox(habit),
            deleteHabit: (context) => deleteHabitBox(habit),
          );
        });
  }

  Widget _buildHeatMap() {
    final habitDataBase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDataBase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDataBase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabits));
        } else {
          return Container();
        }
      },
    );
  }
}

