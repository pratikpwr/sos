import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  final int userId;
  final String? fullName;
  final int? gender;
  final DateTime? dob;
  final int mobileNo;
  final String? emailId;
  final String? urlProfile;
  final int? bloodGroupId;
  final int? qualificationId;
  final int? occupationId;
  final int? createdBy;
  final DateTime? createdOn;
  final dynamic modifiedBy;
  final dynamic modifiedOn;
  final dynamic authStatus;
  final dynamic authBy;
  final dynamic authOn;
  final dynamic bloodGroup;
  final dynamic qualification;
  final dynamic occupation;
  final String? fcmToken;
  final List<dynamic> userAddresses;

  UserProfileModel({
    required this.userId,
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.mobileNo,
    required this.emailId,
    required this.urlProfile,
    required this.bloodGroupId,
    required this.qualificationId,
    required this.occupationId,
    required this.createdBy,
    required this.createdOn,
    required this.modifiedBy,
    required this.modifiedOn,
    required this.authStatus,
    required this.authBy,
    required this.authOn,
    required this.bloodGroup,
    required this.qualification,
    required this.occupation,
    required this.fcmToken,
    required this.userAddresses,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        userId: json["userId"],
        fullName: json["fullName"],
        gender: json["gender"],
        dob: DateTime.parse(json["dob"]),
        mobileNo: json["mobileNo"],
        emailId: json["emailId"],
        urlProfile: json["urlProfile"],
        bloodGroupId: json["bloodGroupId"],
        qualificationId: json["qualificationId"],
        occupationId: json["occupationId"],
        createdBy: json["createdBy"],
        createdOn: DateTime.parse(json["createdOn"]),
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        authStatus: json["authStatus"],
        authBy: json["authBy"],
        authOn: json["authOn"],
        bloodGroup: json["bloodGroup"],
        qualification: json["qualification"],
        occupation: json["occupation"],
        fcmToken: json["fcmToken"],
        userAddresses: List<dynamic>.from(json["userAddresses"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "fullName": fullName,
        "gender": gender,
        "dob": dob?.toIso8601String(),
        "mobileNo": mobileNo,
        "emailId": emailId,
        "urlProfile": urlProfile,
        "bloodGroupId": bloodGroupId,
        "qualificationId": qualificationId,
        "occupationId": occupationId,
        "createdBy": createdBy,
        "createdOn": createdOn?.toIso8601String(),
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "authStatus": authStatus,
        "authBy": authBy,
        "authOn": authOn,
        "bloodGroup": bloodGroup,
        "qualification": qualification,
        "occupation": occupation,
        "fcmToken": fcmToken,
        "userAddresses": List<dynamic>.from(userAddresses.map((x) => x)),
      };
}
