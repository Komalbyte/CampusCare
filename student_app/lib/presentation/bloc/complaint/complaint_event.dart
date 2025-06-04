import 'package:equatable/equatable.dart';

abstract class ComplaintEvent extends Equatable {
  const ComplaintEvent();

  @override
  List<Object?> get props => [];
}

/// Load complaints for a specific user
class LoadUserComplaints extends ComplaintEvent {
  final String userId;

  const LoadUserComplaints(this.userId);

  @override
  List<Object> get props => [userId];
}

/// Load all complaints (for feed/admin)
class LoadAllComplaints extends ComplaintEvent {
  final String? category;
  final String? status;

  const LoadAllComplaints({this.category, this.status});

  @override
  List<Object?> get props => [category, status];
}

/// Submit a new complaint
class SubmitNewComplaint extends ComplaintEvent {
  final String userId;
  final String category;
  final String? subCategory;
  final String title;
  final String description;
  final String location;
  final List<String> imageUrls; // For now, we pass paths or mock URLs directly

  const SubmitNewComplaint({
    required this.userId,
    required this.category,
    this.subCategory,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [userId, category, subCategory, title, description, location, imageUrls];
}

/// Upvote a complaint
class UpvoteComplaint extends ComplaintEvent {
  final String complaintId;
  final String userId;

  const UpvoteComplaint({required this.complaintId, required this.userId});

  @override
  List<Object> get props => [complaintId, userId];
}

/// Refresh complaints list
class RefreshComplaints extends ComplaintEvent {
  final String userId;

  const RefreshComplaints(this.userId);

  @override
  List<Object> get props => [userId];
}
