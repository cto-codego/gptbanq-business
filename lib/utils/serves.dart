// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Userstates {
//   String? user;
//   String? message;
//
//   Future getuserstatus() async {
//     final state = await FirebaseFirestore.instance.collection('App').get();
//
//     print(await state);
//     for (var item in state.docs) {
//       user = item.data()['status'];
//       message = item.data()['message'];
//     }
//
//     print("object $user");
//     print("object $message");
//   }
// }
