import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> addMultipleCollections({
  required String id,
  required String name,
  required String phone,
  required DateTime time,
  required DateTime eventStartTime,
}) async {
  try {
    // Get the reference to the events collection
    CollectionReference eventsRef =
        FirebaseFirestore.instance.collection('events');

    // // Get the current user's ID
    // String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Calculate the status based on the event start time and scan time
    bool isLate = time.isAfter(eventStartTime);

    // Add user's attendance to the event's Attendance subcollection
    await eventsRef.doc(id).collection('Attendance').add({
      'name': name,
      'phone': phone,
      'time': time,
      'status': isLate ? 'Late' : 'Present',
    });

    return 'Attendance added successfully!';
  } catch (e) {
    print('Error adding attendance: $e');
    return null;
  }
}
