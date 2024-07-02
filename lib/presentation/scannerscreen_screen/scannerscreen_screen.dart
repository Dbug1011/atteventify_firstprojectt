import 'package:atteventify/presentation/scannerscreen_screen/foundcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerscreenScreen extends StatefulWidget {
  final String eventId;

  const ScannerscreenScreen({Key? key, required this.eventId})
      : super(key: key);

  @override
  _ScannerscreenScreenState createState() => _ScannerscreenScreenState();
}

class _ScannerscreenScreenState extends State<ScannerscreenScreen> {
  late String eventId;

  @override
  void initState() {
    super.initState();
    eventId = widget.eventId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/generate");
            },
            icon: Icon(Icons.qr_code),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner), // Add icon before text
                SizedBox(width: 5), // Add some space between icon and text
                Text(
                  "Scan your QR CODE",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanCodePage(eventId: eventId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 11),
                backgroundColor: Color.fromARGB(255, 12, 96, 164),
                textStyle: TextStyle(fontSize: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Start Scanning'),
            ),
            SizedBox(height: 20),
            Text(
              "Point your device's camera at the QR code",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanCodePage extends StatefulWidget {
  ScanCodePage({Key? key, required this.eventId}) : super(key: key);
  final String eventId;

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  late MobileScannerController _scannerController;
  late String eventId;
  bool errorMessageDisplayed = false; // Define errorMessageDisplayed here
  late Map<String, DateTime> lastDetectionTimes;
  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(); // Initialize the controller
    eventId = widget.eventId;
    lastDetectionTimes = {};
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code '),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/generate");
            },
            icon: const Icon(
              Icons.qr_code,
            ),
          ),
        ],
      ),
      body: MobileScanner(
        controller: _scannerController,
        onDetect: (barcodeCapture) =>
            _foundBarcode(context, barcodeCapture, eventId),
      ),
    );
  }

  void _foundBarcode(BuildContext context, BarcodeCapture barcodeCapture,
      String eventId) async {
    try {
      debugPrint('Event ID: $eventId');
      final String code = barcodeCapture.barcodes.first.rawValue ?? "---";
      debugPrint('Barcode found! $code');

      // Check if the code has been detected recently
      final DateTime now = DateTime.now();
      final lastDetectionTime = lastDetectionTimes[code];
      if (lastDetectionTime != null &&
          now.difference(lastDetectionTime).inSeconds < 5) {
        // Code detected too soon after the last detection, ignore
        return;
      }

      // Store the current detection time
      lastDetectionTimes[code] = now;

      // Get the event data from Firestore
      final DocumentSnapshot<Map<String, dynamic>> eventDoc =
          await FirebaseFirestore.instance
              .collection("events")
              .doc(eventId)
              .get();

      if (eventDoc.exists) {
        final Map<String, dynamic> eventData = eventDoc.data()!;
        final String eventStartString = eventData["eventStart"];

        // Get current date and time formatted in the same way
        final String currentDateTimeString =
            DateFormat("yyyy/M/d h:m a").format(DateTime.now());
        print("Event Start String: $eventStartString");
        print("Current Date Time String: $currentDateTimeString");
        // Compare the event start time with the current time
        final bool isLate =
            eventStartString.compareTo(currentDateTimeString) < 0;

        // Check if the scanned QR code value already exists in the 'attendance' subcollection
        final QuerySnapshot<Map<String, dynamic>> attendanceDocs =
            await FirebaseFirestore.instance
                .collection("events")
                .doc(eventId)
                .collection("attendance")
                .where("qr_code_value", isEqualTo: code)
                .get();

        if (attendanceDocs.docs.isEmpty) {
          // Assuming you have a method to get the current user's collection of people
          final List<String> currentUserPeopleNames =
              await getCurrentUserPeopleNames();

          // Extracting name string before comma from the QR code
          final String nameBeforeComma = code.split(',')[0].trim();

          if (currentUserPeopleNames.contains(nameBeforeComma)) {
            // Add the scanned QR code text to the 'attendance' subcollection
            final attendanceRef = FirebaseFirestore.instance
                .collection("events")
                .doc(eventId)
                .collection("attendance");

            // Check if the attendance entry already exists
            final existingAttendance = await attendanceRef
                .where("qr_code_value", isEqualTo: code)
                .limit(1)
                .get();

            if (existingAttendance.docs.isEmpty) {
              await attendanceRef.add({
                "qr_code_value": code,
                "user_id": FirebaseAuth.instance.currentUser!.uid,
                // "timestamp": Timestamp.now(),
                "status": isLate ? 'Late' : 'Present',
              });

              // Close the camera and navigate to another screen

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Attendance marked successfully!"),
                ),
              );
              Navigator.pop(context); // Close the camera screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoundCodeScreen(value: code),
                ),
              );
            } else {
              // Show a message indicating that the QR code has already been scanned
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("QR code has already been scanned!"),
                ),
              );
            }
          } else {
            // Show a message indicating that the person is not registered
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("The person is not registered!"),
              ),
            );
          }
        }
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Event not found!"),
          ),
        );
      }
    } catch (error) {
      if (!errorMessageDisplayed) {
        // Show an error message only if it hasn't been displayed before
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error marking attendance: $error",
            ),
          ),
        );
        errorMessageDisplayed = true;
      }
    }
  }

  Future<List<String>> getCurrentUserPeopleNames() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // Reference to the Firestore collection 'people'
    final peopleCollection = FirebaseFirestore.instance.collection('people');

    try {
      // Query Firestore to get the documents where the user_id field is equal to the current user's UID
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await peopleCollection
              .where('userId', isEqualTo: currentUserUid)
              .get();

      // Extract names from the documents where userId is the same as the current user's UID
      final List<String> names = querySnapshot.docs
          .where((doc) => doc['userId'] == currentUserUid)
          .map((doc) => doc['name'] as String)
          .toList();

      return names;
    } catch (error) {
      // Handle errors here, such as if the Firestore query fails
      print('Error fetching user people names: $error');
      return [];
    }
  }

  BuildContext? dialogContext;

  void showFoundCodeDialog(BuildContext context, {required String value}) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Disallow dismissing dialog by tapping on the background
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Found Code"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Scanned Code:", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Text(value, style: TextStyle(fontSize: 16)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Pop the screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
