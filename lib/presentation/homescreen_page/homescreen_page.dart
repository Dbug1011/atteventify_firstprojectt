import 'package:atteventify/autho/auth_page.dart';
import 'package:atteventify/presentation/attendancedetails_screen/attendancedetails_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_search_view.dart';

class HomescreenPage extends StatefulWidget {
  @override
  _HomescreenPageState createState() => _HomescreenPageState();
}

class _HomescreenPageState extends State<HomescreenPage> {
  List<String> docIDs = [];
  List<Map<String, dynamic>> eventDataList = [];
  List<Map<String, dynamic>> eventSuggestions = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call getDocId when the page is initialized
    getDocId();
  }

  // Fetch events under the current user's userId
  Future<void> getDocId() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid;
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('events')
            .where('userId', isEqualTo: userId)
            .get();
        // Update docIDs with the IDs of fetched documents
        setState(() {
          docIDs = snapshot.docs.map((doc) => doc.id).toList();
          eventDataList = snapshot.docs.map((doc) => doc.data()).toList();
        });
      }
    } catch (e) {
      print('Error getting document IDs: $e');
      // Handle error as needed
    }
  }

  // Filter events based on typed text and update suggestions
  void filterEvents(String value) {
    eventSuggestions.clear();
    if (value.isNotEmpty) {
      for (Map<String, dynamic> event in eventDataList) {
        if (event['eventTitle'].toLowerCase().contains(value.toLowerCase())) {
          eventSuggestions.add(event);
        }
      }
    }
    setState(() {});
  }

  // Build the list of events based on filtered suggestions
  Widget _buildEventList(BuildContext context) {
    List<Map<String, dynamic>> eventsToDisplay =
        eventSuggestions.isNotEmpty ? eventSuggestions : eventDataList;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: eventsToDisplay.length,
            itemBuilder: (context, index) {
              String eventId = docIDs[index]; // Get the event ID
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () async {
                    // Handle event tap as before
                    Map<String, dynamic>? eventData =
                        await getEventData(docIDs[index], docIDs);
                    if (eventData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendancedetailsScreen(
                              eventData: eventData,
                              eventId: docIDs[index]), // Pass event data
                        ),
                      );
                    } else {
                      // Handle case where event data is not available
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Event data not available'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(eventsToDisplay[index]['eventTitle']),
                      // You can add more details if needed
                      trailing: IconButton(
                        icon: SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(
                            Icons.delete,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, eventId);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillGray,
          child: Column(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgTteventify1,
                height: 218.v,
                width: 390.h,
              ),
              SizedBox(height: 12.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: CustomSearchView(
                  controller: searchController,
                  hintText: "Search Event",
                  onChanged: filterEvents, // Call filterEvents method
                ),
              ),
              SizedBox(height: 12.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: Color.fromARGB(255, 12, 96, 164), // Icon color
                          size: 24.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Events',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Title color
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildPlusButton(context),
                        SizedBox(width: 16.h),
                        _buildLogoutButton(context),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.v),
              Expanded(
                child: _buildEventList(context),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildPlusButton(BuildContext context) {
    return CustomIconButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.eventdetailsScreen);
      },
      height: 56.adaptSize,
      width: 56.adaptSize,
      padding: EdgeInsets.all(16.h),
      decoration: IconButtonStyleHelper.outlineErrorContainer,
      alignment: Alignment.centerRight,
      child: CustomImageView(
        imagePath: ImageConstant.imgDepth4Frameplus,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return CustomIconButton(
      onPressed: () {
        showLogoutConfirmation(context);
      },
      height: 56.adaptSize,
      width: 56.adaptSize,
      padding: EdgeInsets.all(16.h),
      decoration: IconButtonStyleHelper.outlineErrorContainer,
      alignment: Alignment.centerRight,
      child: CustomImageView(
        imagePath: ImageConstant.imgDepth4Framelogout,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        String route = getCurrentRoute(type);
        Navigator.of(context).pushNamed(route);
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

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 10), // Adjust padding
          title: Text("Confirmation",
              style: TextStyle(fontSize: 12)), // Set title font size
          content: Text(
            "Are you sure you want to log out?",
            style: TextStyle(fontSize: 8), // Set smaller font size
          ),
          actionsPadding:
              EdgeInsets.symmetric(horizontal: 10), // Adjust actions padding
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                signUserOut(context);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 10, // Set smaller font size
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 10, // Set smaller font size
                ),
              ),
            ),
          ],
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set rounded corners
          ),
        );
      },
    );
  }

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    // Navigate back to the AuthPage after signing out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  Future<Map<String, dynamic>?> getEventData(
      String eventId, List<String> docIDs) async {
    try {
      int left = 0;
      int right = docIDs.length - 1;

      while (left <= right &&
          eventId.compareTo(docIDs[left]) >= 0 &&
          eventId.compareTo(docIDs[right]) <= 0) {
        // Calculate the mid index using interpolation formula
        int mid = left +
            ((eventId.compareTo(docIDs[left])) *
                (right - left) ~/
                (docIDs[right].compareTo(docIDs[left])));

        print('Left: $left, Right: $right, Mid: $mid');

        // Ensure mid index is within bounds
        if (mid < 0 || mid >= docIDs.length) {
          break;
        }

        if (eventId == docIDs[mid]) {
          // Match found, retrieve event data
          DocumentSnapshot<Map<String, dynamic>> eventDoc =
              await FirebaseFirestore.instance
                  .collection('events')
                  .doc(docIDs[mid])
                  .get();

          if (eventDoc.exists) {
            // Extract the data from the document
            Map<String, dynamic> eventData = eventDoc.data()!;
            return eventData;
          }
        }

        if (docIDs[mid].compareTo(eventId) < 0) {
          left = mid + 1;
        } else {
          right = mid - 1;
        }
      }

      return null; // Event data not found
    } catch (e) {
      print('Error fetching event data: $e');
      return null; // Return null in case of an error
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Event', style: TextStyle(fontSize: 12)),
          content: Text('Are you sure you want to remove this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to delete the person
                deleteEvent(docId);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomescreenPage()),
                ); // Close the dialog
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteEvent(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(docId).delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
