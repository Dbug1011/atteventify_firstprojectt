import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> uploadEventDetailsToStorage({
  String? eventTitle,
  String? eventVenue,
  String? eventStart,
  String? eventEnd,
}) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null &&
        eventTitle != null &&
        eventVenue != null &&
        eventStart != null &&
        eventEnd != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.json';
      final eventDetails = {
        'userId': userId,
        'eventTitle': eventTitle,
        'eventVenue': eventVenue,
        'eventStart': eventStart,
        'eventEnd': eventEnd,
      };
      final eventJson = jsonEncode(eventDetails);
      await storageRef.child(fileName).putString(eventJson);
    } else {
      print('Error: One or more event details is null');
    }
  } catch (e) {
    print('Error uploading event details: $e');
  }
}

Future<List<Map<String, dynamic>>> getEventDetailsFromStorage() async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final eventsFolderRef = storageRef.child(userId);
      final eventDetails = await eventsFolderRef.listAll();
      final List<Map<String, dynamic>> result = [];
      await Future.forEach(eventDetails.items, (Reference ref) async {
        final url = await ref.getDownloadURL();
        final data = await ref.getData();
        if (data != null) {
          final json = utf8.decode(data);
          result.add({...jsonDecode(json), 'url': url});
        } else {
          print('Error: Data for reference $ref is null');
        }
      });
      return result;
    } else {
      print('Error: User ID is null');
      return [];
    }
  } catch (e) {
    print('Error fetching event details: $e');
    return [];
  }
}
