import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/dialogbox.dart';
import 'package:todo_app/components/theme_provider.dart';
import 'package:todo_app/components/todoprovider.dart';
import 'package:todo_app/components/todotile.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = TextEditingController();
  DateTime? _selectedDueDate;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void createNewTask(BuildContext context) {
    _selectedDueDate = null;
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: () => saveNewTask(context),
          onDateSelected: (date) => setState(() => _selectedDueDate = date),
        );
      },
    );
  }

  void saveNewTask(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      Provider.of<TodoProvider>(context, listen: false)
          .addTask(_controller.text, _selectedDueDate);
      _controller.clear();
      _selectedDueDate = null;
      Navigator.of(context).pop();
    }
  }

  void editTask(BuildContext context, int index) {
    _controller.text = Provider.of<TodoProvider>(context, listen: false)
        .toDoList[index][0] as String;
    _selectedDueDate =
    Provider.of<TodoProvider>(context, listen: false).toDoList[index][3]
    as DateTime?;
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: () => saveEditedTask(context, index),
          onDateSelected: (date) => setState(() => _selectedDueDate = date),
        );
      },
    );
  }

  void saveEditedTask(BuildContext context, int index) {
    if (_controller.text.isNotEmpty) {
      Provider.of<TodoProvider>(context, listen: false)
          .editTask(index, _controller.text, _selectedDueDate);
      _controller.clear();
      _selectedDueDate = null;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('To Do'),
        actions: [
          DropdownButton<String>(
            value: Provider.of<TodoProvider>(context).sortBy,
            items: const [
              DropdownMenuItem(
                  value: 'creationDate', child: Text('Sort by Creation Date')),
              DropdownMenuItem(value: 'dueDate', child: Text('Sort by Due Date')),
            ],
            onChanged: (value) =>
                Provider.of<TodoProvider>(context, listen: false).sortTasks(value),
          ),
          Builder(
            builder: (newContext) => IconButton(
              icon: Icon(
                Provider.of<ThemeProvider>(newContext).isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () =>
                  Provider.of<ThemeProvider>(newContext, listen: false)
                      .toggleTheme(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewTask(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.toDoList.length,
            itemBuilder: (context, index) {
              return TodoTile(
                taskName: provider.toDoList[index][0] as String,
                taskCompleted: provider.toDoList[index][1] as bool,
                dueDate: provider.toDoList[index][3] as DateTime?,
                editFunction: (context) => editTask(context, index),
                deleteFunction: (context) =>
                    Provider.of<TodoProvider>(context, listen: false)
                        .deleteTask(index),
                onChanged: (value) =>
                    Provider.of<TodoProvider>(context, listen: false)
                        .checkBoxChanged(index),
              );
            },
          );
        },
      ),
    );
  }
}