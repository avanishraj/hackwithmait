import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackwithinfy/SOS/sos.dart';
import 'package:hackwithinfy/Screens/analyse_pdf.dart';
import 'package:hackwithinfy/Screens/lab_page.dart';
import 'package:hackwithinfy/Screens/profile_screen.dart';
import 'package:location/location.dart';
import 'package:shake/shake.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String? selectedCheckup;
  String filterOption = 'All';
  bool isAvailable = false;
  List<String> checkUpList = [];
  List<Map<String, dynamic>> labsList = [];
  Location location = Location();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    fetchCheckUpList();
    ShakeDetector.autoStart(
      onPhoneShake: () {},
      minimumShakeCount: 4,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchCheckUpList() async {
    setState(() => isLoading = true);
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('checkUpList')
          .doc('N0BflKMM7IgofCOzJRwy')
          .get();
      List<String> tempList =
          List<String>.from(docSnapshot.get('checkUpLists'));

      setState(() {
        checkUpList = tempList;
        if (checkUpList.isNotEmpty) {
          selectedCheckup = checkUpList[0];
          fetchLabsList(selectedCheckup!);
        }
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load checkup list');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> fetchLabsList(String checkup) async {
    setState(() => isLoading = true);
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Labs')
          .doc('4t3npWdMyHfu3uPgdTTO')
          .get();
      setState(() {
        labsList = List<Map<String, dynamic>>.from(docSnapshot.get(checkup));
        labsList.sort((a, b) => a['price'].compareTo(b['price']));
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load labs');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search for labs...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF3B5998)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ['All', 'Available', 'Unavailable'].map((String filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: filterOption == filter,
              onSelected: (bool selected) {
                setState(() => filterOption = filter);
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF34C759).withOpacity(0.2),
              labelStyle: TextStyle(
                color: filterOption == filter
                    ? const Color(0xFF34C759)
                    : Colors.grey[600],
                fontWeight: filterOption == filter
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: filterOption == filter
                      ? const Color(0xFF34C759)
                      : Colors.grey[300]!,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLabCard(Map<String, dynamic> lab, int index) {
    final bool isAvailable = lab['available'] ?? false;
    final bool isSelected = lab['isSelected'] ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LabDetailsPage(lab: lab)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lab['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B5998),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? const Color(0xFF34C759).withOpacity(0.1)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isAvailable ? 'Available' : 'Unavailable',
                          style: TextStyle(
                            color: isAvailable
                                ? const Color(0xFF34C759)
                                : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          lab['address'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.directions_car_outlined,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        lab['distance'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.phone_outlined,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        lab['phone_no'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF3B5998),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Health Checkups',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF3B5998).withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: const Text("Select Check Up"),
                    value: selectedCheckup,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCheckup = newValue!;
                        fetchLabsList(selectedCheckup!);
                      });
                    },
                    items: checkUpList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterChips(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (labsList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('Please select a checkup to see labs'),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final lab = labsList[index];
                  final bool isAvailable = lab['available'] ?? false;

                  if (filterOption == 'Available' && !isAvailable) {
                    return const SizedBox.shrink();
                  } else if (filterOption == 'Unavailable' && isAvailable) {
                    return const SizedBox.shrink();
                  }

                  return _buildLabCard(lab, index);
                },
                childCount: labsList.length,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle SOS action
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.emergency),
      ),
    );
  }
}
