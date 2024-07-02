import 'package:atteventify/piechart.dart';
import 'package:atteventify/routes/app_routes.dart';
import 'package:atteventify/widgets/custom_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnalyticsscreenScreen extends StatefulWidget {
  const AnalyticsscreenScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsscreenScreenState createState() => _AnalyticsscreenScreenState();
}

class _AnalyticsscreenScreenState extends State<AnalyticsscreenScreen> {
  late List<Map<String, dynamic>> _dropdownItemList;
  String _selectedEvent = '';
  int _present = 0;
  int _absent = 0;
  int _lateCount = 0;
  int _totalPeople = 0;

  @override
  void initState() {
    super.initState();
    _dropdownItemList = [
      {'eventTitle': ''}
    ]; // Initialize with an empty value
    _getEvents();
    _getPeople();
  }

  void _getPeople() async {
    QuerySnapshot peopleQuerySnapshot = await FirebaseFirestore.instance
        .collection('people')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    // Calculate number of absent attendees
    _totalPeople = peopleQuerySnapshot.docs.length;
  }

  Future<void> _getEvents() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where('userId', isEqualTo: userId)
            .get();

        // Create a set to store unique event titles
        Set<String> eventTitles = Set<String>();

        // Add event titles to the set
        querySnapshot.docs.forEach((doc) {
          eventTitles.add(doc['eventTitle']);
        });

        // Convert the set to a list of maps for DropdownButton items
        setState(() {
          _dropdownItemList =
              eventTitles.map((title) => {'eventTitle': title}).toList();
        });

        // If there is only one event, select it by default
        if (_dropdownItemList.length == 1) {
          _selectedEvent = _dropdownItemList[0]['eventTitle'];
          _getAttendanceSummary(_selectedEvent);
        }
      }
    } catch (e) {
      print('Error getting events: $e');
    }
  }

  Future<void> _getAttendanceSummary(String eventTitle) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventTitle', isEqualTo: eventTitle)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String eventId = querySnapshot.docs.first.id;

        QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .collection('attendance')
            .get();

        if (attendanceSnapshot.docs.isNotEmpty) {
          setState(() {
            _present = 0;
            _absent = 0;
            _lateCount = 0;

            attendanceSnapshot.docs.forEach((doc) {
              if (doc.exists && doc.data() != null) {
                final data = doc.data() as Map<String, dynamic>;
                if (data.containsKey('status')) {
                  String status = data['status'];
                  if (status == 'Present') {
                    _present++;
                  } else if (status == 'Late') {
                    _lateCount++;
                  }
                } else {
                  // Handle the case where the 'status' field is missing
                  print('Status field is missing in the document snapshot');
                }
              }
            });

            _getPeople();
            _absent = _totalPeople - _present - _lateCount;
            _selectedEvent = eventTitle;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No attendance data available for this event.'),
            ),
          );
          setState(() {
            // If no attendance data is available
            _present = 0;
            _absent = 0;
            _lateCount = 0;
            _selectedEvent = eventTitle;
          });
          print('No attendance data available for this event.');
        }
      } else {
        print('Event document does not exist.');
      }
    } catch (e) {
      print('Error fetching event data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.analytics), // Icon beside "Analytics" title
              SizedBox(width: 5),
              Text('Analytics'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _selectedEvent == '' ? null : _selectedEvent,
                hint: Text('Select Event'),
                items: _dropdownItemList
                    .map((item) => DropdownMenuItem<String>(
                          value: item['eventTitle'],
                          child: Text(item['eventTitle']),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null && value != _selectedEvent) {
                    _getAttendanceSummary(value);
                  }
                },
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Attendance Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ), // Centered title
              SizedBox(height: 10),
              Text('Present: $_present'),
              Text('Absent: $_absent'),
              Text('Late: $_lateCount'),
              SizedBox(height: 20),
              Container(
                height: 200,
                child: MyPiechart(
                  present: _present,
                  absent: _absent,
                  late: _lateCount,
                  total: _totalPeople,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottombar(context),
      ),
    );
  }

  Widget buildAttendanceItem(String label, int count, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: $count",
            style: TextStyle(color: Colors.black),
          ),
          Icon(Icons.circle, size: 16, color: color), // Add colored circle icon
        ],
      ),
    );
  }

  Widget _buildBottombar(BuildContext context) {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        Navigator.pushReplacementNamed(context, getCurrentRoute(type));
      },
    );
  }

  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homescreenPage;
      case BottomBarEnum.Qrcode:
        return AppRoutes.attendancedetailsScreen;
      case BottomBarEnum.People:
        return AppRoutes.generatedlistScreen;
      case BottomBarEnum.Analytics:
        return AppRoutes.analyticsscreenScreen;
      default:
        return "/";
    }
  }
}
