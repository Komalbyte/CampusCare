# CampusCare Database Schema

## Overview
This document defines the complete Firestore database structure for the CampusCare system.

---

## Collections

### 1. `users`

Stores user information for students, admins, and department heads.

```javascript
{
  userId: string (auto-generated),           // Unique user ID
  email: string,                              // User email (unique)
  name: string,                               // Full name
  phoneNumber: string,                        // Contact number
  rollNumber: string,                         // Student roll number (null for admins)
  department: string,                         // Department name
  year: number,                               // Year of study (1-4, null for admins)
  hostelBlock: string | null,                 // Hostel block (if applicable)
  roomNumber: string | null,                  // Room number (if applicable)
  role: "student" | "admin" | "department_head",
  profilePicUrl: string | null,               // Firebase Storage URL
  createdAt: timestamp,                       // Account creation date
  lastLogin: timestamp,                       // Last login timestamp
  isActive: boolean,                          // Account status
  fcmToken: string | null                     // For push notifications
}
```

**Indexes:**
- `email` (Ascending)
- `rollNumber` (Ascending)
- `role` (Ascending)

---

### 2. `complaints`

Stores all complaint details submitted by students.

```javascript
{
  complaintId: string (auto-generated),       // Unique complaint ID
  userId: string,                              // Reference to users collection
  category: string,                            // "transport" | "laundry" | "hostel" | "mess" | "academic" | "infrastructure" | "other"
  subCategory: string | null,                  // More specific category
  title: string,                               // Brief title (max 100 chars)
  description: string,                         // Detailed description
  imageUrls: array<string>,                    // Array of Firebase Storage URLs
  location: string,                            // Physical location on campus
  priority: "low" | "medium" | "high" | "urgent", // ML-generated priority
  status: "submitted" | "assigned" | "in_progress" | "resolved" | "closed" | "rejected",
  assignedTo: string | null,                   // departmentId
  assignedBy: string | null,                   // adminId who assigned
  createdAt: timestamp,                        // Submission time
  updatedAt: timestamp,                        // Last update time
  resolvedAt: timestamp | null,                // Resolution time
  deadline: timestamp | null,                  // Expected resolution deadline
  mlScore: number,                             // ML confidence score (0-1)
  mlTags: array<string>,                       // ML-generated tags
  viewCount: number,                           // Number of views
  upvotes: number,                             // Student upvotes (for common issues)
  isSpam: boolean,                             // ML spam detection flag
  isDuplicate: boolean,                        // ML duplicate detection
  relatedComplaintIds: array<string>,          // Similar/duplicate complaints
  resolutionNotes: string | null               // Admin resolution notes
}
```

**Indexes:**
- `userId, createdAt` (Compound, Descending)
- `status, createdAt` (Compound, Descending)
- `category, status` (Compound)
- `priority, status` (Compound)
- `assignedTo, status` (Compound)

---

### 3. `feedback`

Stores student feedback on resolved complaints.

```javascript
{
  feedbackId: string (auto-generated),        // Unique feedback ID
  complaintId: string,                         // Reference to complaints
  userId: string,                              // Reference to users
  rating: number,                              // 1-5 stars
  comment: string,                             // Feedback text (optional)
  createdAt: timestamp,                        // Feedback submission time
  isAnonymous: boolean,                        // Anonymous feedback flag
  tags: array<string>                          // "resolved" | "not_resolved" | "partial"
}
```

**Indexes:**
- `complaintId` (Ascending)
- `rating, createdAt` (Compound, Descending)

---

### 4. `departments`

Stores department information.

```javascript
{
  departmentId: string,                        // Unique department ID (e.g., "DEPT_TRANSPORT")
  name: string,                                // Department name
  headName: string,                            // Department head name
  email: string,                               // Contact email
  phoneNumber: string,                         // Contact number
  categories: array<string>,                   // Categories handled by this dept
  activeComplaints: number,                    // Count of active complaints
  resolvedComplaints: number,                  // Count of resolved complaints
  avgResolutionTime: number,                   // Average time in hours
  createdAt: timestamp,
  isActive: boolean
}
```

**Indexes:**
- `name` (Ascending)

---

### 5. `admin`

Stores admin-specific information.

```javascript
{
  adminId: string (auto-generated),           // Unique admin ID
  userId: string,                              // Reference to users collection
  permissions: array<string>,                  // ["view_all", "assign", "resolve", "delete", etc.]
  departmentId: string | null,                 // Department they manage (if dept head)
  assignedComplaints: array<string>,           // List of complaint IDs
  createdAt: timestamp,
  lastActive: timestamp
}
```

**Indexes:**
- `userId` (Ascending)
- `departmentId` (Ascending)

---

