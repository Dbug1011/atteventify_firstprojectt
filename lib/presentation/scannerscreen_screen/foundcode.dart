import 'package:flutter/material.dart';

class FoundCodeScreen extends StatelessWidget {
  final String value;

  const FoundCodeScreen({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Found Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scanned Code:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Pop the screen
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
