// Mock complaints data for demo
export const mockComplaints = [
    {
        id: 'c1',
        userId: 'user1',
        userName: 'Rahul Sharma',
        userEmail: 'rahul.sharma@sharda.ac.in',
        category: 'Transport',
        title: 'Bus Late Arrival',
        description: 'Bus number 12 arrived 20 minutes late at the main gate. This is happening regularly and causing students to miss morning classes.',
        location: 'Main Gate',
        priority: 'medium',
        status: 'in_progress',
        createdAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
        updatedAt: new Date(Date.now() - 1 * 60 * 60 * 1000).toISOString(),
        upvotes: 15
    },
    {
        id: 'c2',
        userId: 'user2',
        userName: 'Priya Patel',
        userEmail: 'priya.patel@sharda.ac.in',
        category: 'Mess',
        title: 'Food Quality Issue',
        description: 'Lunch served today was cold and tasteless. The dal had insects in it. Please take immediate action.',
        location: "Boy's Hostel Mess",
        priority: 'high',
        status: 'submitted',
        createdAt: new Date(Date.now() - 5 * 60 * 60 * 1000).toISOString(),
        updatedAt: new Date(Date.now() - 5 * 60 * 60 * 1000).toISOString(),
        upvotes: 42
    },
    {
        id: 'c3',
        userId: 'user1',
        userName: 'Rahul Sharma',
        userEmail: 'rahul.sharma@sharda.ac.in',
        category: 'Infrastructure',
        title: 'Broken Fan in Room 302',
        description: 'Ceiling fan in Room 302, Block A is not working for the past 3 days. It is very hot and uncomfortable.',
        location: 'Block A, Room 302',
        priority: 'medium',
        status: 'resolved',
        createdAt: new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString(),
        updatedAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
        resolvedAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
        resolutionNotes: 'Fan capacitor replaced. Fan is now working properly.',
        upvotes: 8
    },
    {
        id: 'c4',
        userId: 'user3',
        userName: 'Amit Kumar',
        userEmail: 'amit.kumar@sharda.ac.in',
        category: 'Hostel',
        title: 'Water Supply Issue',
        description: 'No water supply in Block C since morning. Students are unable to attend classes due to this.',
        location: 'Block C, All Floors',
        priority: 'high',
        status: 'assigned',
        createdAt: new Date(Date.now() - 8 * 60 * 60 * 1000).toISOString(),
        updatedAt: new Date(Date.now() - 4 * 60 * 60 * 1000).toISOString(),
        assignedTo: 'Maintenance Department',
        upvotes: 67
    },
    {
        id: 'c5',
        userId: 'user4',
        userName: 'Sneha Gupta',
        userEmail: 'sneha.gupta@sharda.ac.in',
        category: 'Laundry',
        title: 'Washing Machine Not Working',
        description: 'Washing machine #3 in the laundry room is making loud noises and not completing the wash cycle.',
        location: 'Hostel Laundry Room',
        priority: 'low',
        status: 'submitted',
        createdAt: new Date(Date.now() - 12 * 60 * 60 * 1000).toISOString(),
        updatedAt: new Date(Date.now() - 12 * 60 * 60 * 1000).toISOString(),
        upvotes: 5
    },
    {
        id: 'c6',
        userId: 'user5',
        userName: 'Vikash Singh',
        userEmail: 'vikash.singh@sharda.ac.in',
        category: 'Academic',
        title: 'Projector Issue in Lecture Hall 5',
        description: 'The projector in Lecture Hall 5 is showing distorted colors. Faculty are unable to show presentations properly.',
        location: 'Lecture Hall 5, Block E',
        priority: 'medium',
        status: 'in_progress',
        createdAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
        updatedAt: new Date(Date.now() - 6 * 60 * 60 * 1000).toISOString(),
        upvotes: 23
    },
    {
        id: 'c7',
        userId: 'user6',
        userName: 'Anita Verma',
        userEmail: 'anita.verma@sharda.ac.in',
        category: 'Infrastructure',
        title: 'Street Light Not Working',
        description: 'The street light near the basketball court has been off for a week. It is unsafe to walk there at night.',
        location: 'Basketball Court Area',
        priority: 'medium',
        status: 'resolved',
        createdAt: new Date(Date.now() - 72 * 60 * 60 * 1000).toISOString(),
        updatedAt: new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString(),
        resolvedAt: new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString(),
        resolutionNotes: 'Bulb replaced with new LED light.',
        upvotes: 12
    }
]

// Categories
export const categories = [
    'Transport',
    'Mess',
    'Hostel',
    'Laundry',
    'Infrastructure',
    'Academic',
    'Other'
]

// Statuses
export const statuses = [
    { value: 'submitted', label: 'Submitted', color: '#3b82f6' },
    { value: 'in_progress', label: 'In Progress', color: '#f59e0b' },
    { value: 'assigned', label: 'Assigned', color: '#6366f1' },
    { value: 'resolved', label: 'Resolved', color: '#10b981' },
    { value: 'rejected', label: 'Rejected', color: '#ef4444' }
]

// Priorities
export const priorities = [
    { value: 'low', label: 'Low', color: '#10b981' },
    { value: 'medium', label: 'Medium', color: '#f59e0b' },
    { value: 'high', label: 'High', color: '#ef4444' }
]
