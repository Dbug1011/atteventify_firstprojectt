import 'package:atteventify/presentation/scannerscreen_screen/scannerscreen_screen.dart';
import 'package:atteventify/widgets/app_bar%20appbar_leading_image.dart%20appbar_title.dart%20appbar_trailing_image.dart%20custom_app_bar.dart/appbar_title.dart';
import 'package:atteventify/widgets/app_bar%20appbar_leading_image.dart%20appbar_title.dart%20appbar_trailing_image.dart%20custom_app_bar.dart/appbar_trailing_image.dart';
import 'package:atteventify/widgets/app_bar%20appbar_leading_image.dart%20appbar_title.dart%20appbar_trailing_image.dart%20custom_app_bar.dart/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class AttendancedetailsScreen extends StatelessWidget {
  AttendancedetailsScreen({
    Key? key,
    required this.eventData,
    required this.eventId,
  }) : super(key: key);

  final Map<String, dynamic> eventData;
  final String eventId;

  @override
  Widget build(BuildContext context) {
    final String eventTitle = eventData['eventTitle'];
    final String eventVenue = eventData['eventVenue'];
    final String eventStart = eventData['eventStart'];
    final String eventEnd = eventData['eventEnd'];

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.v),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScannerscreenScreen(
                        eventId: eventId,
                      ),
                    ),
                  );
                },
                text: "SCAN ME!",
                buttonTextStyle: CustomTextStyles.titleMediumBold_1,
              ),
              SizedBox(height: 28.v),
              _buildEventInfoRow(
                context,
                eventTitle: "Event Title",
                sampleCounter: eventTitle,
              ),
              _buildEventInfoRow(
                context,
                eventTitle: "Event Venue",
                sampleCounter: eventVenue,
              ),
              _buildEventInfoRow(
                context,
                eventTitle: "Event Start",
                sampleCounter: eventStart,
              ),
              _buildEventInfoRow(
                context,
                eventTitle: "Event End",
                sampleCounter: eventEnd,
              ),
              SizedBox(height: 39.v),
              _buildAttendeeList(context),
              SizedBox(height: 12.v),
              Container(
                height: 24.v,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: appTheme.gray100,
                ),
              ),
              SizedBox(height: 60.v),
            ],
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: BackButton(
        color: Color.fromARGB(255, 197, 197, 197),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: AppbarTitle(
        text: "Atteventify",
        margin: EdgeInsets.only(left: 24.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgDepth3Frame2,
          margin: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 8.v),
        ),
      ],
    );
  }

  Widget _buildEventInfoRow(
    BuildContext context, {
    required String eventTitle,
    required String sampleCounter,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.v),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray100,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              eventTitle,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.primaryContainer,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: Text(
                sampleCounter,
                style: CustomTextStyles.bodyMediumOnPrimary.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeeList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attendee List",
          style: CustomTextStyles.titleMediumBold,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 3, 126, 7), // Green color indicator
                shape: BoxShape.rectangle,
              ),
            ),
            SizedBox(width: 8.h),
            Text(
              "Present",
              style: CustomTextStyles.bodyMediumOnPrimary,
            ),
            SizedBox(width: 16.h), // Adjust spacing as needed
            Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 241, 217, 4), // Yellow color indicator
                shape: BoxShape.rectangle,
              ),
            ),
            SizedBox(width: 8.h),
            Text(
              "Late",
              style: CustomTextStyles.bodyMediumOnPrimary,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .collection('attendance')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  // Check if data is available
                  final List<Map<String, dynamic>> attendees =
                      (snapshot.data?.docs ?? [])
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 32.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.h),
                            );
                          },
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: attendees.length,
                        itemBuilder: (context, index) {
                          final attendee = attendees[index];
                          final name = attendee['qr_code_value'] != null
                              ? attendee['qr_code_value'].split(',')[0]
                              : '';
                          final phoneNumber = attendee['qr_code_value'] != null
                              ? attendee['qr_code_value'].split(',')[1]
                              : '';
                          final status = attendee['status'];

                          Color getStatusColor() {
                            if (status == 'Present') {
                              return const Color.fromARGB(255, 3, 126, 7);
                            } else if (status == 'Late') {
                              return const Color.fromARGB(255, 241, 217, 4);
                            } else {
                              return Color.fromARGB(255, 255, 255, 255);
                            }
                          }

                          return Container(
                            padding: EdgeInsets.all(8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 16.h,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    color: getStatusColor(),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style:
                                          CustomTextStyles.bodyMediumOnPrimary,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      phoneNumber,
                                      style:
                                          CustomTextStyles.bodyMediumOnPrimary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Container(); // Return an empty container if no data available
                }
            }
          },
        ),
      ],
    );
  }
}
