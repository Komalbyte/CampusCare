import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaint_repository.dart';

/// Firebase implementation of ComplaintRepository
class FirebaseComplaintRepository implements ComplaintRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<ComplaintEntity> submitComplaint({
    required String userId,
    required String category,
    required String title,
    required String description,
    required String location,
    List<String>? imagePaths,
  }) async {
    // Upload images first if any
    List<String> imageUrls = [];
    if (imagePaths != null && imagePaths.isNotEmpty) {
      imageUrls = await uploadComplaintImages(
        complaintId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        imagePaths: imagePaths,
      );
    }

    // Get user info
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data() ?? {};

    final docRef = await _firestore.collection('complaints').add({
      'userId': userId,
      'userName': userData['name'] ?? 'Student',
      'userEmail': userData['email'] ?? '',
      'category': category,
      'title': title,
      'description': description,
      'location': location,
      'imageUrls': imageUrls,
      'priority': 'medium',
      'status': 'submitted',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'upvotes': 0,
      'viewCount': 0,
      'isSpam': false,
      'isDuplicate': false,
    });

    return ComplaintEntity(
      complaintId: docRef.id,
      userId: userId,
      category: category,
      title: title,
      description: description,
      location: location,
      imageUrls: imageUrls,
      priority: 'medium',
      status: 'submitted',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      upvotes: 0,
      viewCount: 0,
      isSpam: false,
      isDuplicate: false,
      relatedComplaintIds: [],
      mlScore: 0.0,
      mlTags: [],
    );
  }

  @override
  Future<List<ComplaintEntity>> getComplaintsByUserId({
    required String userId,
    int? limit,
  }) async {
    Query query = _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => _complaintFromDoc(doc)).toList();
  }

  @override
  Future<ComplaintEntity> getComplaintById({required String complaintId}) async {
    final doc = await _firestore.collection('complaints').doc(complaintId).get();
    return _complaintFromDoc(doc);
  }

  @override
  Future<List<ComplaintEntity>> getAllComplaints({
    int? limit,
    String? status,
    String? category,
    String? priority,
  }) async {
    Query query = _firestore.collection('complaints').orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => _complaintFromDoc(doc)).toList();
  }

  @override
  Future<void> updateComplaintStatus({
    required String complaintId,
    required String status,
    String? resolutionNotes,
  }) async {
    final updates = <String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (resolutionNotes != null) {
      updates['resolutionNotes'] = resolutionNotes;
    }

    if (status == 'resolved') {
      updates['resolvedAt'] = FieldValue.serverTimestamp();
    }

    await _firestore.collection('complaints').doc(complaintId).update(updates);
  }

  @override
  Future<void> assignComplaint({
    required String complaintId,
    required String departmentId,
    required String adminId,
  }) async {
    await _firestore.collection('complaints').doc(complaintId).update({
      'assignedTo': departmentId,
      'assignedBy': adminId,
      'status': 'assigned',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<String>> uploadComplaintImages({
    required String complaintId,
    required List<String> imagePaths,
  }) async {
    List<String> urls = [];
    
    for (int i = 0; i < imagePaths.length; i++) {
      final file = File(imagePaths[i]);
      final ref = _storage.ref().child('complaints/$complaintId/image_$i.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    
    return urls;
  }

  @override
  Future<void> deleteComplaint({required String complaintId}) async {
    await _firestore.collection('complaints').doc(complaintId).delete();
  }

  @override
  Future<void> upvoteComplaint({required String complaintId}) async {
    await _firestore.collection('complaints').doc(complaintId).update({
      'upvotes': FieldValue.increment(1),
    });
  }

  @override
  Stream<List<ComplaintEntity>> streamUserComplaints({required String userId}) {
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => _complaintFromDoc(doc)).toList());
  }

  @override
  Stream<List<ComplaintEntity>> streamAllComplaints() {
    return _firestore
        .collection('complaints')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => _complaintFromDoc(doc)).toList());
  }

  ComplaintEntity _complaintFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ComplaintEntity(
      complaintId: doc.id,
      userId: data['userId'] ?? '',
      category: data['category'] ?? '',
      subCategory: data['subCategory'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      location: data['location'] ?? '',
      priority: data['priority'] ?? 'medium',
      status: data['status'] ?? 'submitted',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
      assignedTo: data['assignedTo'],
      assignedBy: data['assignedBy'],
      resolutionNotes: data['resolutionNotes'],
      mlScore: (data['mlScore'] ?? 0).toDouble(),
      mlTags: List<String>.from(data['mlTags'] ?? []),
      viewCount: data['viewCount'] ?? 0,
      upvotes: data['upvotes'] ?? 0,
      isSpam: data['isSpam'] ?? false,
      isDuplicate: data['isDuplicate'] ?? false,
      relatedComplaintIds: List<String>.from(data['relatedComplaintIds'] ?? []),
    );
  }
}
