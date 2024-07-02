import 'package:atteventify/routes/app_routes.dart';
import 'package:flutter/material.dart';

class ColumnItemWidget extends StatelessWidget {
  final String eventTitle;
  final String eventVenue;
  final String eventStart;
  final String eventEnd;

  const ColumnItemWidget({
    required this.eventTitle,
    required this.eventVenue,
    required this.eventStart,
    required this.eventEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to event details screen
        Navigator.pushNamed(
          context,
          AppRoutes.eventdetailsScreen,
          arguments: {
            'eventTitle': eventTitle,
            'eventVenue': eventVenue,
            'eventStart': eventStart,
            'eventEnd': eventEnd,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Venue: $eventVenue',
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Start: $eventStart',
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'End: $eventEnd',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
