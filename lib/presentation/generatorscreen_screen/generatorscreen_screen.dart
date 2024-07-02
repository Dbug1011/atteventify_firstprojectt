import 'package:atteventify/qrpage/qrcodegenerator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class GenerateCodePage extends StatefulWidget {
  const GenerateCodePage({Key? key}) : super(key: key);

  @override
  State<GenerateCodePage> createState() => _GenerateCodePageState();
}

class _GenerateCodePageState extends State<GenerateCodePage> {
  String? name;
  String? phoneNumber;
  String? userId;
  List<String> docIDs = [];
// Getting docIds
  Future<void> getDocId() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid;
        QuerySnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('people')
                .where('userId', isEqualTo: userId) // Filter by userId
                .get();
        docIDs.clear(); // Clearing the list before adding new IDs
        snapshot.docs.forEach((document) {
          print(document.reference);
          docIDs.add(document.reference.id);
        });
      }
    } catch (e) {
      print('Error getting document IDs: $e');
      // Handle error as needed
    }
  }

  @override
  void initState() {
    super.initState();
    // Get current user ID
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
      }
    });
  }

  void _generateAndShowQRCode() async {
    if (name != null && phoneNumber != null) {
      // Generate QR code with name and phone number
      QrCodeGenerator qrGenerator =
          QrCodeGenerator(name: name!, phoneNumber: phoneNumber!);
// get qrGenerator
      // Navigate to the QR code page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => qrGenerator),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please provide both name and phone number."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/scan");
            },
            icon: const Icon(
              Icons.qr_code_scanner,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildTextField("Name", (value) {
              setState(() {
                name = value;
              });
            }),
            SizedBox(height: 16),
            _buildPhoneNumberField(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generateAndShowQRCode,
              child: Text('Generate', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: "Enter your $label",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 8),
        IntlPhoneField(
          decoration: InputDecoration(
            labelText: "Phone Number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: (phone) {
            phoneNumber = phone.completeNumber;
          },
        ),
      ],
    );
  }
}
