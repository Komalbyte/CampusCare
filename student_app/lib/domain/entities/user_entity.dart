import 'package:equatable/equatable.dart';

/// User entity representing a student/admin in the system
class UserEntity extends Equatable {
  final String userId;
  final String email;
  final String name;
  final String phoneNumber;
  final String? rollNumber;
  final String department;
  final int? year;
  final String? hostelBlock;
  final String? roomNumber;
  final String role;
  final String? profilePicUrl;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;
  final String? fcmToken;

  const UserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.rollNumber,
    required this.department,
    this.year,
    this.hostelBlock,
    this.roomNumber,
    required this.role,
    this.profilePicUrl,
    required this.createdAt,
    required this.lastLogin,
    required this.isActive,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [
        userId,
        email,
        name,
        phoneNumber,
        rollNumber,
        department,
        year,
        hostelBlock,
        roomNumber,
        role,
        profilePicUrl,
        createdAt,
        lastLogin,
        isActive,
        fcmToken,
      ];

  UserEntity copyWith({
    String? userId,
    String? email,
    String? name,
    String? phoneNumber,
    String? rollNumber,
    String? department,
    int? year,
    String? hostelBlock,
    String? roomNumber,
    String? role,
    String? profilePicUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
    String? fcmToken,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rollNumber: rollNumber ?? this.rollNumber,
      department: department ?? this.department,
      year: year ?? this.year,
      hostelBlock: hostelBlock ?? this.hostelBlock,
      roomNumber: roomNumber ?? this.roomNumber,
      role: role ?? this.role,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
