import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetEventName extends StatelessWidget {
  final String documentId;

  GetEventName({required this.documentId});

  @override
  Widget build(BuildContext context) {
    // Get the collection reference
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(documentId).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (data != null && data.containsKey('eventTitle')) {
              return Text("Event Title: ${data['eventTitle']}");
            }
          }
          return Text("No data available");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Text("Error loading data");
        }
      },
    );
  }
}
