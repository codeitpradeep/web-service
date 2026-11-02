import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_web_project/main.dart'; // For Profile model and AppRoutes
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Profile> _profiles = [];
  bool _isLoading = true;
  String _searchQuery = '';
  RangeValues _ageRange = const RangeValues(18, 60);
  String? _selectedLocation;
  String? _selectedRasi;
  String? _selectedNachathram;
  String? _selectedCaste;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    print("Fetching profiles..."); // Debug: Check if method is called
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client.from('profiles').select();

      if (response.isEmpty) {
        print(
          'Debug: No profiles found in the database.',
        ); // Debug: Check for empty response
      }

      if (mounted) {
        final List<Profile> loadedProfiles = response.map<Profile>((data) {
          // Basic logging for each profile
          // print('Debug: Mapping profile data: ${data['id']}');
          return Profile(
            id: data['id']?.toString(),
            userid: data['userid'],
            name: data['full_name'] ?? 'N/A',
            age: data['age'],
            city: data['city'],
            caste: data['caste'],
            nachathram: data['nachathram'], // Corrected from 'star'
            rasi: data['rasi'], // Corrected from 'raasi'
            dosham: data['dosham'],
            occupation: data['occupation'],
            education: data['highest_education'],
            profilePicture: data['profile_picture_url'],
            gender: data['gender'], // <-- This was missing
            horoscopeUrl: data['horoscope_url'],
            // Ensure all fields from Profile model are handled
          );
        }).toList();

        setState(() {
          _profiles = loadedProfiles;
          _isLoading = false;
        });
        print(
          "Debug: Profiles loaded successfully: ${loadedProfiles.length}",
        ); // Debug: Confirm loading
      }
    } catch (e, stacktrace) {
      // Catch stacktrace for more context
      if (mounted) {
        print('Error fetching profiles: $e'); // Debug: Log the error
        print('Stacktrace: $stacktrace'); // Debug: Log the stacktrace
        setState(() {
          _isLoading = false;
          // Optionally, add an error state to show a message in the UI
        });
      }
    }
  }

  void _onFilterChanged(Map<String, dynamic> filters) {
    setState(() {
      _ageRange = filters['ageRange'];
      _selectedLocation = filters['location'];
      _selectedRasi = filters['rasi'];
      _selectedNachathram = filters['nachathram'];
      _selectedCaste = filters['caste'];
    });
    _fetchProfiles();
  }

  String _getRandomAvatar(String? gender) {
    final random = Random();
    if (gender == 'Male' || gender == 'groom') {
      return 'assets/avatar/boy_image_${random.nextInt(2) + 1}.png';
    } else if (gender == 'Female' || gender == 'bride') {
      return 'assets/avatar/girl_image_${random.nextInt(2) + 1}.png';
    } else {
      // Default fallback if gender is null or unexpected value
      return 'assets/avatar/boy_image_1.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 768;

        if (isMobile) {
          // Mobile layout: Main content only, filters are in the drawer.
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: MainContent(
              isLoading: _isLoading,
              profiles: _profiles,
              isMobile: isMobile,
              onFilterTap: () => _scaffoldKey.currentState?.openDrawer(),
              getRandomAvatar: _getRandomAvatar,
            ),
          );
        } else {
          // Desktop layout: Side-by-side filter panel and main content.
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1280),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: FilterPanel(
                      isMobile: false,
                      onFilterChanged: _onFilterChanged,
                      initialFilters: {
                        'ageRange': _ageRange,
                        'location': _selectedLocation,
                        'rasi': _selectedRasi,
                        'nachathram': _selectedNachathram,
                        'caste': _selectedCaste,
                      },
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: MainContent(
                      isLoading: _isLoading,
                      profiles: _profiles,
                      isMobile: isMobile,
                      onFilterTap: () {}, // Not used on desktop
                      getRandomAvatar: _getRandomAvatar,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class FilterPanel extends StatefulWidget {
  final bool isMobile;
  final ScrollController? scrollController;
  final Function(Map<String, dynamic>) onFilterChanged;
  final Map<String, dynamic> initialFilters;

  const FilterPanel({
    super.key,
    this.isMobile = false,
    this.scrollController,
    required this.onFilterChanged,
    required this.initialFilters,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late RangeValues _ageRange;
  String? _selectedLocation;
  String? _selectedRasi;
  String? _selectedNachathram;
  String? _selectedCaste;

  @override
  void initState() {
    super.initState();
    _ageRange = widget.initialFilters['ageRange'];
    _selectedLocation = widget.initialFilters['location'];
    _selectedRasi = widget.initialFilters['rasi'];
    _selectedNachathram = widget.initialFilters['nachathram'];
    _selectedCaste = widget.initialFilters['caste'];
  }

  void _applyFilters() {
    widget.onFilterChanged({
      'ageRange': _ageRange,
      'location': _selectedLocation,
      'rasi': _selectedRasi,
      'nachathram': _selectedNachathram,
      'caste': _selectedCaste,
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterContent = ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(24),
      children: [
        if (widget.isMobile)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Filters',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textColor,
              ),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Age Range',
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            RangeSlider(
              values: _ageRange,
              min: 18,
              max: 60,
              divisions: 42,
              labels: RangeLabels(
                _ageRange.start.round().toString(),
                _ageRange.end.round().toString(),
              ),
              onChanged: (RangeValues newValues) {
                setState(() {
                  _ageRange = newValues;
                });
              },
              activeColor: AppColors.primary500,
              inactiveColor: AppColors.secondary200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '18',
                  style: AppTextStyles.footerText.copyWith(
                    color: AppColors.secondary600,
                  ),
                ),
                Text(
                  '60',
                  style: AppTextStyles.footerText.copyWith(
                    color: AppColors.secondary600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildFilterDropdown(
          label: 'Location',
          options: ['Any', 'Chennai', 'Coimbatore', 'Madurai'],
          value: _selectedLocation,
          onChanged: (newValue) {
            setState(() {
              _selectedLocation = newValue;
            });
          },
        ),
        const SizedBox(height: 24),
        _buildFilterDropdown(
          label: 'Rasi',
          options: [
            'Any',
            'மேஷம்',
            'ரிஷபம்',
            'மிதுனம்',
            'கடகம்',
            'சிம்மம்',
            'கன்னி',
            'துலாம்',
            'விருச்சிகம்',
            'தனுசு',
            'மகரம்',
            'கும்பம்',
            'மீனம்',
          ],
          value: _selectedRasi,
          onChanged: (newValue) {
            setState(() {
              _selectedRasi = newValue;
            });
          },
        ),
        const SizedBox(height: 24),
        _buildFilterDropdown(
          label: 'Nachathram',
          options: [
            'Any',
            'அஸ்வினி',
            'பரணி',
            'கார்த்திகை - 1ம் பாதம்',
            'கார்த்திகை - 2ம் பாதம்',
            'கார்த்திகை - 3ம் பாதம்',
            'கார்த்திகை - 4ம் பாதம்',
            'ரோகிணி',
            'மிருகசீரிடம் - 1ம் பாதம்',
            'மிருகசீரிடம் - 2ம் பாதம்',
            'மிருகசீரிடம் - 3ம் பாதம்',
            'மிருகசீரிடம் - 4ம் பாதம்',
            'திருவாதிரை',
            'புனர்பூசம் - 1ம் பாதம்',
            'புனர்பூசம் - 2ம் பாதம்',
            'புனர்பூசம் - 3ம் பாதம்',
            'புனர்பூசம் - 4ம் பாதம்',
            'பூசம்',
            'ஆயிலியம்',
            'மகம்',
            'பூரம்',
            'உத்தரம் - 1ம் பாதம்',
            'உத்தரம் - 2ம் பாதம்',
            'உத்தரம் - 3ம் பாதம்',
            'உத்தரம் - 4ம் பாதம்',
            'அஸ்தம்',
            'சித்திரை - 1ம் பாதம்',
            'சித்திரை - 2ம் பாதம்',
            'சித்திரை - 3ம் பாதம்',
            'சித்திரை - 4ம் பாதம்',
            'சுவாதி',
            'விசாகம் - 1ம் பாதம்',
            'விசாகம் - 2ம் பாதம்',
            'விசாகம் - 3ம் பாதம்',
            'விசாகம் - 4ம் பாதம்',
            'அனுஷம்',
            'கேட்டை',
            'மூலம்',
            'பூராடம்',
            'உத்திராடம் - 1ம் பாதம்',
            'உத்திராடம் - 2ம் பாதம்',
            'உத்திராடம் - 3ம் பாதம்',
            'உத்திராடம் - 4ம் பாதம்',
            'திருவோணம்',
            'அவிட்டம் - 1ம் பாதம்',
            'அவிட்டம் - 2ம் பாதம்',
            'அவிட்டம் - 3ம் பாதம்',
            'அவிட்டம் - 4ம் பாதம்',
            'சதயம்',
            'பூரட்டாதி - 1ம் பாதம்',
            'பூரட்டாதி - 2ம் பாதம்',
            'பூரட்டாதி - 3ம் பாதம்',
            'பூரட்டாதி - 4ம் பாதம்',
            'உத்திரட்டாதி',
            'ரேவதி',
          ],
          value: _selectedNachathram,
          onChanged: (newValue) {
            setState(() {
              _selectedNachathram = newValue;
            });
          },
        ),
        const SizedBox(height: 24),
        _buildFilterDropdown(
          label: 'Caste',
          options: [
            'Any',
            'Kongu Nadu',
            'Aaru Nadu',
            'Poonthurai Nadu',
            'Kilangu Nadu',
            'Thattaiya Nadu',
            'Kaangaya Nadu',
            'Kuruppa Nadu',
            'Vengala Nadu',
            'Thenkarasai Nadu',
            'Arayya Nadu',
            'Kanjikovil Nadu',
            'Thalaya Nadu',
            'Kamsala Nadu',
            'Ponkulukki Nadu',
            'Varakka Nadu',
            'Anda Nadu',
            'Morur Nadu',
            'Rasipura Nadu',
            'Valavanthi Nadu',
            'Vaiyaburi Nadu',
            'Kaanji Oduvanga Nadu',
            'Vellaar Nadu',
            'Nallurukku Nadu',
            'Kaavadikka Nadu',
            'Thennarasu Nadu',
            'Poovaani Nadu',
            'Naraya Nadu',
            'Vadakarai Nadu',
            'ParuthiPalli Nadu',
            'Telugu Kulalar',
            'Other',
          ],
          value: _selectedCaste,
          onChanged: (newValue) {
            setState(() {
              _selectedCaste = newValue;
            });
          },
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: AppTextStyles.buttonText.copyWith(fontSize: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: const Text('Apply Filters'),
          ),
        ),
      ],
    );

    if (widget.isMobile) {
      return filterContent;
    }

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.secondary200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: filterContent,
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required List<String> options,
    String? value,
    void Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.secondary50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary500,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          value: value ?? options.first,
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textColor,
                ),
              ),
            );
          }).toList(),
          iconEnabledColor: AppColors.secondary600,
          dropdownColor: Colors.white,
          style: AppTextStyles.bodyText.copyWith(color: AppColors.secondary700),
        ),
      ],
    );
  }
}