### 6. `notifications`

Stores all notifications for users.

```javascript
{
  notificationId: string (auto-generated),    // Unique notification ID
  userId: string,                              // Recipient user ID
  title: string,                               // Notification title
  body: string,                                // Notification message
  type: "complaint_update" | "assignment" | "deadline" | "general" | "feedback_request",
  relatedComplaintId: string | null,           // Related complaint ID
  isRead: boolean,                             // Read status
  createdAt: timestamp,
  expiresAt: timestamp | null                  // Auto-delete after expiry
}
```

**Indexes:**
- `userId, createdAt` (Compound, Descending)
- `userId, isRead` (Compound)

---

### 7. `analytics`

Stores daily/weekly/monthly analytics data.

```javascript
{
  analyticsId: string,                         // Format: "YYYY-MM-DD" for daily
  date: timestamp,                             // Analytics date
  period: "daily" | "weekly" | "monthly",
  totalComplaints: number,
  resolvedComplaints: number,
  pendingComplaints: number,
  rejectedComplaints: number,
  avgResolutionTime: number,                   // In hours
  categoryBreakdown: {
    transport: number,
    laundry: number,
    hostel: number,
    mess: number,
    academic: number,
    infrastructure: number,
    other: number
  },
  priorityBreakdown: {
    low: number,
    medium: number,
    high: number,
    urgent: number
  },
  satisfactionScore: number,                   // Average rating (1-5)
  topIssues: array<{category: string, count: number}>
}
```

**Indexes:**
- `date` (Descending)
- `period` (Ascending)

---

### 8. `chat_messages`

Stores chat messages between students and admins for specific complaints.

```javascript
{
  messageId: string (auto-generated),         // Unique message ID
  complaintId: string,                         // Reference to complaints
  senderId: string,                            // User ID of sender
  senderRole: "student" | "admin",
  message: string,                             // Message text
  attachmentUrl: string | null,                // Optional attachment URL
  timestamp: timestamp,                        // Message time
  isRead: boolean,                             // Read status
  isSystemMessage: boolean                     // System-generated message (status updates)
}
```

**Indexes:**
- `complaintId, timestamp` (Compound, Ascending)

---

### 9. `app_settings`

Stores global app configuration.

```javascript
{
  settingId: string,                           // Setting key (e.g., "MAINTENANCE_MODE")
  value: any,                                  // Setting value
  updatedAt: timestamp,
  updatedBy: string                            // Admin user ID
}
```

---

## Security Rules Overview

### For Students:
- ✅ Read own user profile
- ✅ Create/Read/Update own complaints
- ✅ Read own feedback
- ✅ Read own notifications
- ✅ Read/Create chat messages for own complaints

### For Admins:
- ✅ Read all complaints
- ✅ Update complaint status/assignment
- ✅ Read all users (limited fields)
- ✅ Create notifications
- ✅ Read/Create chat messages for assigned complaints

### For Department Heads:
- ✅ Read complaints assigned to their department
- ✅ Update status for assigned complaints
- ✅ View department analytics

---

## Firestore Composite Indexes Required

```javascript
// complaints collection
1. userId (ASC) + createdAt (DESC)
2. status (ASC) + createdAt (DESC)
3. category (ASC) + status (ASC)
4. priority (ASC) + status (ASC)
5. assignedTo (ASC) + status (ASC)

// notifications collection
6. userId (ASC) + createdAt (DESC)
7. userId (ASC) + isRead (ASC)

// chat_messages collection
8. complaintId (ASC) + timestamp (ASC)

// feedback collection
9. complaintId (ASC) + createdAt (DESC)
```

These indexes will be automatically created when we deploy Firestore security rules or can be created through Firebase Console.

---

## Data Flow Examples

### 1. Submit Complaint Flow
```
Student submits complaint
  ↓
Create document in `complaints` collection
  ↓
Upload images to Firebase Storage
  ↓
Run ML model to determine priority
  ↓
Update complaint with ML score and priority
  ↓
Create notification for relevant admins
```

### 2. Admin Assignment Flow
```
Admin views complaint
  ↓
Assigns to department
  ↓
Update complaint.assignedTo field
  ↓
Update department.activeComplaints counter
  ↓
Create notification for student
  ↓
Create system message in chat
```

### 3. Resolution Flow
```
Admin marks as resolved
  ↓
Update complaint.status = "resolved"
  ↓
Update complaint.resolvedAt = now
  ↓
Update department.resolvedComplaints counter
  ↓
Create notification asking for feedback
  ↓
Student submits feedback (rating + comment)
```

---

This schema is optimized for:
- ✅ Fast queries
- ✅ Scalability
- ✅ Security
- ✅ Analytics
- ✅ ML integration
