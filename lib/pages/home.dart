import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:todoapp/service/database.dart';
import 'package:intl/intl.dart'; // for date formatting

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool today = true, tomorrow = false, nextWeek = false;
  Stream? todoStream;
  DateTime selectedDateTime =
      DateTime.now(); // Default to current date and time

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  // Fetch tasks based on selected category
  getOnTheLoad() async {
    todoStream = await DatabaseMethode().getAllTheWork(
      today
          ? "today"
          : tomorrow
              ? "tomorrow"
              : "nextWeek",
    );
    setState(() {});
  }

  // Format date and time
  String formatDateTime(DateTime dateTime) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('hh:mm a');
    return "${dateFormatter.format(dateTime)} at ${timeFormatter.format(dateTime)}";
  }

  // Delete task function with confirmation dialog
  Future<void> _deleteTask(String taskId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirm) {
      await DatabaseMethode().deleteTask(
        taskId,
        today
            ? "today"
            : tomorrow
                ? "tomorrow"
                : "nextWeek",
      );
    }
  }

  // Widget to display tasks
  Widget allWork() {
    return Expanded(
      child: StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              DateTime taskDateTime = ds["DateTime"] != null
                  ? (ds["DateTime"] as Timestamp).toDate()
                  : DateTime.now();

              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                tileColor: Colors.white.withOpacity(0.1),
                leading: Checkbox(
                  activeColor: const Color(0xFF279cfb),
                  value: ds["Yes"],
                  onChanged: (newValue) async {
                    await DatabaseMethode().updateIfTicked(
                      ds["Id"],
                      today
                          ? "today"
                          : tomorrow
                              ? "tomorrow"
                              : "nextWeek",
                    );
                    setState(() {
                      ds.reference.update({"Yes": newValue});
                    });
                  },
                ),
                title: Text(
                  ds["Work"],
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                subtitle: Text(
                  "Due on: ${formatDateTime(taskDateTime)}",
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _deleteTask(ds["Id"]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openBox,
        backgroundColor: const Color(0xFF3A85F5),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 90, left: 10, right: 5),
        //  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, left: 10, right: 5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF89CFF0),
              Color(0xFF00509E),
              Color(0xFF003F63),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hello Awais",
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Add your tasks here",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCategoryButton("Today", today, () async {
                  setState(() {
                    today = true;
                    tomorrow = false;
                    nextWeek = false;
                  });
                  await getOnTheLoad();
                }),
                buildCategoryButton("Tomorrow", tomorrow, () async {
                  setState(() {
                    today = false;
                    tomorrow = true;
                    nextWeek = false;
                  });
                  await getOnTheLoad();
                }),
                buildCategoryButton("Next Week", nextWeek, () async {
                  setState(() {
                    today = false;
                    tomorrow = false;
                    nextWeek = true;
                  });
                  await getOnTheLoad();
                }),
              ],
            ),
            const SizedBox(height: 20),
            allWork(),
          ],
        ),
      ),
    );
  }

  // Reusable widget for category buttons
  Widget buildCategoryButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3A85F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? Colors.transparent : Colors.white, width: 2),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Function to open the add task dialog
  Future openBox() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.red),
                    ),
                    const Spacer(),
                    const Text("Add Task",
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Task Description"),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: todoController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Enter your task"),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Select Date and Time"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );
                      if (pickedTime != null) {
                        selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      }
                    }
                  },
                  child: Text(formatDateTime(selectedDateTime)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String taskId = randomAlphaNumeric(10);
                    today
                        ? DatabaseMethode().addTodayWork({
                            "Work": todoController.text,
                            "Id": taskId,
                            "Yes": false,
                            "DateTime": selectedDateTime,
                          }, taskId)
                        : tomorrow
                            ? DatabaseMethode().addTomorrowWork({
                                "Work": todoController.text,
                                "Id": taskId,
                                "Yes": false,
                                "DateTime": selectedDateTime,
                              }, taskId)
                            : DatabaseMethode().addNextWeekWork({
                                "Work": todoController.text,
                                "Id": taskId,
                                "Yes": false,
                                "DateTime": selectedDateTime,
                              }, taskId);
                    Navigator.pop(context);
                    todoController.clear();
                    setState(() {});
                  },
                  child: const Text("Add Task"),
                ),
              ],
            ),
          ),
        ),
      );
}
