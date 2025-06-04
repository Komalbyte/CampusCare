/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'CampusCare';
  static const String appVersion = '1.0.0';
  static const String organizationName = 'Sharda University';
  static const String organizationLocation = 'Greater Noida';
  
  // API/Backend
  static const String mlApiBaseUrl = 'YOUR_ML_API_URL'; // To be configured
  
  // Shared Preferences Keys
  static const String prefKeyIsLoggedIn = 'is_logged_in';
  static const String prefKeyUserId = 'user_id';
  static const String prefKeyUserEmail = 'user_email';
  static const String prefKeyUserName = 'user_name';
  static const String prefKeyUserRole = 'user_role';
  static const String prefKeyFcmToken = 'fcm_token';
  static const String prefKeyThemeMode = 'theme_mode';
  
  // Pagination
  static const int complaintsPerPage = 20;
  static const int notificationsPerPage = 30;
  static const int messagesPerPage = 50;
  
  // File Upload Limits
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxImagesPerComplaint = 5;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Timeouts
  static const int apiTimeoutSeconds = 30;
  static const int uploadTimeoutSeconds = 60;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;
  
  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;
  
  // Error Messages
  static const String errorNoInternet = 'No internet connection. Please check your network.';
  static const String errorSomethingWentWrong = 'Something went wrong. Please try again.';
  static const String errorInvalidCredentials = 'Invalid email or password.';
  static const String errorEmailAlreadyExists = 'Email already registered.';
  static const String errorWeakPassword = 'Password is too weak. Use at least 8 characters.';
  
  // Success Messages
  static const String successComplaintSubmitted = 'Complaint submitted successfully!';
  static const String successProfileUpdated = 'Profile updated successfully!';
  static const String successFeedbackSubmitted = 'Thank you for your feedback!';
  
  // Complaint Categories with Display Names
  static const Map<String, String> categoryDisplayNames = {
    'transport': 'Transport',
    'laundry': 'Laundry',
    'hostel': 'Hostel',
    'mess': 'Mess & Cafeteria',
    'academic': 'Academic',
    'infrastructure': 'Infrastructure',
    'other': 'Other',
  };
  
  // Priority Display Names
  static const Map<String, String> priorityDisplayNames = {
    'low': 'Low',
    'medium': 'Medium',
    'high': 'High',
    'urgent': 'Urgent',
  };
  
  // Status Display Names
  static const Map<String, String> statusDisplayNames = {
    'submitted': 'Submitted',
    'assigned': 'Assigned',
    'in_progress': 'In Progress',
    'resolved': 'Resolved',
    'closed': 'Closed',
    'rejected': 'Rejected',
  };
  
  // Contact Information
  static const String supportEmail = 'support@campuscare.sharda.ac.in';
  static const String supportPhone = '+91-120-1234567';
  
  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[6-9]\d{9}$';
  static const String rollNumberPattern = r'^[A-Z0-9]{8,12}$';
}
