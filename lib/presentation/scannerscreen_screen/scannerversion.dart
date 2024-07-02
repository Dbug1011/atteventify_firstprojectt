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
            Text(
              "Scan your QR CODE",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 20),
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
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({Key? key, required this.eventId}) : super(key: key);
  final String eventId;

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  late MobileScannerController _scannerController;
  late String eventId;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(); // Initialize the controller
    eventId = widget.eventId;
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
            DateFormat("yyyy/MM/dd hh:mm a").format(DateTime.now());

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
            // Call the showDialog function to display the found code dialog

            // Add the scanned QR code text to the 'attendance' subcollection
            await FirebaseFirestore.instance
                .collection("events")
                .doc(eventId)
                .collection("attendance")
                .add({
              "qr_code_value": code,
              "user_id": FirebaseAuth.instance.currentUser!.uid,
              // "timestamp": Timestamp.now(),
              "status": isLate ? 'Late' : 'Present',
            });

            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Attendance marked successfully!"),
              ),
            );
            showFoundCodeDialog(context, value: code);
          } else {
            // Show a message indicating that the person is not registered
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("The person is not registered!"),
              ),
            );
          }
        } else {
          // Show a message indicating that the QR code has already been scanned
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("QR code has already been scanned!"),
            ),
          );
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
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Error marking attendance: $error"), // null type is not a subtype of 'String'
        ),
      );
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
