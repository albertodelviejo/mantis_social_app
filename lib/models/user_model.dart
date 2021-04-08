import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  final String id;
  final String name;
  final bool isBlocked;
  String address;
  final Map coordinates;
  final List sexualOrientation;
  final String gender;
  final String showGender;
  final int age;
  final String phoneNumber;
  int maxDistance;
  Timestamp lastmsg;
  final Map ageRange;
  final Map editInfo;
  List imageUrl = [];
  var distanceBW;
  UserModel({
    @required this.id,
    @required this.age,
    @required this.address,
    this.isBlocked,
    this.coordinates,
    @required this.name,
    @required this.imageUrl,
    this.phoneNumber,
    this.lastmsg,
    this.gender,
    this.showGender,
    this.ageRange,
    this.maxDistance,
    this.editInfo,
    this.distanceBW,
    this.sexualOrientation,
  });
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);

    return UserModel(
        id: doc.data()['userId'],
        isBlocked:
            doc.data()['isBlocked'] != null ? doc.data()['isBlocked'] : false,
        phoneNumber: doc.data()['phoneNumber'],
        name: doc.data()['UserName'],
        editInfo: doc.data()['editInfo'],
        ageRange: doc.data()['age_range'],
        showGender: doc.data()['showGender'],
        maxDistance: doc.data()['maximum_distance'],
        sexualOrientation: doc.data()['sexualOrientation']['orientation'] ?? "",
        age: ((DateTime.now()
                    .difference(DateTime.parse(doc.data()["user_DOB"]))
                    .inDays) /
                365.2425)
            .truncate(),
        address: doc.data()['location']['address'],
        coordinates: doc.data()['location'],
        // university: doc['editInfo']['university'],
        imageUrl: doc.data()['Pictures'] != null
            ? List.generate(doc.data()['Pictures'].length, (index) {
                return doc.data()['Pictures'][index];
              })
            : []);
  }
}
