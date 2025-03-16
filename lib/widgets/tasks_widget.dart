import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  final List<Task> _tasks = [];

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddTaskWidget(onSave: _addTask);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "images/pexels-a-darmel-8164743.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: _tasks.isEmpty
                    ? const Center(
                  child: Icon(Icons.task_alt, size: 80, color: Colors.white),
                )
                    : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final timeLeft = task.deadline.difference(DateTime.now());
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(task.name),
                            content: Text(task.details),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(task.icon, color: Colors.blue),
                                const SizedBox(width: 10),
                                Text(task.name, style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.timer, color: Colors.brown),
                                const SizedBox(width: 5),
                                Text("${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m"),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeTask(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: _showAddTaskDialog,
                  child: const Text("Add Task",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Task {
  final String name;
  final String details;
  final DateTime deadline;
  final IconData icon;

  Task({required this.name, required this.details, required this.deadline, required this.icon});
}

class AddTaskWidget extends StatefulWidget {
  final Function(Task) onSave;

  const AddTaskWidget({super.key, required this.onSave});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  IconData _selectedIcon = Icons.work;
  final List<IconData> _icons = [
    Icons.school,
    Icons.health_and_safety,
    Icons.book,
    Icons.work,
    Icons.favorite,
    Icons.sports_esports,
    Icons.music_note,
    Icons.accessibility_new,
  ];
  String? _errorMessage;
  String? _deadlineError;

  void _showIconSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Icon"),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: _icons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final icon = _icons[index];
                return IconButton(
                  icon: Icon(icon, color: _selectedIcon == icon ? Colors.brown : Colors.black),
                  onPressed: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _saveTask() {
    // التحقق من أن حقل اسم التاسك غير فارغ
    if (_nameController.text.isEmpty) {
      setState(() {
        _errorMessage = "Task name is required";
      });
      return;
    }
    // التحقق من أن التاريخ المُختار هو اليوم أو يوم قادم
    if (_selectedDate.isBefore(DateTime.now())) {
      setState(() {
        _deadlineError = "Deadline must be today or in the future";
      });
      return;
    }
    // إذا كانت جميع البيانات صحيحة، قم بمسح رسائل الخطأ وإنشاء التاسك
    setState(() {
      _errorMessage = null;
      _deadlineError = null;
    });
    final task = Task(
      name: _nameController.text,
      details: _detailsController.text,
      deadline: _selectedDate,
      icon: _selectedIcon,
    );
    widget.onSave(task);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  prefixIcon: const Icon(Icons.task, color: Colors.brown),
                  border: const OutlineInputBorder(),
                  labelText: "Task Name",
                  hintText: "Enter task name",
                  //labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
                  errorText: _errorMessage,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  prefixIcon: const Icon(Icons.description, color: Colors.brown),
                  border: const OutlineInputBorder(),
                  labelText: "Task Details",
                  hintText: "Enter task details",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Text("Set Deadline: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",style: TextStyle(color: Colors.white),),
              ),
              if (_deadlineError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _deadlineError!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              const SizedBox(height: 10),
              // Add Icon button under the deadline button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // لون الخلفية بني
                ),
                onPressed: _showIconSelectionDialog,
                icon: const Icon(Icons.add, color: Colors.white), // لون الأيقونة أبيض
                label: const Text(
                  "Add Icon",
                  style: TextStyle(color: Colors.white), // لون النص أبيض
                ),
              )
              ,

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                onPressed: _saveTask,
                child: const Text("Save",style: TextStyle(color: Colors.white),),
              ),

            ],
          ),
        ),
      ),
    );
  }
}