class MainContent extends StatelessWidget {
  final bool isLoading;
  final List<Profile> profiles;
  final bool isMobile;
  final VoidCallback onFilterTap;
  final String Function(String?) getRandomAvatar;

  const MainContent({
    super.key,
    required this.isLoading,
    required this.profiles,
    required this.isMobile,
    required this.onFilterTap,
    required this.getRandomAvatar,
  });

  @override
  Widget build(BuildContext context) {
    print(
      "Building MainContent: isLoading: $isLoading, profile count: ${profiles.length}",
    ); // Debug: Check build state
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${profiles.length} results',
                style: AppTextStyles.bodyText,
              ),
              if (isMobile)
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: onFilterTap,
                ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (profiles.isEmpty) {
                return const Center(child: Text('No profiles found.'));
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : 3,
                    crossAxisSpacing: isMobile ? 16 : 24,
                    mainAxisSpacing: isMobile ? 16 : 24,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return ProfileCard(
                      profile: profile,
                      getRandomAvatar: getRandomAvatar,
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final String Function(String?) getRandomAvatar;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.getRandomAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image.asset(
      getRandomAvatar(profile.gender),
      fit: BoxFit.cover,
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final user = Supabase.instance.client.auth.currentUser;
          if (user == null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Authentication Required'),
                content: const Text(
                  'Please log in or register to view profiles.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(AppRoutes.login);
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            );
          } else {
            // Check approval status
            try {
              final data = await Supabase.instance.client
                  .from('profiles')
                  .select('approval_status')
                  .eq('id', user.id)
                  .single();

              if (data['approval_status'] == 'pending_approval') {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Approval Pending'),
                      content: const Text(
                        'Waiting for the approval and upload Jathagam pdf',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
                return;
              }
            } catch (e) {
              // Handle error silently or log it
              print('Error checking approval status: $e');
            }

            if (context.mounted) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(AppRoutes.profileView, arguments: profile);
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: imageWidget, // Use the determined image widget
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.name}, ${profile.age ?? 'N/A'}',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.textColor,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile.occupation ?? 'N/A'}, ${profile.city ?? 'N/A'}',
                    style: AppTextStyles.cardSubtitle.copyWith(
                      color: AppColors.secondary600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
