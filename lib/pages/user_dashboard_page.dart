import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_web_project/responsive_layout.dart';
import 'package:my_web_project/theme.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_web_project/main.dart'; // For Profile model and AppRoutes
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Profile? _userProfile;
  List<Profile> _matches = []; // To store fetched matches
  bool _isLoading = true;
  bool _isMatchesLoading = true; // Separate loading state for matches
  String? _errorMessage; // New variable to store error messages
  bool _shouldRedirectToLogin = false; // New state variable for redirection
  final List<String> _tabs = const [
    'My Profile/Matches',
    'Interests Sent/Received',
    'Messages',
    'Privacy Settings',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // _fetchUserProfile(); // Moved to didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only fetch if profile is null to avoid redundant calls on dependency changes
    if (_userProfile == null && _isLoading) {
      _fetchUserProfile();
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true; // Ensure loading state is set when fetching starts
      _errorMessage = null; // Clear previous errors
      _shouldRedirectToLogin = false; // Reset redirection flag
    });
    try {
      final String? userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        // Handle case where user is not logged in
        // Instead of direct navigation, set the redirection flag
        setState(() {
          _shouldRedirectToLogin = true;
          _isLoading = false; // Stop loading as we're redirecting
        });
        return;
      }

      final List<Map<String, dynamic>> response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .limit(1);

      if (response.isNotEmpty) {
        final Map<String, dynamic> data = response[0];
        DateTime? dob;
        if (data['date_of_birth'] != null) {
          dob = DateTime.parse(data['date_of_birth']);
        }

        int? age;
        if (dob != null) {
          final now = DateTime.now();
          age = now.year - dob.year;
          if (now.month < dob.month ||
              (now.month == dob.month && now.day < dob.day)) {
            age--;
          }
        }

        String profilePictureUrl =
            data['profile_picture'] ?? 'https://picsum.photos/150';

        final newProfile = Profile(
          id: data['id'],
          userid: data['userid'],
          name: data['full_name'] ?? 'N/A',
          age: age,
          city: data['city'],
          education: data['highest_education'],
          occupation: data['occupation'],
          rasi: data['rasi'],
          nachathram: data['nachathram'],
          dosham: data['dosham'],
          caste: data['caste'],
          photos: [profilePictureUrl],
          dateOfBirth: dob,
          profilePicture: profilePictureUrl,
          mobileNumber: data['mobile_number'],
          email: data['email'],
          gender: data['gender'],
          accountType: data['account_type'],
          motherTongue: data['mother_tongue'],
          aboutMe: data['about_me'],
          highestEducation: data['highest_education'],
          maritalStatus: data['marital_status'],
          country: data['country'],
          state: data['state'],
          companyName: data['company_name'],
          annualIncome: data['annual_income'],
          fathersOccupation: data['fathers_occupation'],
          mothersOccupation: data['mothers_occupation'],
          numberOfSiblings: data['number_of_siblings'],
          familyValues: data['family_values'],
          horoscopeUrl: data['horoscope_url'],
          approvalStatus: data['approval_status'],
        );

        // Now that we have the profile, fetch the matches
        await _fetchMatches(newProfile);
      } else {
        // User profile not found, set error message
        setState(() {
          _errorMessage = 'User profile not found.';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Error fetching profile, set error message
      setState(() {
        _errorMessage = 'Error fetching profile: ${e.toString()}';
        _isLoading = false;
      });
    }
    // No longer need a finally block to set isLoading, it's handled in each path.
  }

  Future<void> _fetchMatches(Profile userProfile) async {
    if (userProfile.gender == null) {
      setState(() {
        _userProfile = userProfile; // Still set the user profile
        _isMatchesLoading = false;
        _isLoading = false;
        _matches = []; // Ensure matches are empty
      });
      return;
    }

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final targetGender = userProfile.gender == 'bride' ? 'groom' : 'bride';

      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('gender', targetGender)
          .neq('id', userId); // Exclude the current user

      final List<Profile> loadedMatches = response.map<Profile>((data) {
        DateTime? dob;
        if (data['date_of_birth'] != null) {
          dob = DateTime.parse(data['date_of_birth']);
        }

        int? age;
        if (dob != null) {
          final now = DateTime.now();
          age = now.year - dob.year;
          if (now.month < dob.month ||
              (now.month == dob.month && now.day < dob.day)) {
            age--;
          }
        }
        String profilePictureUrl =
            data['profile_picture'] ?? 'https://picsum.photos/150';

        return Profile(
          id: data['id'], // Important for navigation
          name: data['full_name'] ?? 'N/A',
          age: age,
          city: data['city'],
          education: data['highest_education'],
          occupation: data['occupation'],
          rasi: data['rasi'],
          nachathram: data['nachathram'],
          dosham: data['dosham'],
          caste: data['caste'],
          photos: [profilePictureUrl],
          dateOfBirth: dob,
          profilePicture: profilePictureUrl,
          mobileNumber: data['mobile_number'],
          email: data['email'],
          gender: data['gender'],
          accountType: data['account_type'],
          motherTongue: data['mother_tongue'],
          aboutMe: data['about_me'],
          highestEducation: data['highest_education'],
          maritalStatus: data['marital_status'],
          country: data['country'],
          state: data['state'],
          companyName: data['company_name'],
          annualIncome: data['annual_income'],
          fathersOccupation: data['fathers_occupation'],
          mothersOccupation: data['mothers_occupation'],
          numberOfSiblings: data['number_of_siblings'],
          familyValues: data['family_values'],
          horoscopeUrl: data['horoscope_url'],
        );
      }).toList();

      setState(() {
        _userProfile = userProfile;
        _matches = loadedMatches;
        _isMatchesLoading = false;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error, maybe show a snackbar or a message in the matches tab
      print('Error fetching matches: $e');
      setState(() {
        _userProfile = userProfile;
        _matches = [];
        _isMatchesLoading = false;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldRedirectToLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      });
      return const Center(
        child: CircularProgressIndicator(),
      ); // Show loading while redirecting
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_userProfile == null) {
      return const Center(child: Text('Failed to load user profile.'));
    }

    // Use the fetched user profile
    final Profile userProfile = _userProfile!;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1024), // max-w-5xl
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 16,
          vertical: isMobile ? 20 : 40,
        ), // px-4 py-10
        child: Column(
          children: [
            // Tab Navigation
            Container(
              margin: const EdgeInsets.only(bottom: 32), // mb-8
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.secondary200),
                ), // border-b border-stone-200
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary500, // text-[var(--primary-color)]
                unselectedLabelColor: AppColors.secondary700, // text-stone-500
                indicatorColor: AppColors.primary500,
                indicatorWeight: 2.0,
                labelStyle: AppTextStyles.navLink.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ), // text-sm font-semibold
                unselectedLabelStyle: AppTextStyles.navLink.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ), // text-sm font-medium
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                onTap: (index) {
                  _tabController.animateTo(index);
                },
              ),
            ),

            // Tab Content
            Expanded(
              // Wrap with Expanded
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: _tabs.map((tab) {
                  if (tab == 'My Profile/Matches') {
                    return SingleChildScrollView(
                      child: _buildMyProfileTab(userProfile, isMobile),
                    ); // Wrap with SingleChildScrollView
                  } else if (tab == 'Interests Sent/Received') {
                    return SingleChildScrollView(
                      child: _buildInterestsTab(isMobile),
                    ); // Wrap with SingleChildScrollView
                  } else if (tab == 'Messages') {
                    return const Center(child: Text('Messages (Coming Soon)'));
                  } else if (tab == 'Privacy Settings') {
                    return const Center(
                      child: Text('Privacy Settings (Coming Soon)'),
                    );
                  } else {
                    return const Center(child: Text('Unknown Tab'));
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyProfileTab(Profile profile, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profile Summary and Edit Button
        Card(
          elevation: 1, // shadow-sm
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ), // rounded-lg
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16), // p-6 -> p-4
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: isMobile ? 80 : 96,
                      height: isMobile ? 80 : 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        image: DecorationImage(
                          image: NetworkImage(profile.photos![0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      margin: const EdgeInsets.only(right: 16),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: AppTextStyles.headline2.copyWith(
                              color: AppColors.textColor,
                              fontSize: isMobile ? 18 : 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'DOB: ${profile.dateOfBirth != null ? DateFormat('dd-MM-yyyy').format(profile.dateOfBirth!) : 'N/A'}, Height: 5\'6"\n${profile.rasi ?? 'N/A'}, ${profile.nachathram ?? 'N/A'}',
                            style: AppTextStyles.cardSubtitle.copyWith(
                              color: AppColors.secondary700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result =
                          await Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(
                            AppRoutes.createEditProfile,
                            arguments: profile,
                          );
                      if (result == true) {
                        _fetchUserProfile();
                      }
                    },
                    icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                    label: Text(
                      'Edit Profile',
                      style: AppTextStyles.buttonText.copyWith(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (profile.horoscopeUrl != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final url = profile.horoscopeUrl!;
                        print('Debug: Downloading Horoscope URL: $url');

                        try {
                          // Fetch the file content
                          final response = await http.get(Uri.parse(url));

                          if (response.statusCode == 200) {
                            // Create a blob from the bytes
                            // Force type to application/pdf regardless of extension
                            final blob = html.Blob([
                              response.bodyBytes,
                            ], 'application/pdf');
                            final blobUrl = html.Url.createObjectUrlFromBlob(
                              blob,
                            );

                            // Create a temporary anchor element to trigger download
                            // Ensure we save it as .pdf
                            final anchor = html.AnchorElement(href: blobUrl)
                              ..setAttribute("download", "horoscope.pdf")
                              ..click();

                            // Cleanup
                            html.Url.revokeObjectUrl(blobUrl);
                          } else {
                            throw Exception(
                              'Failed to download file: ${response.statusCode}',
                            );
                          }
                        } catch (e) {
                          print('Download error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Download failed: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.download,
                        size: 16,
                        color: AppColors.primary500,
                      ),
                      label: Text(
                        'Download Horoscope',
                        style: AppTextStyles.buttonText.copyWith(
                          fontSize: 14,
                          color: AppColors.primary500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary500),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 32), // space-y-8
        // Matches Grid
        _buildMatchesTab(isMobile),
      ],
    );
  }

  Widget _buildMatchesTab(bool isMobile) {
    if (_isMatchesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        if (_matches.isEmpty)
          Center(
            child: Text(
              'No matches found at the moment. Please check back later.',
              style: AppTextStyles.bodyText,
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Important for nested scrolling
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 0.85 : 1.3, // Adjusted height: Taller for mobile (narrower width), shorter for desktop
            ),
            itemCount: _matches.length,
            itemBuilder: (context, index) {
              final match = _matches[index];
              return _buildMatchCard(match);
            },
          ),
      ],
    );
  }

  Future<String?> getMatchScore(
    String? currentUserNachathram,
    String? matchNachathram,
  ) async {
    if (currentUserNachathram == null || matchNachathram == null) {
      return null;
    }

    final currentUserGender = _userProfile?.gender;
    String boyNachathram;
    String girlNachathram;

    if (currentUserGender == 'bride') {
      girlNachathram = currentUserNachathram;
      boyNachathram = matchNachathram;
    } else {
      boyNachathram = currentUserNachathram;
      girlNachathram = matchNachathram;
    }

    final matchKey = 'matchscore_${girlNachathram}_${boyNachathram}';

    // 1. Load the asset manifest
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // 2. Filter for the output JSON files
    final jsonAssetPaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/output_'))
        .toList();

    // 3. Load and search each file
    for (final path in jsonAssetPaths) {
      try {
        final String data = await rootBundle.loadString(path);
        final List<dynamic> jsonResult = json.decode(data);

        for (var item in jsonResult) {
          if (item.containsKey(matchKey)) {
            return item[matchKey];
          }
        }
      } catch (e) {
        print('Error loading or parsing match score data from $path: $e');
        // Continue to the next file
      }
    }

    return 'N/A'; // Not found in any file
  }

  Widget _buildMatchCard(Profile profile) {
    return FutureBuilder<String?>(
      future: getMatchScore(_userProfile?.nachathram, profile.nachathram),
      builder: (context, snapshot) {
        String? matchScore;
        if (snapshot.connectionState == ConnectionState.done) {
          matchScore = snapshot.data;
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /*Expanded(
                flex: 3,
                child: Image.asset(
                  profile.gender == 'bride'
                      ? 'assets/avatar/girl_image_1.png'
                      : 'assets/avatar/boy_image_1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 80, color: Colors.grey),
                ),
              ),*/
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                const Center(child: CircularProgressIndicator())
                              else if (matchScore != null &&
                                  matchScore != 'N/A')
                                Text(
                                  'Match Score: $matchScore',
                                  style: AppTextStyles.cardTitle.copyWith(
                                    fontSize: 18,
                                    color: AppColors.primary500,
                                  ),
                                ),
                              Text(
                                profile.name,
                                style: AppTextStyles.cardTitle.copyWith(
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${profile.age ?? 'N/A'} yrs, ${profile.occupation ?? 'N/A'}',
                                style: AppTextStyles.cardSubtitle.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${profile.city ?? 'N/A'}',
                                style: AppTextStyles.cardSubtitle.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${profile.rasi ?? 'N/A'}, ${profile.nachathram ?? 'N/A'}',
                                style: AppTextStyles.cardSubtitle.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_userProfile?.approvalStatus ==
                                'pending_approval') {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Approval Pending'),
                                      content: const Text(
                                        'Waiting for the approval and upload Jathagam pdf',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                              );
                              return;
                            }
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamed(
                              AppRoutes.profileView,
                              arguments: profile,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'View Profile',
                            style: AppTextStyles.buttonText.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInterestsTab(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests Sent/Received',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 24),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildInterestListItem(
              'Interest Received from Karthik M.',
              'Age: 29, Height: 5\'9\", Hindu, Tamil, Architect',
              "https://picsum.photos/400/600?random=4",
              isMobile,
            ),
            const SizedBox(height: 16),
            _buildInterestListItem(
              'Interest Sent to Meena L.',
              'Age: 27, Height: 5\'5\", Hindu, Tamil, Teacher',
              "https://picsum.photos/400/600?random=5",
              isMobile,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestListItem(
    String title,
    String details,
    String imageUrl,
    bool isMobile,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            Container(
              width: isMobile ? double.infinity : 96,
              height: isMobile ? 150 : 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              margin: isMobile
                  ? const EdgeInsets.only(bottom: 16)
                  : const EdgeInsets.only(right: 24),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: AppTextStyles.cardSubtitle.copyWith(
                      color: AppColors.secondary700,
                    ),
                  ),
                ],
              ),
            ),
            if (isMobile) const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Navigator.pushNamed(
                //   context,
                //   AppRoutes.profileView,
                // ); // View Profile logic
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.secondary100,
                foregroundColor: AppColors.textColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                textStyle: AppTextStyles.buttonTextSecondary.copyWith(
                  fontSize: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(isMobile ? double.infinity : 84, 40),
                side: BorderSide.none,
              ),
              child: const Text('View Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
