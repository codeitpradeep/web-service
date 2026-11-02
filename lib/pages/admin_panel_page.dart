import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/widgets/app_header.dart'; // Import AppHeader
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:rxdart/rxdart.dart';
import 'package:my_web_project/main.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _selectedIndex = 1; // Default to 'New Profiles'

  final List<String> _tabs = const [
    'Dashboard',
    'New Profiles',
    'Manage User Profiles',
    'Approved Profiles',
    'Rejected Profiles',
    'Settings',
  ];

  // Change to late non-final to allow re-assignment
  late Stream<List<Map<String, dynamic>>> _newProfilesStream;
  late Stream<List<Map<String, dynamic>>> _approvedProfilesStream;
  late Stream<List<Map<String, dynamic>>> _rejectedProfilesStream;
  late Stream<List<Map<String, dynamic>>> _allProfilesStream;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
    _initializeStreams(); // Call method to set up streams
  }

  Future<void> _checkAdminRole() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      return;
    }

    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .single();
      
      if (data['role'] != 'admin') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access Denied: Admins only')),
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
        }
      }
    } catch (e) {
       // Handle error or redirect
       if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    }
  }

  // Method to set up the streams
  void _initializeStreams() {
    _newProfilesStream = Supabase.instance.client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('approval_status', 'pending_approval');
    _approvedProfilesStream = Supabase.instance.client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('approval_status', 'approved');
    _rejectedProfilesStream = Supabase.instance.client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('approval_status', 'rejected');
    _allProfilesStream = Supabase.instance.client
        .from('profiles')
        .stream(primaryKey: ['id']);
  }

  // Method to manually refresh the streams
  void _refreshData() {
    setState(() {
      // By re-initializing the streams, we force the StreamBuilders to get new data
      _initializeStreams();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data refreshed!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        automaticallyImplyLeading: false, // No back button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            // Desktop layout
            return Row(
              children: [
                // Sidebar Navigation
                _buildSidebar(context),
                // Main Content Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32), // p-8
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedIndex == 1
                              ? 'New Profiles'
                              : (_selectedIndex == 2
                                    ? 'Manage User Profiles'
                                    : _tabs[_selectedIndex]), // Dynamic title
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.textColor,
                          ), // text-3xl font-bold
                        ),
                        const SizedBox(height: 4), // mt-1
                        Text(
                          _selectedIndex == 1
                              ? 'Review and moderate new profiles awaiting approval.'
                              : (_selectedIndex == 2
                                    ? 'Create, view, and edit user profiles.'
                                    : 'Content for ${_tabs[_selectedIndex]}.'),
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.secondary700,
                          ), // text-gray-500
                        ),
                        const SizedBox(height: 32), // mb-8
                        // Dynamic content based on selected tab
                        Expanded(
                          child: IndexedStack(
                            index: _selectedIndex,
                            children: [
                              // Dashboard
                              StreamBuilder<List<List<Map<String, dynamic>>>>(
                                stream: Rx.zipList([
                                  _newProfilesStream,
                                  _approvedProfilesStream,
                                  _rejectedProfilesStream,
                                ]),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final newProfilesCount =
                                      snapshot.data![0].length;
                                  final approvedProfilesCount =
                                      snapshot.data![1].length;
                                  final rejectedProfilesCount =
                                      snapshot.data![2].length;

                                  return GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    padding: const EdgeInsets.all(16),
                                    children: [
                                      _buildMetricCard(
                                        'New Profiles',
                                        newProfilesCount.toString(),
                                        Icons.person_add,
                                      ),
                                      _buildMetricCard(
                                        'Approved Profiles',
                                        approvedProfilesCount.toString(),
                                        Icons.how_to_reg,
                                      ),
                                      _buildMetricCard(
                                        'Rejected Profiles',
                                        rejectedProfilesCount.toString(),
                                        Icons.person_off,
                                      ),
                                    ],
                                  );
                                },
                              ),

                              // New Profiles
                              StreamBuilder<List<Map<String, dynamic>>>(
                                stream: _newProfilesStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final profiles = snapshot.data!;
                                    return _buildNewProfilesTable(profiles);
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              // Manage User Profiles
                              _buildManageUserProfilesContent(),
                              // Approved Profiles
                              StreamBuilder<List<Map<String, dynamic>>>(
                                stream: _approvedProfilesStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final profiles = snapshot.data!;
                                    return _buildProfilesTable(profiles, false);
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              // Rejected Profiles
                              StreamBuilder<List<Map<String, dynamic>>>(
                                stream: _rejectedProfilesStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final profiles = snapshot.data!;
                                    return _buildProfilesTable(profiles, false);
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              // Settings
                              const Center(
                                child: Text('Settings Content (Coming Soon)'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Mobile layout
            return Padding(
              padding: const EdgeInsets.all(16), // p-4
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedIndex == 1
                        ? 'New Profiles'
                        : (_selectedIndex == 2
                              ? 'Manage User Profiles'
                              : _tabs[_selectedIndex]), // Dynamic title
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.textColor,
                    ), // text-3xl font-bold
                  ),
                  const SizedBox(height: 4), // mt-1
                  Text(
                    _selectedIndex == 1
                        ? 'Review and moderate new profiles awaiting approval.'
                        : (_selectedIndex == 2
                              ? 'Create, view, and edit user profiles.'
                              : 'Content for ${_tabs[_selectedIndex]}.'),
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.secondary700,
                    ), // text-gray-500
                  ),
                  const SizedBox(height: 32), // mb-8
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: [
                        // Dashboard
                        StreamBuilder<List<List<Map<String, dynamic>>>>(
                          stream: Rx.zipList([
                            _newProfilesStream,
                            _approvedProfilesStream,
                            _rejectedProfilesStream,
                          ]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final newProfilesCount = snapshot.data![0].length;
                            final approvedProfilesCount =
                                snapshot.data![1].length;
                            final rejectedProfilesCount =
                                snapshot.data![2].length;

                            return GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              padding: const EdgeInsets.all(16),
                              children: [
                                _buildMetricCard(
                                  'New Profiles',
                                  newProfilesCount.toString(),
                                  Icons.person_add,
                                ),
                                _buildMetricCard(
                                  'Approved Profiles',
                                  approvedProfilesCount.toString(),
                                  Icons.how_to_reg,
                                ),
                                _buildMetricCard(
                                  'Rejected Profiles',
                                  rejectedProfilesCount.toString(),
                                  Icons.person_off,
                                ),
                              ],
                            );
                          },
                        ),

                        // New Profiles
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _newProfilesStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final profiles = snapshot.data!;
                              return _buildNewProfilesTable(profiles);
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        // Manage User Profiles
                        _buildManageUserProfilesContent(),
                        // Approved Profiles
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _approvedProfilesStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final profiles = snapshot.data!;
                              return _buildProfilesTable(profiles, false);
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        // Rejected Profiles
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _rejectedProfilesStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final profiles = snapshot.data!;
                              return _buildProfilesTable(profiles, false);
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        // Settings
                        const Center(
                          child: Text('Settings Content (Coming Soon)'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 256, // w-64
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: AppColors.secondary200),
        ), // border-r border-gray-200
      ),
      padding: const EdgeInsets.all(16), // p-4
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12), // px-3
            child: Text(
              'Admin Panel',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textColor,
              ), // text-xl font-bold
            ),
          ),
          const SizedBox(height: 32), // gap-8
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavItem(0, 'Dashboard', Icons.dashboard),
                _buildNavItem(1, 'New Profiles', Icons.person_add),
                _buildNavItem(2, 'Manage User Profiles', Icons.group),
                _buildNavItem(3, 'Approved Profiles', Icons.how_to_reg),
                _buildNavItem(4, 'Rejected Profiles', Icons.person_off),
              ],
            ),
          ),
          const Divider(
            height: 32,
            color: AppColors.secondary200,
          ), // Visual separator
          _buildNavItem(5, 'Settings', Icons.settings),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    final bool isSelected = index == _selectedIndex;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ), // px-3 py-2
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary500 : Colors.transparent,
          borderRadius: BorderRadius.circular(8), // rounded-md
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : AppColors.secondary600,
            ), // material-symbols-outlined
            const SizedBox(width: 12), // gap-3
            Text(
              title,
              style: AppTextStyles.buttonText.copyWith(
                fontSize: 14,
                color: isSelected ? Colors.white : AppColors.secondary700,
              ), // text-sm font-medium
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewProfilesTable(List<Map<String, dynamic>> profiles) {
    return _buildProfilesTable(profiles, true);
  }

  Widget _buildProfilesTable(
    List<Map<String, dynamic>> profiles,
    bool isNewProfiles,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // rounded-lg
        border: Border.all(
          color: AppColors.secondary200,
        ), // border border-gray-200
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateColor.resolveWith(
            (states) => AppColors.secondary50,
          ), // bg-gray-50
          dataRowColor: WidgetStateColor.resolveWith(
            (states) => Colors.white,
          ), // bg-white
          columns: [
            const DataColumn(
              label: Text(
                'Profile ID',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.secondary800,
                ),
              ),
            ), // text-xs text-gray-700 uppercase
            const DataColumn(
              label: Text(
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.secondary800,
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                'Date of Birth',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.secondary800,
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                'Gender',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.secondary800,
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                'City',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.secondary800,
                ),
              ),
            ),
            if (isNewProfiles)
              const DataColumn(
                label: Center(
                  child: Text(
                    'Action',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.secondary800,
                    ),
                  ),
                ),
              ),
          ],
          rows: profiles.map((profile) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    profile['id']?.toString() ?? '',
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                ), // font-medium text-gray-900 whitespace-nowrap
                DataCell(
                  Text(
                    profile['full_name']?.toString() ?? 'N/A',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    profile['date_of_birth'] != null
                        ? DateFormat(
                            'dd-MM-yyyy, hh:mm a',
                          ).format(DateTime.parse(profile['date_of_birth']))
                        : 'N/A',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    profile['gender']?.toString() ?? 'N/A',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    profile['city']?.toString() ?? 'N/A',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                if (isNewProfiles)
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              _approveProfile(profile['id'] as String),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green.shade600, // bg-green-600
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ), // px-3 py-1.5
                            textStyle: AppTextStyles.buttonText.copyWith(
                              fontSize: 12,
                            ), // text-xs font-medium
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ), // rounded-md
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Approve'),
                        ),
                        const SizedBox(width: 8), // gap-2
                        ElevatedButton(
                          onPressed: () =>
                              _rejectProfile(profile['id'] as String),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600, // bg-red-600
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            textStyle: AppTextStyles.buttonText.copyWith(
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Reject'),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _approveProfile(String profileId) async {
    setState(() => _isLoading = true);
    await Supabase.instance.client
        .from('profiles')
        .update({'approval_status': 'approved'})
        .eq('id', profileId);
    setState(() => _isLoading = false);
  }

  void _rejectProfile(String profileId) async {
    setState(() => _isLoading = true);
    await Supabase.instance.client
        .from('profiles')
        .update({'approval_status': 'rejected'})
        .eq('id', profileId);
    setState(() => _isLoading = false);
  }

  void _deleteProfile(String profileId) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      await Supabase.instance.client
          .from('profiles')
          .delete()
          .eq('id', profileId);
      setState(() => _isLoading = false);
    }
  }

  Widget _buildManageUserProfilesContent() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _allProfilesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final profiles = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Create New Profile" button removed as it requires Auth registration logic
              // which is not handled by CreateEditProfilePage (it only updates).
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.secondary200),
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Date of Birth')),
                    DataColumn(label: Text('Gender')),
                    DataColumn(label: Text('City')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: profiles.map((profile) {
                    return DataRow(
                      cells: [
                        DataCell(Text(profile['id']?.toString() ?? 'N/A')),
                        DataCell(
                          Text(profile['full_name']?.toString() ?? 'N/A'),
                        ),
                        DataCell(
                          Text(
                            profile['date_of_birth'] != null
                                ? DateFormat('dd-MM-yyyy, hh:mm a').format(
                                    DateTime.parse(profile['date_of_birth']),
                                  )
                                : 'N/A',
                          ),
                        ),
                        DataCell(Text(profile['gender']?.toString() ?? 'N/A')),
                        DataCell(Text(profile['city']?.toString() ?? 'N/A')),
                        DataCell(_buildActionButtons(profile)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> profile) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            final profileToEdit = _profileFromMap(profile);
            Navigator.pushNamed(
              context,
              AppRoutes.createEditProfile,
              arguments: profileToEdit,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _isLoading
              ? null
              : () => _deleteProfile(profile['id'] as String),
        ),
        if (profile['approval_status'] != 'approved')
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            onPressed: _isLoading
                ? null
                : () => _approveProfile(profile['id'] as String),
          ),
        if (profile['approval_status'] != 'rejected')
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: _isLoading
                ? null
                : () => _rejectProfile(profile['id'] as String),
          ),
      ],
    );
  }

  Profile _profileFromMap(Map<String, dynamic> profileData) {
    return Profile(
      id: profileData['id'] as String?,
      userid: profileData['userid'] as String?,
      name: profileData['full_name'] as String? ?? '',
      age: profileData['age'] as int?,
      city: profileData['city'] as String?,
      education: profileData['highest_education'] as String?,
      occupation: profileData['occupation'] as String?,
      rasi: profileData['rasi'] as String?,
      nachathram: profileData['nachathram'] as String?,
      dosham: profileData['dosham'] as String?,
      caste: profileData['caste'] as String?,
      dateOfBirth: profileData['date_of_birth'] != null
          ? DateTime.parse(profileData['date_of_birth'] as String)
          : null,
      profilePicture: profileData['profile_picture'] as String?,
      mobileNumber: profileData['mobile_number'] as String?,
      email: profileData['email'] as String?,
      gender: profileData['gender'] as String?,
      accountType: profileData['account_type'] as String?,
      motherTongue: profileData['mother_tongue'] as String?,
      aboutMe: profileData['about_me'] as String?,
      highestEducation: profileData['highest_education'] as String?,
      maritalStatus: profileData['marital_status'] as String?,
      country: profileData['country'] as String?,
      state: profileData['state'] as String?,
      companyName: profileData['company_name'] as String?,
      annualIncome: profileData['annual_income'] as String?,
      fathersOccupation: profileData['fathers_occupation'] as String?,
      mothersOccupation: profileData['mothers_occupation'] as String?,
      numberOfSiblings: profileData['number_of_siblings'] as int?,
      familyValues: profileData['family_values'] as String?,
      horoscopeUrl: profileData['horoscope_url'] as String?,
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.primary500),
            const SizedBox(height: 16),
            Text(
              value,
              style: AppTextStyles.headline1.copyWith(
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.secondary700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
