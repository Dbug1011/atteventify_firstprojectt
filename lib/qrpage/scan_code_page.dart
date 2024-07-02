// import 'dart:typed_data';
// // import 'package:atteventify/presentation/scannerscreen_screen/scanpage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ScanCodePage extends StatefulWidget {
//   const ScanCodePage({Key? key}) : super(key: key);

//   @override
//   State<ScanCodePage> createState() => _ScanCodePageState();
// }

// class _ScanCodePageState extends State<ScanCodePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan QR Code'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.popAndPushNamed(context, "/generate");
//             },
//             icon: const Icon(
//               Icons.qr_code,
//             ),
//           ),
//         ],
//       ),
//       body: MobileScanner(
//         controller: MobileScannerController(
//           detectionSpeed: DetectionSpeed.noDuplicates,
//           returnImage: true,
//         ),
//         onDetect: (capture) async {
//           final List<Barcode> barcodes = capture.barcodes;
//           final Uint8List? image = capture.image;
//           if (barcodes.isNotEmpty) {
//             // Pass the scanned event ID back to the previous screen
//             String eventId = barcodes.first.rawValue!;
//             //first raw value sa barcode
//             Navigator.pop(context, eventId);

//             Map<String, dynamic> scannedItem = {
//               "ScannedItem": barcodes.toString(),
//               "Time": DateTime.now(),
      
//               "user_id": FirebaseAuth.instance.currentUser!.uid,
//             };

//             await FirebaseFirestore.instance
//                 .collection("events")
//                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                 .collection("Attendance")
//                 .add(scannedItem);
//           }
//           if (image != null) {
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: const Text('Scanned Image'),
//                   content: Image.memory(image),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }


// onDetect: (capture) async {
//   final List<Barcode> barcodes = capture.barcodes;
//   final Uint8List? image = capture.image;
//   if (barcodes.isNotEmpty) {
//     // Get the scanned QR code value
//     String qrCodeValue = barcodes.first.rawValue!;

//     // Get the event ID from the scanned QR code value
//     String eventId = qrCodeValue;

//     // Store the scanned QR code to Firebase
//     await FirebaseFirestore.instance
//         .collection("events")
//         .doc(eventId)
//         .collection("attendance")
//         .add({
//       "qr_code_value": qrCodeValue,
//       "user_id": FirebaseAuth.instance.currentUser!.uid,
//       "timestamp": FieldValue.serverTimestamp(),
//     });

//     // Show a dialog with the scanned QR code and its value
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Scanned QR Code"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("QR Code Value: $qrCodeValue"),
//               Image.memory(image!),
//             ],
//           ),
//         );
//       },
//     );
//   }
// },