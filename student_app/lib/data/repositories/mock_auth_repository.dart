import 'dart:async';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock implementation of AuthRepository for testing without Firebase
class MockAuthRepository implements AuthRepository {
  UserEntity? _currentUser;

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (password == 'wrong') {
      throw Exception('Invalid password');
    }

    _currentUser = UserEntity(
      userId: 'mock_user_123',
      email: email,
      name: 'Test Student',
      phoneNumber: '9876543210',
      rollNumber: '2023CS001',
      department: 'Computer Science',
      year: 3,
      role: 'student',
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      isActive: true,
    );
    return _currentUser!;
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String rollNumber,
    required String department,
    required int year,
    String? hostelBlock,
    String? roomNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    _currentUser = UserEntity(
      userId: 'mock_user_new',
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      rollNumber: rollNumber,
      department: department,
      year: year,
      hostelBlock: hostelBlock,
      roomNumber: roomNumber,
      role: 'student',
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      isActive: true,
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Future<bool> isSignedIn() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser != null;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profilePicUrl,
    String? hostelBlock,
    String? roomNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> deleteAccount({required String userId}) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
  }
}
