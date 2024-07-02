import 'dart:typed_data';

import 'package:atteventify/presentation/generatedlist_screen/generatedlist_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeGenerator extends StatelessWidget {
  QrCodeGenerator({Key? key, required this.name, required this.phoneNumber})
      : super(key: key);

  final String name;
  final String phoneNumber;

  final ScreenshotController screenshotController = ScreenshotController();

  String generateQRData() {
    return '$name, $phoneNumber';
  }

  Future<void> _captureAndSaveImage(BuildContext context) async {
    final Uint8List? uint8list = await screenshotController.capture();
    if (uint8list != null) {
      await uploadImageToFirebase(uint8list, context);
      final PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        final result = await ImageGallerySaver.saveImage(uint8list);
        if (result['isSuccess']) {
          print('Image saved successfully');
        } else {
          print('Image not saved');
        }
      } else {
        print('Permission denied');
      }
    }
  }

  Future<void> uploadImageToFirebase(
      Uint8List image, BuildContext context) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.png';

      // Check if the name and phone number combination already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('people')
          .where('name', isEqualTo: name)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Combination already exists, show Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Combination already exists'),
            duration: Duration(seconds: 2), // Adjust the duration as needed
          ),
        );
        return;
      }

      // Upload image to Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      await storageRef.putData(image);

      // Get download URL of the uploaded image
      String downloadUrl = await storageRef.getDownloadURL();

      // Save image data to Firebase Firestore
      await FirebaseFirestore.instance.collection('people').add({
        'name': name,
        'phoneNumber': phoneNumber,
        'userId': userId,
        'qrCodeUrl': downloadUrl,
      });

      print('Image uploaded to Firebase Storage and data saved to Firestore');
    } catch (e) {
      print('Error uploading image and saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String qrData = generateQRData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                gapless: false,
                size: 320,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Scan the QR code to access the data'),
            ElevatedButton(
              onPressed: () async {
                await _captureAndSaveImage(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GeneratedlistScreen()),
                );

                // Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
