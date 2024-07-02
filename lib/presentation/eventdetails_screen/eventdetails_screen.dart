import 'package:atteventify/presentation/homescreen_page/homescreen_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventdetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  EventdetailsScreen({required this.event});

  @override
  _EventdetailsScreenState createState() => _EventdetailsScreenState();
}

class _EventdetailsScreenState extends State<EventdetailsScreen> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventVenueController = TextEditingController();
  final TextEditingController _eventStartController = TextEditingController();
  final TextEditingController _eventEndController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values if event is provided
    _eventTitleController.text = widget.event['eventTitle'] ?? '';
    _eventVenueController.text = widget.event['eventVenue'] ?? '';
    _eventStartController.text = widget.event['eventStart'] ?? '';
    _eventEndController.text = widget.event['eventEnd'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _eventTitleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _eventVenueController,
              decoration: InputDecoration(
                labelText: 'Event Venue',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _eventStartController,
              decoration: InputDecoration(
                labelText: 'Event Start',
              ),
              onTap: () {
                _selectDate(context, _eventStartController);
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _eventEndController,
              decoration: InputDecoration(
                labelText: 'Event End',
              ),
              onTap: () {
                _selectDate(context, _eventEndController);
              },
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                saveEvent();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomescreenPage()),
                // );
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  void saveEvent() async {
    final eventTitle = _eventTitleController.text.trim();
    final eventVenue = _eventVenueController.text.trim();
    final eventStart = _eventStartController.text.trim();
    final eventEnd = _eventEndController.text.trim();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if any of the text fields are empty
    if (eventTitle.isEmpty ||
        eventVenue.isEmpty ||
        eventStart.isEmpty ||
        eventEnd.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all the fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return; // Exit the method without saving the event
    }

    try {
      // Check if the event already exists
      final duplicateEvent = await FirebaseFirestore.instance
          .collection('events')
          .where('eventTitle', isEqualTo: eventTitle)
          .where('eventVenue', isEqualTo: eventVenue)
          .where('eventStart', isEqualTo: eventStart)
          .where('eventEnd', isEqualTo: eventEnd)
          .where('userId', isEqualTo: userId)
          .get();

      if (duplicateEvent.docs.isNotEmpty) {
        // If a duplicate event is found, show an error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Duplicate event detected.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return; // Exit the method without saving the event
      }

      // Add the event details to the 'events' collection
      DocumentReference eventDocRef =
          await FirebaseFirestore.instance.collection('events').add({
        'eventTitle': eventTitle,
        'eventVenue': eventVenue,
        'eventStart': eventStart,
        'eventEnd': eventEnd,
        'userId': userId,
      });

      // Add a subcollection 'attendance' under the event document
      await eventDocRef.collection('attendance').add({});

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomescreenPage()),
      ); // Go back to the previous screen
    } catch (e) {
      print('Error adding event details: $e');
      // Handle error as needed
    }
  }

  Future<void> addEventDetails(String eventTitle, String eventVenue,
      String eventStart, String eventEnd, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('events').add({
        'eventTitle': eventTitle,
        'eventVenue': eventVenue,
        'eventStart': eventStart,
        'eventEnd': eventEnd,
        'userId': userId,
      });
    } catch (e) {
      print('Error adding event details: $e');
      // Handle error as needed
    }
  }

// await addMultipleCollection(
//   id: result.id,
// )

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          final formattedDate =
              '${picked.year}/${picked.month}/${picked.day} ${time.format(context)}';
          controller.text = formattedDate;
        });
      }
    }
  }
}
