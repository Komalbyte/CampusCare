import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaint_repository.dart';

/// Mock implementation of ComplaintRepository
class MockComplaintRepository implements ComplaintRepository {
  final List<ComplaintEntity> _complaints = [];
  final _controller = StreamController<List<ComplaintEntity>>.broadcast();

  MockComplaintRepository() {
    // Initialize with dummy data
    _complaints.addAll([
      ComplaintEntity(
        complaintId: 'c1',
        userId: 'user1',
        category: 'Transport',
        title: 'Bus Late Arrival',
        description: 'Bus number 12 arrived 20 minutes late at the main gate.',
        imageUrls: [],
        location: 'Main Gate',
        priority: 'low',
        status: 'in_progress',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
        mlScore: 0.8,
        mlTags: ['transport', 'delay'],
        viewCount: 15,
        upvotes: 2,
        isSpam: false,
        isDuplicate: false,
        relatedComplaintIds: [],
        resolvedAt: null,
      ),
      ComplaintEntity(
        complaintId: 'c2',
        userId: 'user1',
        category: 'Mess',
        title: 'Food Quality Issue',
        description: 'Lunch served today was cold and tasteless.',
        imageUrls: [],
        location: 'Boy\'s Hostel Mess',
        priority: 'high',
        status: 'assigned',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
        mlScore: 0.95,
        mlTags: ['food', 'quality', 'mess'],
        viewCount: 42,
        upvotes: 12,
        isSpam: false,
        isDuplicate: false,
        relatedComplaintIds: [],
        resolvedAt: null,
      ),
      ComplaintEntity(
        complaintId: 'c3',
        userId: 'user1',
        category: 'Infrastructure',
        title: 'Broken Fan',
        description: 'Ceiling fan in Room 302, Block A is not working.',
        imageUrls: [],
        location: 'Block A, Room 302',
        priority: 'medium',
        status: 'resolved',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        resolvedAt: DateTime.now().subtract(const Duration(days: 1)),
        mlScore: 0.6,
        mlTags: ['fan', 'maintenance'],
        viewCount: 8,
        upvotes: 0,
        isSpam: false,
        isDuplicate: false,
        relatedComplaintIds: [],
        resolutionNotes: 'Fan capacitor replaced.',
      ),
    ]);
    _controller.add(_complaints);
  }

  @override
  Future<ComplaintEntity> submitComplaint({
    required String userId,
    required String category,
    required String title,
    required String description,
    List<String>? imagePaths,
    required String location,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    final newComplaint = ComplaintEntity(
      complaintId: const Uuid().v4(),
      userId: userId,
      category: category,
      subCategory: null,
      title: title,
      description: description,
      imageUrls: imagePaths ?? [],
      location: location,
      priority: 'medium', // Default mock priority
      status: 'submitted',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      mlScore: 0.0,
      mlTags: [],
      viewCount: 0,
      upvotes: 0,
      isSpam: false,
      isDuplicate: false,
      relatedComplaintIds: [],
    );

    _complaints.add(newComplaint);
    _controller.add(_complaints);
    return newComplaint;
  }

  @override
  Future<List<ComplaintEntity>> getComplaintsByUserId({required String userId, int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final userComplaints = _complaints.where((c) => c.userId == userId).toList();
    if (limit != null) {
      return userComplaints.take(limit).toList();
    }
    return userComplaints;
  }

  @override
  Future<ComplaintEntity> getComplaintById({required String complaintId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _complaints.firstWhere((c) => c.complaintId == complaintId);
  }

  @override
  Future<List<ComplaintEntity>> getAllComplaints({
    String? category,
    String? status,
    String? priority,
    int? limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var filtered = _complaints;
    if (category != null) {
      filtered = filtered.where((c) => c.category == category).toList();
    }
    if (status != null) {
      filtered = filtered.where((c) => c.status == status).toList();
    }
    return filtered.take(limit ?? 10).toList();
  }

  @override
  Future<void> updateComplaintStatus({
    required String complaintId,
    required String status,
    String? resolvedBy,
    String? resolutionNotes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _complaints.indexWhere((c) => c.complaintId == complaintId);
    if (index != -1) {
      final old = _complaints[index];
      _complaints[index] = old.copyWith(
        status: status,
        assignedBy: resolvedBy, // Approximating 'resolvedBy' to 'assignedBy' for this method signature match or we might need another field
        resolutionNotes: resolutionNotes,
        updatedAt: DateTime.now(),
        resolvedAt: status == 'resolved' ? DateTime.now() : null,
      );
      _controller.add(_complaints);
    }
  }

  @override
  Future<void> assignComplaint({
    required String complaintId,
    required String departmentId,
    required String adminId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _complaints.indexWhere((c) => c.complaintId == complaintId);
    if (index != -1) {
      _complaints[index] = _complaints[index].copyWith(
        assignedTo: departmentId,
        assignedBy: adminId,
        status: 'assigned',
        updatedAt: DateTime.now(),
      );
      _controller.add(_complaints);
    }
  }

  @override
  Future<List<String>> uploadComplaintImages({
    required String complaintId,
    required List<String> imagePaths,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    // Return mock URLs
    return imagePaths.map((_) => 'https://via.placeholder.com/150').toList();
  }

  @override
  Future<void> deleteComplaint({required String complaintId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _complaints.removeWhere((c) => c.complaintId == complaintId);
    _controller.add(_complaints);
  }

  @override
  Future<void> upvoteComplaint({required String complaintId}) async {
     await Future.delayed(const Duration(milliseconds: 200));
     final index = _complaints.indexWhere((c) => c.complaintId == complaintId);
     if(index != -1) {
       // Simple toggle logic not implemented fully, just incrementing for mock
       _complaints[index] = _complaints[index].copyWith(
         upvotes: _complaints[index].upvotes + 1,
       );
       _controller.add(_complaints);
     }
  }

  @override
  Stream<List<ComplaintEntity>> streamUserComplaints({required String userId}) {
    // In a real app, we would filter the stream. 
    // Here we just return the filtered list from the main broadcast stream
    return _controller.stream.map((list) => 
      list.where((c) => c.userId == userId).toList()
    );
  }

  @override
  Stream<List<ComplaintEntity>> streamAllComplaints() {
    return _controller.stream;
  }
}
