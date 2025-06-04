import '../entities/complaint_entity.dart';

/// Repository interface for complaint operations
abstract class ComplaintRepository {
  /// Submit a new complaint
  Future<ComplaintEntity> submitComplaint({
    required String userId,
    required String category,
    required String title,
    required String description,
    required String location,
    List<String>? imagePaths,
  });

  /// Get complaints by user ID
  Future<List<ComplaintEntity>> getComplaintsByUserId({
    required String userId,
    int? limit,
  });

  /// Get complaint by ID
  Future<ComplaintEntity> getComplaintById({required String complaintId});

  /// Get all complaints (for admin)
  Future<List<ComplaintEntity>> getAllComplaints({
    int? limit,
    String? status,
    String? category,
    String? priority,
  });

  /// Update complaint status
  Future<void> updateComplaintStatus({
    required String complaintId,
    required String status,
    String? resolutionNotes,
  });

  /// Assign complaint to department
  Future<void> assignComplaint({
    required String complaintId,
    required String departmentId,
    required String adminId,
  });

  /// Upload complaint images
  Future<List<String>> uploadComplaintImages({
    required String complaintId,
    required List<String> imagePaths,
  });

  /// Delete complaint
  Future<void> deleteComplaint({required String complaintId});

  /// Upvote complaint
  Future<void> upvoteComplaint({required String complaintId});

  /// Stream complaints by user
  Stream<List<ComplaintEntity>> streamUserComplaints({
    required String userId,
  });

  /// Stream all complaints (for admin)
  Stream<List<ComplaintEntity>> streamAllComplaints();
}
