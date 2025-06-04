import 'package:equatable/equatable.dart';

/// Complaint entity representing a complaint in the system
class ComplaintEntity extends Equatable {
  final String complaintId;
  final String userId;
  final String category;
  final String? subCategory;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String location;
  final String priority;
  final String status;
  final String? assignedTo;
  final String? assignedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final DateTime? deadline;
  final double mlScore;
  final List<String> mlTags;
  final int viewCount;
  final int upvotes;
  final bool isSpam;
  final bool isDuplicate;
  final List<String> relatedComplaintIds;
  final String? resolutionNotes;

  const ComplaintEntity({
    required this.complaintId,
    required this.userId,
    required this.category,
    this.subCategory,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.location,
    required this.priority,
    required this.status,
    this.assignedTo,
    this.assignedBy,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.deadline,
    required this.mlScore,
    required this.mlTags,
    required this.viewCount,
    required this.upvotes,
    required this.isSpam,
    required this.isDuplicate,
    required this.relatedComplaintIds,
    this.resolutionNotes,
  });

  @override
  List<Object?> get props => [
        complaintId,
        userId,
        category,
        subCategory,
        title,
        description,
        imageUrls,
        location,
        priority,
        status,
        assignedTo,
        assignedBy,
        createdAt,
        updatedAt,
        resolvedAt,
        deadline,
        mlScore,
        mlTags,
        viewCount,
        upvotes,
        isSpam,
        isDuplicate,
        relatedComplaintIds,
        resolutionNotes,
      ];

  ComplaintEntity copyWith({
    String? complaintId,
    String? userId,
    String? category,
    String? subCategory,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? location,
    String? priority,
    String? status,
    String? assignedTo,
    String? assignedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    DateTime? deadline,
    double? mlScore,
    List<String>? mlTags,
    int? viewCount,
    int? upvotes,
    bool? isSpam,
    bool? isDuplicate,
    List<String>? relatedComplaintIds,
    String? resolutionNotes,
  }) {
    return ComplaintEntity(
      complaintId: complaintId ?? this.complaintId,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy ?? this.assignedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      deadline: deadline ?? this.deadline,
      mlScore: mlScore ?? this.mlScore,
      mlTags: mlTags ?? this.mlTags,
      viewCount: viewCount ?? this.viewCount,
      upvotes: upvotes ?? this.upvotes,
      isSpam: isSpam ?? this.isSpam,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      relatedComplaintIds: relatedComplaintIds ?? this.relatedComplaintIds,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }

  /// Check if complaint is active (not resolved/closed)
  bool get isActive =>
      status != 'resolved' && status != 'closed' && status != 'rejected';

  /// Get priority color
  String get priorityColor {
    switch (priority) {
      case 'urgent':
        return '#DC2626';
      case 'high':
        return '#EF4444';
      case 'medium':
        return '#F59E0B';
      case 'low':
      default:
        return '#10B981';
    }
  }

  /// Get status color
  String get statusColor {
    switch (status) {
      case 'submitted':
        return '#3B82F6';
      case 'assigned':
        return '#8B5CF6';
      case 'in_progress':
        return '#F59E0B';
      case 'resolved':
        return '#10B981';
      case 'closed':
        return '#6B7280';
      case 'rejected':
      default:
        return '#EF4444';
    }
  }
}
