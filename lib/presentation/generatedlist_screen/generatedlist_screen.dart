import 'dart:typed_data';

import 'package:atteventify/core/utils/image_constant.dart';
import 'package:atteventify/core/utils/size_utils.dart';
import 'package:atteventify/routes/app_routes.dart';
import 'package:atteventify/theme/custom_text_style.dart';
import 'package:atteventify/theme/theme_helper.dart';
import 'package:atteventify/widgets/custom_bottom_bar.dart';
import 'package:atteventify/widgets/custom_elevated_button.dart';
import 'package:atteventify/widgets/custom_image_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeneratedlistScreen extends StatelessWidget {
  GeneratedlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgTteventify1,
                height: 218.v,
                width: 390.h,
              ),
              SizedBox(height: 12.v),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder:
                          AppRoutes.routes[AppRoutes.generatorscreenScreen]!));
                },
                text: "Generate QR Code Here",
                margin: EdgeInsets.symmetric(horizontal: 16.h),
                buttonTextStyle: CustomTextStyles.titleMediumBold_1,
              ),
              SizedBox(height: 30.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Color.fromARGB(255, 12, 96, 164),
                      ),
                      // Icon beside "People List"
                      SizedBox(width: 8.0),
                      Text(
                        "People List",
                        style: CustomTextStyles.titleMediumBold,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.v),
              Expanded(
                child: _buildPeopleList(context),
              ),
              Container(
                height: 58.v,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: appTheme.gray100,
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildRownameOne(
    BuildContext context,
    String name,
    String phoneNumber,
    String qrCodeUrl,
    String docId,
  ) {
    return GestureDetector(
      onTap: () {
        _showQRImageDialog(context, name, qrCodeUrl);
      },
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Container color
                  borderRadius: BorderRadius.circular(8.0), // Add border radius
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Name text color
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            phoneNumber,
                            style: TextStyle(
                              fontSize: 10.0,
                              color:
                                  Colors.grey[600], // Phone number text color
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: SizedBox(
                          width: 24, // Adjust the width and height as needed
                          height: 24,
                          child: Icon(
                            Icons.delete,
                            size: 16, // Adjust the size as needed
                            color: Colors.grey, // Set the color to gray
                          ),
                        ),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, docId);
                        },
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleList(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getPeopleDocIds(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                color: Colors.red, // Error text color
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          List<Map<String, dynamic>> personDataList = snapshot.data!;
          return ListView.builder(
            itemCount: personDataList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> personData = personDataList[index];
              String name = personData['name'];
              String phoneNumber = personData['phoneNumber'];
              String qrCodeUrl = personData['qrCodeUrl'];
              return _buildRownameOne(
                context,
                name,
                phoneNumber,
                qrCodeUrl,
                personData['docId'], // Added argument for docId
              );
            },
          );
        }
      },
    );
  }

  void _showQRImageDialog(BuildContext context, String name, String qrCodeUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'QR Code for $name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                FutureBuilder<Widget>(
                  future: _loadQRImage(qrCodeUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error loading QR code');
                    } else {
                      return snapshot.data!;
                    }
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text('Close', style: TextStyle(color: Colors.black))),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Widget> _loadQRImage(String qrCodeUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(qrCodeUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
        Image qrImage = Image.memory(bytes);
        return qrImage;
      } else {
        print('Failed to load QR image: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
        return Text('Failed to load QR code: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error loading QR image: $e');
      return Text('Error loading QR code');
    }
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

  Future<void> deletePerson(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('people').doc(docId).delete();
    } catch (e) {
      print('Error deleting person: $e');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Person', style: TextStyle(fontSize: 12)),
          content: Text('Are you sure you want to delete this person?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GeneratedlistScreen()),
                );
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to delete the person
                deletePerson(docId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GeneratedlistScreen()),
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

  Future<List<Map<String, dynamic>>> getPeopleDocIds(
      String currentUserId) async {
    try {
      // Make a query to the 'people' collection where the 'userId' field matches the currentUserId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('people')
          .where('userId', isEqualTo: currentUserId)
          .get();

      // Extract and return the list of sorted person data with document IDs
      List<Map<String, dynamic>> personDataList = querySnapshot.docs
          .map(
              (doc) => {'docId': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
      personDataList.sort((a, b) {
        return a['name'].compareTo(b['name']);
      });
      return personDataList;
    } catch (e) {
      // Handle any errors
      print('Error fetching people docIds: $e');
      return []; // Return an empty list in case of error
    }
  }
}
