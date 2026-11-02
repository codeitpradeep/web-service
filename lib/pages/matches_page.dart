import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_web_project/main.dart';
import 'package:my_web_project/responsive_layout.dart';
import 'package:my_web_project/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  Profile? _userProfile;
  List<Profile> _matches = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileAndMatches();
  }

  Future<void> _fetchUserProfileAndMatches() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw 'User is not logged in.';
      }

      // Fetch user profile
      final profileResponse = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      final data = profileResponse;
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

      _userProfile = Profile(
        id: data['id'],
        name: data['full_name'] ?? 'N/A',
        age: age,
        city: data['city'],
        education: data['highest_education'],
        occupation: data['occupation'],
        rasi: data['rasi'],
        nachathram: data['nachathram'],
        dosham: data['dosham'],
        caste: data['caste'],
        photos: [data['profile_picture'] ?? 'https://picsum.photos/150'],
        dateOfBirth: dob,
        profilePicture: data['profile_picture'] ?? 'https://picsum.photos/150',
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

      if (_userProfile?.gender == null) {
        setState(() {
          _matches = [];
          _isLoading = false;
        });
        return;
      }

      // Fetch matches
      final targetGender = _userProfile!.gender == 'bride' ? 'groom' : 'bride';
      final matchesResponse = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('gender', targetGender)
          .neq('id', userId);

      final List<Profile> loadedMatches = matchesResponse.map<Profile>((data) {
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
        return Profile(
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
          photos: [data['profile_picture'] ?? 'https://picsum.photos/150'],
          dateOfBirth: dob,
          profilePicture:
              data['profile_picture'] ?? 'https://picsum.photos/150',
          mobileNumber: data['mobile_number'],
          email: data['email'],
          gender: data['gender'],
          accountType: data['account_type'],
          motherTongue: data['mother_tongue'],
          aboutMe: data['about_me'],
          highestEducation: data['highest_education'],
          maritalStatus: data['marital_status'],
          country: data['country'],
          horoscopeUrl: data['horoscope_url'],
          state: data['state'],
          companyName: data['company_name'],
          annualIncome: data['annual_income'],
          fathersOccupation: data['fathers_occupation'],
          mothersOccupation: data['mothers_occupation'],
          numberOfSiblings: data['number_of_siblings'],
          familyValues: data['family_values'],
          approvalStatus: data['approval_status'],
        );
      }).toList();

      setState(() {
        _matches = loadedMatches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data: ${e.toString()}';
        _isLoading = false;
      });
    }
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

    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final jsonAssetPaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/output_'))
        .toList();

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
      }
    }

    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_matches.isEmpty) {
      return Center(
        child: Text(
          'No matches found at the moment. Please check back later.',
          style: AppTextStyles.bodyText,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: _matches.length,
      itemBuilder: (context, index) {
        final match = _matches[index];
        return _buildMatchCard(match);
      },
    );
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
              Expanded(
                flex: 3,
                child: Image.asset(
                  profile.gender == 'bride'
                      ? 'assets/avatar/girl_image_1.png'
                      : 'assets/avatar/boy_image_1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 80, color: Colors.grey),
                ),
              ),
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
                                '${profile.dosham ?? 'N/A'} Dosham',
                                style: AppTextStyles.cardSubtitle.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${profile.age ?? 'N/A'} yrs, ${profile.occupation ?? 'N/A'}',
                                style: AppTextStyles.cardSubtitle.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${profile.annualIncome ?? 'N/A'}',
                                style: AppTextStyles.cardSubtitle.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${profile.city ?? 'N/A'}',
                                style: AppTextStyles.cardSubtitle.copyWith(
                                  fontSize: 12,
                                ),
                              ), //dosham
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
                                builder: (context) => AlertDialog(
                                  title: const Text('Pending Approval'),
                                  content: const Text(
                                      'Your profile is currently pending approval. You cannot view other profiles until it is approved.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
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
}
