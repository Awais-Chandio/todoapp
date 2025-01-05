import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethode {
  Future addTodayWork(Map<String, dynamic> userTodayMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("today")
        .doc(id)
        .set(userTodayMap);
  }

  Future addTomorrowWork(Map<String, dynamic> userTomorrowMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("tomorrow")
        .doc(id)
        .set(userTomorrowMap);
  }

  Future addNextWeekWork(userNextWeekMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("nextWeek")
        .doc(id)
        .set(userNextWeekMap);
  }

  Future<Stream<QuerySnapshot>> getAllTheWork(String day) async {
    return await FirebaseFirestore.instance.collection(day).snapshots();
  }

  updateIfTicked(String id, String day) async {
    return await FirebaseFirestore.instance
        .collection(day)
        .doc(id)
        .update({"Yes": true});
  }

  // New method for deleting a task
  Future deleteTask(String id, String day) async {
    return await FirebaseFirestore.instance.collection(day).doc(id).delete();
  }
}
