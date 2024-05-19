class UserDetailsModel {
  final int id;
  final String name;
  final String phone;
  final String? bloodGroup;
  final String? photoUrl;

  UserDetailsModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.bloodGroup,
    required this.photoUrl,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"].toString(),
        bloodGroup: json["bloodGroup"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "bloodGroup": bloodGroup,
        "photoUrl": photoUrl,
      };
}
