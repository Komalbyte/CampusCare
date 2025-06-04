/// Firebase collection and storage constants
class FirebaseConstants {
  FirebaseConstants._();

  // Package Name
  static const String androidPackageName = 'com.sharda.campuscare';
  
  // Collections
  static const String usersCollection = 'users';
  static const String complaintsCollection = 'complaints';
  static const String feedbackCollection = 'feedback';
  static const String departmentsCollection = 'departments';
  static const String adminCollection = 'admin';
  static const String notificationsCollection = 'notifications';
  static const String analyticsCollection = 'analytics';
  static const String chatMessagesCollection = 'chat_messages';
  static const String appSettingsCollection = 'app_settings';
  
  // Storage Paths
  static const String complaintsImagesPath = 'complaints';
  static const String profilePicturesPath = 'profiles';
  static const String reportsPath = 'reports';
  
  // User Roles
  static const String roleStudent = 'student';
  static const String roleAdmin = 'admin';
  static const String roleDepartmentHead = 'department_head';
  
  // Complaint Categories
  static const String categoryTransport = 'transport';
  static const String categoryLaundry = 'laundry';
  static const String categoryHostel = 'hostel';
  static const String categoryMess = 'mess';
  static const String categoryAcademic = 'academic';
  static const String categoryInfrastructure = 'infrastructure';
  static const String categoryOther = 'other';
  
  // Complaint Priority
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';
  static const String priorityUrgent = 'urgent';
  
  // Complaint Status
  static const String statusSubmitted = 'submitted';
  static const String statusAssigned = 'assigned';
  static const String statusInProgress = 'in_progress';
  static const String statusResolved = 'resolved';
  static const String statusClosed = 'closed';
  static const String statusRejected = 'rejected';
  
  // Notification Types
  static const String notificationComplaintUpdate = 'complaint_update';
  static const String notificationAssignment = 'assignment';
  static const String notificationDeadline = 'deadline';
  static const String notificationGeneral = 'general';
  static const String notificationFeedbackRequest = 'feedback_request';
}
