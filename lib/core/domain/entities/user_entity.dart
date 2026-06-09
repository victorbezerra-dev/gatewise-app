import '../value_objects/user_type_vo.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String registrationNumber;
  final String userAvatarUrl;
  final int userType;
  final String operationalSystem;
  final String operationalSystemVersion;
  final String deviceModel;
  final String deviceManufactureName;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.registrationNumber,
    required this.userAvatarUrl,
    required this.userType,
    required this.operationalSystem,
    required this.operationalSystemVersion,
    required this.deviceModel,
    required this.deviceManufactureName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    registrationNumber: json['registrationNumber']?.toString() ?? '',
    userAvatarUrl: json['userAvatarUrl']?.toString() ?? '',
    userType: _parseUserType(json['userType']),
    operationalSystem: json['operationalSystem']?.toString() ?? '',
    operationalSystemVersion:
        json['operationalSystemVersion']?.toString() ?? '',
    deviceModel: json['deviceModel']?.toString() ?? '',
    deviceManufactureName: json['deviceManufactureName']?.toString() ?? '',
  );

  static int _parseUserType(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final numericValue = int.tryParse(value);
      if (numericValue != null) return numericValue;

      try {
        return UserType.fromString(value).index;
      } catch (_) {
        return UserType.visitor.index;
      }
    }

    return UserType.visitor.index;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'registrationNumber': registrationNumber,
    'userAvatarUrl': userAvatarUrl,
    'userType': userType,
    'operationalSystem': operationalSystem,
    'operationalSystemVersion': operationalSystemVersion,
    'deviceModel': deviceModel,
    'deviceManufactureName': deviceManufactureName,
  };
}
