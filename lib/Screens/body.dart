import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackwithinfy/Screens/analyse_pdf.dart';
import 'package:hackwithinfy/Screens/health_eduction.dart';
import 'package:hackwithinfy/Screens/home_page.dart';
import 'package:hackwithinfy/Screens/profile_screen.dart';
import 'package:hackwithinfy/Screens/your_medical_records.dart';
import 'chatbox.dart';
import 'health_insights.dart';

class DashboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Report Analysis',
      'description': 'Get AI-powered analysis of your medical reports',
      'icon': Icons.description,
      'color': Colors.blue,
      'route': ChatInterface(),
    },
    {
      'title': 'Nearby Health Checkups',
      'description': 'Find affordable health checkups in your area',
      'icon': Icons.local_hospital,
      'color': Colors.green,
      'route': HomePage(),
    },
    {
      'title': 'Health Risks & Insights',
      'description': 'Understand your personal health risks',
      'icon': Icons.health_and_safety,
      'color': Colors.purple,
      'route': DailyRoutinePage(
          userEmail: FirebaseAuth.instance.currentUser?.email ?? ""),
    },
    {
      'title': 'Global Health Issues',
      'description': 'Stay informed about health news and trends',
      'icon': Icons.public,
      'color': Colors.orange,
      'route': HealthEducation(),
    },
    {
      'title': 'Your Health Records',
      'description': 'Access and manage your medical history',
      'icon': Icons.folder_shared,
      'color': Colors.red,
      // Change this to the correct route for health records
      'route':
          YourMedicalRecordsPage(), // Example: Replace with your actual screen
    },
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("User data not found")),
          );
        }

        String firstName = snapshot.data!.get('firstName') ?? "User";
        String lastName = snapshot.data!.get('lastName') ?? "";

        return Scaffold(
          backgroundColor: Colors.grey[50],
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.9,
                    minChildSize: 0.7,
                    maxChildSize: 0.9,
                    expand: false,
                    builder: (context, scrollController) {
                      return ChatBox(); // Your ChatBox widget
                    },
                  );
                },
              );
            },
          ),
          body: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.white,
                elevation: 2,
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, $firstName',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Take control of your health',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Welcome Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 0,
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Health Dashboard',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Monitor and manage your health journey in one place',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff14B8A6), // Background color
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24), // Padding
                            child: const Text(
                              'Quick Health Check',
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 16, // Text size
                                fontWeight: FontWeight.bold, // Text weight
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Dashboard Grid
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = menuItems[index];
                      return DashboardCard(
                        title: item['title'],
                        description: item['description'],
                        icon: item['icon'],
                        color: item['color'],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => item['route']),
                        ),
                      );
                    },
                    childCount: menuItems.length,
                  ),
                ),
              ),

              // Emergency Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.red, width: 1),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.emergency, color: Colors.red),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Emergency Services',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  'Call 911 for immediate medical assistance',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
