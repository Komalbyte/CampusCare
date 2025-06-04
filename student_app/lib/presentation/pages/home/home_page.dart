import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../complaint/submit_complaint_page.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/complaint/complaint_bloc.dart';
import '../../bloc/complaint/complaint_event.dart';
import '../../bloc/complaint/complaint_state.dart';
import '../../../domain/entities/complaint_entity.dart';
import '../../widgets/complaint/complaint_card.dart';
import '../auth/login_page.dart';

/// Home page with dashboard and navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardTab(),
    const ComplaintsTab(),
    const NotificationsTab(),
    const ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    // Load complaints when home page opens
    // We assume user is 'user1' for the mock. In real app, get from AuthState
    context.read<ComplaintBloc>().add(const LoadUserComplaints('user1'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        } else if (state is AuthAuthenticated) {
           // Reload with actual user ID if needed
           context.read<ComplaintBloc>().add(LoadUserComplaints(state.user.userId));
        }
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: _buildBottomNavigationBar(),
        floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubmitComplaintPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('New Complaint'),
              )
            : null,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          activeIcon: Icon(Icons.list_alt),
          label: 'Complaints',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// Dashboard Tab
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplaintBloc, ComplaintState>(
      builder: (context, state) {
        int activeCount = 0;
        int resolvedCount = 0;
        int totalCount = 0;
        List<dynamic> recentComplaints = []; // Use ComplaintEntity

        if (state is ComplaintLoaded) {
          final complaints = state.complaints;
          totalCount = complaints.length;
          activeCount = complaints.where((c) => c.isActive).length;
          resolvedCount = complaints.where((c) => c.status == 'resolved').length;
          
          // Sort by date desc and take top 3
          final sorted = List.of(complaints)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          recentComplaints = sorted.take(3).toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                   // Refresh data
                   // User ID is mock 'user1' for demo
                   context.read<ComplaintBloc>().add(const LoadUserComplaints('user1'));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                _buildQuickStats(activeCount, resolvedCount, totalCount),
                const SizedBox(height: 24),
                _buildCategoryGrid(context),
                const SizedBox(height: 24),
                _buildRecentComplaintsList(recentComplaints.cast<ComplaintEntity>().toList()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'How can we help you today?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(int active, int resolved, int total) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active',
            active.toString(),
            Icons.pending_outlined,
            AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Resolved',
            resolved.toString(),
            Icons.check_circle_outline,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total',
            total.toString(),
            Icons.list_alt,
            AppColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {'name': 'Transport', 'icon': Icons.directions_bus, 'color': AppColors.primary},
      {'name': 'Hostel', 'icon': Icons.bed, 'color': AppColors.accent},
      {'name': 'Mess', 'icon': Icons.restaurant, 'color': AppColors.warning},
      {'name': 'Laundry', 'icon': Icons.local_laundry_service, 'color': AppColors.info},
      {'name': 'Infrastructure', 'icon': Icons.construction, 'color': AppColors.error},
      {'name': 'Academic', 'icon': Icons.school, 'color': AppColors.success},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // TODO: Navigate to category filter
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubmitComplaintPage(),
                    ),
                  );
              },
              child: _buildCategoryCard(
                category['name'] as String,
                category['icon'] as IconData,
                category['color'] as Color,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String name, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentComplaintsList(List<ComplaintEntity> complaints) {
    if (complaints.isEmpty) {
      return const SizedBox.shrink();
    }
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Complaints',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // Switch to Complaints Tab (index 1) via callback or State management
                // Simplified: not handled here directly, user can tap tab
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...complaints.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ComplaintCard(
            complaint: c,
            onTap: () {
              // TODO: Navigate to details
            },
          ),
        )),
      ],
    );
  }
}


// ... imports at top

/// Complaints Tab
class ComplaintsTab extends StatelessWidget {
  const ComplaintsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
      ),
      body: BlocBuilder<ComplaintBloc, ComplaintState>(
        builder: (context, state) {
          if (state is ComplaintLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ComplaintError) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                   const SizedBox(height: 16),
                   Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
                   const SizedBox(height: 16),
                   ElevatedButton(
                     onPressed: () {
                       context.read<ComplaintBloc>().add(const LoadUserComplaints('user1'));
                     },
                     child: const Text('Retry'),
                   ),
                 ],
               ),
             );
          }

          if (state is ComplaintLoaded) {
            if (state.complaints.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment_outlined, size: 64, color: AppColors.textTertiary),
                    const SizedBox(height: 16),
                    const Text(
                      'No complaints found',
                      style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubmitComplaintPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('File a Complaint'),
                    ),
                  ],
                ),
              );
            }

            // Sort by date desc
            final sortedComplaints = List<ComplaintEntity>.from(state.complaints)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return RefreshIndicator(
              onRefresh: () async {
                 context.read<ComplaintBloc>().add(const RefreshComplaints('user1'));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sortedComplaints.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ComplaintCard(
                      complaint: sortedComplaints[index],
                      onTap: () {
                        // TODO: Navigate to detail
                      },
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}

/// Notifications Tab - Placeholder
/// Notifications Tab
class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock notifications for demo
    final notifications = [
      {
        'title': 'Complaint Resolved',
        'message': 'Your complaint regarding "Mess Food Quality" has been marked as resolved.',
        'time': '2 hours ago',
        'isRead': false,
        'icon': Icons.check_circle,
        'color': AppColors.success,
      },
      {
        'title': 'Status Updated',
        'message': 'Complaint "Bus Late Arrival" status changed to In Progress.',
        'time': '5 hours ago',
        'isRead': true,
        'icon': Icons.sync,
        'color': AppColors.statusInProgress,
      },
      {
        'title': 'New Announcement',
        'message': 'Hostel gate closing time has been changed to 10:30 PM effective from tomorrow.',
        'time': '1 day ago',
        'isRead': true,
        'icon': Icons.campaign,
        'color': AppColors.primary,
      },
      {
        'title': 'Complaint Acknowledged',
        'message': 'Admin has viewed your complaint "WiFi Issue in Block B".',
        'time': '2 days ago',
        'isRead': true,
        'icon': Icons.visibility,
        'color': AppColors.info,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All marked as read')),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final isRead = notification['isRead'] as bool;
          
          return Container(
            color: isRead ? Colors.transparent : AppColors.primary.withOpacity(0.05),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (notification['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'] as IconData,
                  color: notification['color'] as Color,
                  size: 20,
                ),
              ),
              title: Text(
                notification['title'] as String,
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification['message'] as String,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification['time'] as String,
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Navigate to details
              },
            ),
          );
        },
      ),
    );
  }
}

/// Profile Tab
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Default values
        String name = 'Student';
        String email = 'student@sharda.ac.in';
        String department = 'Department';
        String rollNumber = 'Roll Number';

        if (state is AuthAuthenticated) {
          name = state.user.name;
          email = state.user.email;
          department = state.user.department;
          rollNumber = state.user.rollNumber ?? '';
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // TODO: Edit profile
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Name & Email
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Info Cards
                _buildInfoCard(Icons.badge_outlined, 'Roll Number', rollNumber),
                const SizedBox(height: 16),
                _buildInfoCard(Icons.school_outlined, 'Department', department),
                const SizedBox(height: 16),
                _buildInfoCard(Icons.calendar_today_outlined, 'Year', '${state is AuthAuthenticated ? state.user.year : "3"}rd Year'),
                
                const SizedBox(height: 48),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.read<AuthBloc>().add(LoggedOut());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
