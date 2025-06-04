import '../entities/user_entity.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign in with email and password
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
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
  });

  /// Sign out
  Future<void> signOut();

  /// Get current user
  Future<UserEntity?> getCurrentUser();

  /// Check if user is signed in
  Future<bool> isSignedIn();

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email});

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profilePicUrl,
    String? hostelBlock,
    String? roomNumber,
  });

  /// Delete user account
  Future<void> deleteAccount({required String userId});
}
