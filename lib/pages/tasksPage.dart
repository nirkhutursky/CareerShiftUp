import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Predefined list of common tasks
  final List<Map<String, String>> _predefinedTasks = [
    {'title': 'Update resume', 'description': 'Review and update my resume'},
    {
      'title': 'Apply for jobs',
      'description': 'Submit applications on LinkedIn'
    },
    {
      'title': 'Research companies',
      'description': 'Find companies to apply to'
    },
  ];

  // Controllers for manual task input
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();

  // Function to add a manually entered task to Firestore
  Future<void> _addManualTask() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String deadline = _deadlineController.text;

    if (title.isNotEmpty) {
      await _firestore.collection('tasks').add({
        'title': title,
        'description': description,
        'status': 'pending',
        'deadline': deadline.isEmpty
            ? DateTime.now().add(Duration(days: 7))
            : DateTime.parse(deadline),
      });

      // Clear the input fields
      _titleController.clear();
      _descriptionController.clear();
      _deadlineController.clear();
    }
  }

  // Function to add a predefined task to Firestore
  Future<void> _addPredefinedTask(Map<String, String> task) async {
    await _firestore.collection('tasks').add({
      'title': task['title']!,
      'description': task['description']!,
      'status': 'pending',
      'deadline': DateTime.now().add(Duration(days: 7)), // Default deadline
    });
  }

  // Build task list from Firestore stream
  Widget _buildTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No tasks available.'));
        }

        final tasks = snapshot.data!.docs;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(task['title']),
              subtitle: Text(
                'Status: ${task['status']} | Deadline: ${task['deadline'].toDate()}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _firestore.collection('tasks').doc(tasks[index].id).delete();
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Tasks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Manual task entry section
            Text('Add Task Manually',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            TextField(
              controller: _deadlineController,
              decoration: InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addManualTask,
              child: Text('Add Task'),
            ),
            SizedBox(height: 20),

            // Predefined task selection section
            Text('Common Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _predefinedTasks.length,
                itemBuilder: (context, index) {
                  final task = _predefinedTasks[index];
                  return ListTile(
                    title: Text(task['title']!),
                    subtitle: Text(task['description']!),
                    onTap: () =>
                        _addPredefinedTask(task), // Add to Firestore on tap
                  );
                },
              ),
            ),

            // Current tasks section
            SizedBox(height: 20),
            Text('My Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(child: _buildTaskList()), // Display tasks from Firestore
          ],
        ),
      ),
    );
  }
}
