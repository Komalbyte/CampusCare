import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintModel extends ComplaintEntity {
  const ComplaintModel({
    required super.complaintId,
    required super.userId,
    required super.category,
    super.subCategory,
    required super.title,
    required super.description,
    required super.imageUrls,
    required super.location,
    required super.priority,
    required super.status,
    super.assignedTo,
    super.assignedBy,
    required super.createdAt,
    required super.updatedAt,
    super.resolvedAt,
    super.deadline,
    required super.mlScore,
    required super.mlTags,
    required super.viewCount,
    required super.upvotes,
    required super.isSpam,
    required super.isDuplicate,
    required super.relatedComplaintIds,
    super.resolutionNotes,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      complaintId: json['complaintId'] ?? '',
      userId: json['userId'] ?? '',
      category: json['category'] ?? 'Other',
      subCategory: json['subCategory'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      location: json['location'] ?? '',
      priority: json['priority'] ?? 'low',
      status: json['status'] ?? 'submitted',
      assignedTo: json['assignedTo'],
      assignedBy: json['assignedBy'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      resolvedAt: json['resolvedAt'] != null
          ? (json['resolvedAt'] as Timestamp).toDate()
          : null,
      deadline: json['deadline'] != null
          ? (json['deadline'] as Timestamp).toDate()
          : null,
      mlScore: (json['mlScore'] ?? 0.0).toDouble(),
      mlTags: List<String>.from(json['mlTags'] ?? []),
      viewCount: json['viewCount'] ?? 0,
      upvotes: json['upvotes'] ?? 0,
      isSpam: json['isSpam'] ?? false,
      isDuplicate: json['isDuplicate'] ?? false,
      relatedComplaintIds:
          List<String>.from(json['relatedComplaintIds'] ?? []),
      resolutionNotes: json['resolutionNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaintId': complaintId,
      'userId': userId,
      'category': category,
      'subCategory': subCategory,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'location': location,
      'priority': priority,
      'status': status,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'mlScore': mlScore,
      'mlTags': mlTags,
      'viewCount': viewCount,
      'upvotes': upvotes,
      'isSpam': isSpam,
      'isDuplicate': isDuplicate,
      'relatedComplaintIds': relatedComplaintIds,
      'resolutionNotes': resolutionNotes,
    };
  }

  factory ComplaintModel.fromEntity(ComplaintEntity entity) {
    return ComplaintModel(
      complaintId: entity.complaintId,
      userId: entity.userId,
      category: entity.category,
      subCategory: entity.subCategory,
      title: entity.title,
      description: entity.description,
      imageUrls: entity.imageUrls,
      location: entity.location,
      priority: entity.priority,
      status: entity.status,
      assignedTo: entity.assignedTo,
      assignedBy: entity.assignedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      resolvedAt: entity.resolvedAt,
      deadline: entity.deadline,
      mlScore: entity.mlScore,
      mlTags: entity.mlTags,
      viewCount: entity.viewCount,
      upvotes: entity.upvotes,
      isSpam: entity.isSpam,
      isDuplicate: entity.isDuplicate,
      relatedComplaintIds: entity.relatedComplaintIds,
      resolutionNotes: entity.resolutionNotes,
    );
  }
}
