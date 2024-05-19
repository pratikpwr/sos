import 'dart:convert';

import 'user_details_model.dart';

SosDetailsModel sosDetailsFromJson(String str) =>
    SosDetailsModel.fromJson(json.decode(str));

String sosDetailsToJson(SosDetailsModel data) => json.encode(data.toJson());

class SosDetailsModel {
  final int sosId;
  final bool isActive;
  final DateTime createdOn;
  final List<String> mediaFileUrls;
  final int userId;
  final double? lat;
  final double? long;
  final UserDetailsModel userDetails;
  final List<UserDetailsModel> acceptorUsers;

  SosDetailsModel({
    required this.sosId,
    required this.isActive,
    required this.createdOn,
    required this.mediaFileUrls,
    required this.userId,
    required this.lat,
    required this.long,
    required this.userDetails,
    required this.acceptorUsers,
  });

  factory SosDetailsModel.fromJson(Map<String, dynamic> json) =>
      SosDetailsModel(
        sosId: json["sosId"],
        isActive: json["isActive"],
        createdOn: DateTime.parse(json["createdOn"]),
        mediaFileUrls: List<String>.from(json["mediaFileUrls"].map((x) => x)),
        userId: json["userId"],
        lat: json["lat"],
        long: json["long"],
        userDetails: UserDetailsModel.fromJson(json["userDetails"]),
        acceptorUsers: List<UserDetailsModel>.from(
            json["acceptorUsers"].map((x) => UserDetailsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sosId": sosId,
        "isActive": isActive,
        "createdOn": createdOn.toIso8601String(),
        "mediaFileUrls": List<dynamic>.from(mediaFileUrls.map((x) => x)),
        "userId": userId,
        "lat": lat,
        "long": long,
        "userDetails": userDetails.toJson(),
        "acceptorUsers":
            List<dynamic>.from(acceptorUsers.map((x) => x.toJson())),
      };
}
