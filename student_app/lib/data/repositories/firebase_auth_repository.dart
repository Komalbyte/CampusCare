import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Firebase implementation of AuthRepository
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      
      if (userDoc.exists) {
        return _userEntityFromDoc(userDoc);
      } else {
        // Create basic user profile if not exists
        final newUser = UserEntity(
          userId: userCredential.user!.uid,
          email: email,
          name: email.split('@')[0],
          phoneNumber: '',
          rollNumber: '',
          department: 'Not Set',
          year: 1,
          role: 'student',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          isActive: true,
        );
        
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(_userEntityToMap(newUser));
        
        return newUser;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
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
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final newUser = UserEntity(
        userId: userCredential.user!.uid,
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
      
      // Save user to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(_userEntityToMap(newUser));
      
      return newUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Sign up failed');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;
    
    final userDoc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    
    if (userDoc.exists) {
      return _userEntityFromDoc(userDoc);
    }
    
    // Return basic user if no Firestore doc
    return UserEntity(
      userId: currentUser.uid,
      email: currentUser.email ?? '',
      name: currentUser.displayName ?? currentUser.email?.split('@')[0] ?? 'User',
      phoneNumber: currentUser.phoneNumber ?? '',
      rollNumber: '',
      department: 'Not Set',
      year: 1,
      role: 'student',
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      isActive: true,
    );
  }

  @override
  Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
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
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
    if (profilePicUrl != null) updates['profilePicUrl'] = profilePicUrl;
    if (hostelBlock != null) updates['hostelBlock'] = hostelBlock;
    if (roomNumber != null) updates['roomNumber'] = roomNumber;
    
    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update(updates);
    }
  }

  @override
  Future<void> deleteAccount({required String userId}) async {
    await _firestore.collection('users').doc(userId).delete();
    await _auth.currentUser?.delete();
  }

  UserEntity _userEntityFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserEntity(
      userId: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      rollNumber: data['rollNumber'],
      department: data['department'] ?? 'Not Set',
      year: data['year'] ?? 1,
      hostelBlock: data['hostelBlock'],
      roomNumber: data['roomNumber'],
      profilePicUrl: data['profilePicUrl'],
      role: data['role'] ?? 'student',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> _userEntityToMap(UserEntity user) {
    return {
      'email': user.email,
      'name': user.name,
      'phoneNumber': user.phoneNumber,
      'rollNumber': user.rollNumber,
      'department': user.department,
      'year': user.year,
      'hostelBlock': user.hostelBlock,
      'roomNumber': user.roomNumber,
      'profilePicUrl': user.profilePicUrl,
      'role': user.role,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
      'isActive': user.isActive,
    };
  }
}
