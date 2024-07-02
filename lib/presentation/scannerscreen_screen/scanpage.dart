//  Future scanqr1() async {
//     final qrCode = await BarcodeScanner.scan();
//     setState(() {
//       this.qrCode = qrCode.toString();
//     });

//     if (qrCode.isNotEmpty) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) => _buildPopupDialog(context));
//     }
//   }

//   Widget _buildPopupDialog(BuildContext context) {
//     return AlertDialog(
//         buttonPadding: EdgeInsets.all(15),
//         scrollable: true,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         title: Text(
//           "You Scanned the Following Product:",
//           style: TextStyle(color: Colors.amber, fontSize: 23),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               qrCode,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           GestureDetector(
//             onTap: scanqr1,
//             child: Text(
//               "Re-Scan",
//               style: TextStyle(fontSize: 20, color: Colors.amber),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Map<String, dynamic> scaneditem = {
//                 "ScannedItem": qrCode.toString(),
//                 "Created On": FieldValue.serverTimestamp()
//               };
//               FirebaseFirestore.instance
//                   .collection("product")
//                   .doc(FirebaseAuth.instance.currentUser.uid)
//                   .set(scaneditem);
//               print(scaneditem);

//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => Payment_page()));
//             },
//             child: Text("upload",
//                 style: TextStyle(fontSize: 20, color: Colors.amber)),
//           )
//         ]);
//   }
// }

// FirebaseFirestore.instance
//               .collection("events")
//               .doc(FirebaseAuth.instance.currentUser.uid)
//               .collection("Attendance")
//               .add(scaneditem);

//   Map<String, dynamic> scaneditem = {
//             "ScannedItem": qrCode.toString(),
//             "Time": FieldValue.serverTimestamp(),
//             "user_id":id,
//           };
// FirebaseFirestore.instance
//               .collection("events")
//               .add("Attendance");

  