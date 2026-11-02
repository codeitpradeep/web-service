import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_web_project/data/locations.dart';
import 'package:my_web_project/main.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/widgets/app_header.dart'; // Import AppHeader
import 'package:my_web_project/responsive_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:my_web_project/services/cloudinary_service.dart';
import 'package:file_picker/file_picker.dart';

class CreateEditProfilePage extends StatefulWidget {
  final Profile? userProfile; // Accept a Profile object

  const CreateEditProfilePage({super.key, this.userProfile});

  @override
  State<CreateEditProfilePage> createState() => _CreateEditProfilePageState();
}

class _CreateEditProfilePageState extends State<CreateEditProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSaving = false; // Add a state for saving
  final List<String> _tabs = const [
    'Personal Info',
    'Education/Career',
    'Family',
    'Preferences',
    'Photo Uploads',
  ];

  // Create controllers for the form fields
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _birthTimeController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutMeController = TextEditingController();
  final _highestEducationController = TextEditingController();
  final _occupationController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _fathersOccupationController = TextEditingController();
  final _mothersOccupationController = TextEditingController();
  final _numberOfSiblingsController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  // Variables for dropdowns
  String? _selectedGender;
  String? _selectedRasi;
  String? _selectedNachathram;
  String? _selectedDosham;
  String? _selectedMotherTongue;
  String? _selectedCaste;
  String? _selectedMaritalStatus;
  String? _selectedAnnualIncome;
  String? _selectedFamilyValues;
  String? _selectedDistrict;
  List<String> _cities = [];

  // Uploads
  String? _uploadedProfilePictureUrl;
  String? _uploadedHoroscopeUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // Pre-fill the controllers if a profile is provided
    if (widget.userProfile != null) {
      final profile = widget.userProfile!;
      _nameController.text = profile.name;
      if (profile.dateOfBirth != null) {
        // Use DateFormat for reliable formatting
        _dobController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(profile.dateOfBirth!);
        _birthTimeController.text = DateFormat.jm().format(
          profile.dateOfBirth!,
        );
      }
      _contactController.text = profile.mobileNumber ?? '';
      _emailController.text = profile.email ?? '';
      _aboutMeController.text = profile.aboutMe ?? '';
      _highestEducationController.text = profile.highestEducation ?? '';
      _occupationController.text = profile.occupation ?? '';
      _companyNameController.text = profile.companyName ?? '';
      _fathersOccupationController.text = profile.fathersOccupation ?? '';
      _mothersOccupationController.text = profile.mothersOccupation ?? '';
      _numberOfSiblingsController.text =
          profile.numberOfSiblings?.toString() ?? '';
      _countryController.text = profile.country ?? '';
      _stateController.text = profile.state ?? '';

      // Handle city and district
      if (profile.city != null && profile.city!.contains(',')) {
        final parts = profile.city!.split(',');
        final city = parts[0].trim();
        final district = parts[1].trim();

        _selectedDistrict = district;
        if (tamilNaduDistricts.containsKey(_selectedDistrict)) {
          _cities = tamilNaduDistricts[_selectedDistrict]!;
        }
        _cityController.text = city;
      } else {
        // Fallback for old data that might not have district
        _cityController.text = profile.city ?? '';
      }

      // Set initial values for dropdowns
      _selectedGender = profile.gender;
      _selectedRasi = profile.rasi;
      _selectedNachathram = profile.nachathram;
      _selectedDosham = profile.dosham;
      _selectedMotherTongue = profile.motherTongue;
      _selectedCaste = profile.caste;
      _selectedMaritalStatus = profile.maritalStatus;
      _selectedAnnualIncome = profile.annualIncome;
      _selectedFamilyValues = profile.familyValues;
      _uploadedProfilePictureUrl = profile.profilePicture;
      _uploadedHoroscopeUrl = profile.horoscopeUrl;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _aboutMeController.dispose();
    _highestEducationController.dispose();
    _occupationController.dispose();
    _companyNameController.dispose();
    _fathersOccupationController.dispose();
    _mothersOccupationController.dispose();
    _numberOfSiblingsController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    // Determine the correct profile ID to update.
    final String? profileIdToUpdate;

    if (widget.userProfile != null) {
      // If a profile object was passed (e.g. from Admin Panel or Dashboard),
      // we MUST use its ID. If it's null, that's a data error.
      profileIdToUpdate = widget.userProfile!.id;
      if (profileIdToUpdate == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Error: Cannot update profile. Missing Profile ID.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    } else {
      // Only fall back to current user if NO profile was passed.
      // This handles cases where the page is opened without arguments (if any).
      profileIdToUpdate = Supabase.instance.client.auth.currentUser?.id;
    }

    if (profileIdToUpdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not determine profile to update. Please log in.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Combine date and time
      DateTime? dateOfBirth;
      if (_dobController.text.isNotEmpty &&
          _birthTimeController.text.isNotEmpty) {
        try {
          final date = DateTime.parse(_dobController.text);
          final time = DateFormat.jm().parse(_birthTimeController.text);
          dateOfBirth = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        } catch (e) {
          // Handle parsing error if necessary
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid date or time format: $e')),
            );
          }
          return; // Stop saving if format is wrong
        }
      }

      final city = _cityController.text;
      final district = _selectedDistrict;
      final cityWithDistrict = (city.isNotEmpty && district != null)
          ? '$city, $district'
          : city;

      await Supabase.instance.client
          .from('profiles')
          .update({
            'full_name': _nameController.text,
            'date_of_birth': dateOfBirth?.toIso8601String(),
            'email': _emailController.text,
            'gender': _selectedGender,
            'rasi': _selectedRasi,
            'nachathram': _selectedNachathram,
            'dosham': _selectedDosham,
            'mother_tongue': _selectedMotherTongue,
            'caste': _selectedCaste,
            'about_me': _aboutMeController.text,
            'highest_education': _highestEducationController.text,
            'marital_status': _selectedMaritalStatus,
            'country': _countryController.text,
            'state': _stateController.text,
            'city': cityWithDistrict,
            'occupation': _occupationController.text,
            'company_name': _companyNameController.text,
            'annual_income': _selectedAnnualIncome,
            'fathers_occupation': _fathersOccupationController.text,
            'mothers_occupation': _mothersOccupationController.text,
            'number_of_siblings': int.tryParse(
              _numberOfSiblingsController.text,
            ),
            'family_values': _selectedFamilyValues,
            // 'approval_status': 'pending_approval', // Prevent resetting status to pending on edit
            'profile_picture': _uploadedProfilePictureUrl,
            'horoscope_url': _uploadedHoroscopeUrl,
          })
          .eq('id', profileIdToUpdate);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
        Navigator.of(context).pop(true); // Go back and indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        isLoggedIn: true,
        navLinks: const ['My Profile'],
        onProfilePressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.dashboard,
          (route) => false,
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 960), // max-w-4xl
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Page Title and Subtitle
              Text(
                'Edit Your Profile',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Keep your details up-to-date to find your perfect match.',
                style: AppTextStyles.sectionSubtitle.copyWith(
                  color: AppColors.secondary700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Tab Navigation
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.secondary200),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.primary500,
                  unselectedLabelColor: AppColors.secondary700,
                  indicatorColor: AppColors.primary500,
                  indicatorWeight: 2.0,
                  labelStyle: AppTextStyles.navLink.copyWith(fontSize: 14),
                  tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                  onTap: (index) {
                    _tabController.animateTo(index);
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Form Content Card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(child: _buildPersonalInfoForm()),
                      SingleChildScrollView(child: _buildEducationCareerForm()),
                      SingleChildScrollView(child: _buildFamilyForm()),
                      SingleChildScrollView(child: _buildPreferencesForm()),
                      SingleChildScrollView(child: _buildPhotoUploadsForm()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ResponsiveLayout.isMobile(context)
          ? BottomAppBar(
              color: AppColors.secondary100,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Dashboard'),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.dashboard,
                        (route) => false,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        foregroundColor: Colors.white,
                        textStyle: AppTextStyles.buttonText,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildPersonalInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'Name',
          hintText: 'Enter your full name',
          obscureText: false,
          keyboardType: TextInputType.name,
          controller: _nameController,
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              direction: constraints.maxWidth > 768
                  ? Axis.horizontal
                  : Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _buildDropdownField(
                    label: 'Gender',
                    options: ['Select your gender', 'bride', 'groom'],
                    value: _selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 24, height: 24),
                Flexible(
                  child: _buildInputField(
                    label: 'Date of Birth',
                    hintText: 'Select your date of birth',
                    obscureText: false,
                    keyboardType: TextInputType.datetime,
                    controller: _dobController,
                    onTap: () async {
                      DateTime initialDate = DateTime.now();
                      if (_dobController.text.isNotEmpty) {
                        try {
                          initialDate = DateTime.parse(_dobController.text);
                        } catch (e) {
                          // Keep default if parsing fails
                        }
                      }

                      final date = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        _dobController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(date);
                      }
                    },
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 24, height: 24),
                Flexible(
                  child: _buildInputField(
                    label: 'Birth Time',
                    hintText: 'Select your birth time',
                    obscureText: false,
                    keyboardType: TextInputType.datetime,
                    controller: _birthTimeController,
                    onTap: () async {
                      TimeOfDay initialTime = TimeOfDay.now();
                      if (_birthTimeController.text.isNotEmpty) {
                        try {
                          final parsedTime = DateFormat.jm().parse(
                            _birthTimeController.text,
                          );
                          initialTime = TimeOfDay.fromDateTime(parsedTime);
                        } catch (e) {
                          // Keep default if parsing fails
                        }
                      }

                      final time = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );
                      if (time != null) {
                        // ignore: use_build_context_synchronously
                        _birthTimeController.text = time.format(context);
                      }
                    },
                    readOnly: true,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'About Me',
          hintText: 'Write a little about yourself...',
          obscureText: false,
          keyboardType: TextInputType.multiline,
          controller: _aboutMeController,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        _buildDropdownField(
          label: 'Marital Status',
          options: [
            'Select your marital status',
            'Never Married',
            'Divorced',
            'Widowed',
            'Awaiting Divorce',
          ],
          value: _selectedMaritalStatus,
          onChanged: (newValue) {
            setState(() {
              _selectedMaritalStatus = newValue;
            });
          },
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              direction: constraints.maxWidth > 768
                  ? Axis.horizontal
                  : Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _buildDropdownField(
                    label: 'Mother Tongue',
                    options: [
                      'Select your mother tongue',
                      'Tamil',
                      'Telugu',
                      'Kannada',
                    ],
                    value: _selectedMotherTongue,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMotherTongue = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 24, height: 24),
                Flexible(
                  child: _buildDropdownField(
                    label: 'Rasi',
                    options: [
                      'Select Rasi',
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
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _buildDropdownField(
          label: 'Nachathiram',
          options: [
            'Select Nachathiram',
            'அஸ்வினி', //yes
            'பரணி', //yes
            'கார்த்திகை 1ம் பாதம்',
            'கார்த்திகை 2ம் பாதம்',
            'கார்த்திகை 3ம் பாதம்',
            'கார்த்திகை 4ம் பாதம்', //yes
            'ரோகிணி', //yes
            'மிருகசீரிடம் 1ம் பாதம்',
            'மிருகசீரிடம் 2ம் பாதம்',
            'மிருகசீரிடம் 3ம் பாதம்',
            'மிருகசீரிடம் 4ம் பாதம்', //yes
            'திருவாதிரை', //yes
            'புனர்பூசம் 1ம் பாதம்',
            'புனர்பூசம் 2ம் பாதம்',
            'புனர்பூசம் 3ம் பாதம்',
            'புனர்பூசம் 4ம் பாதம்', // yes
            'பூசம்',
            'ஆயிலியம்',
            'மகம்',
            'பூரம்',
            'உத்தரம் 1ம் பாதம்',
            'உத்தரம் 2ம் பாதம்',
            'உத்தரம் 3ம் பாதம்',
            'உத்தரம் 4ம் பாதம்', //yes
            'அஸ்தம்',
            'சித்திரை 1ம் பாதம்',
            'சித்திரை 2ம் பாதம்',
            'சித்திரை 3ம் பாதம்',
            'சித்திரை 4ம் பாதம்', //yes
            'சுவாதி', //yes
            'விசாகம் 1ம் பாதம்',
            'விசாகம் 2ம் பாதம்',
            'விசாகம் 3ம் பாதம்',
            'விசாகம் 4ம் பாதம்', //no
            'அனுஷம்', //no
            'கேட்டை', //no
            'மூலம்', //no
            'பூராடம்', //no
            'உத்திராடம் 1ம் பாதம்',
            'உத்திராடம் 2ம் பாதம்',
            'உத்திராடம் 3ம் பாதம்',
            'உத்திராடம் 4ம் பாதம்',
            'திருவோணம்',
            'அவிட்டம் 1ம் பாதம்',
            'அவிட்டம் 2ம் பாதம்',
            'அவிட்டம் 3ம் பாதம்',
            'அவிட்டம் 4ம் பாதம்',
            'சதயம்',
            'பூரட்டாதி 1ம் பாதம்',
            'பூரட்டாதி 2ம் பாதம்',
            'பூரட்டாதி 3ம் பாதம்',
            'பூரட்டாதி 4ம் பாதம்',
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
        _buildDropdownField(
          label: 'Dosham',
          options: [
            'Select Dosham',
            'செவ்வாய் தோஷம்',
            'ராகு கேது தோஷம்',
            'தோஷம் இல்லை',
          ],
          value: _selectedDosham,
          onChanged: (newValue) {
            setState(() {
              _selectedDosham = newValue;
            });
          },
        ),
        const SizedBox(height: 24),
        _buildDropdownField(
          label: 'Caste/Community',
          options: [
            'Select your caste/community',
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
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Country',
          hintText: 'Enter your country',
          obscureText: false,
          keyboardType: TextInputType.text,
          controller: _countryController,
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              direction: constraints.maxWidth > 768
                  ? Axis.horizontal
                  : Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _buildInputField(
                    label: 'State',
                    hintText: 'Enter your state',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    controller: _stateController,
                  ),
                ),
                const SizedBox(width: 24, height: 24),
                Flexible(
                  child: _buildDropdownField(
                    label: 'City', // User wants this first
                    options: ['Select City', ...tamilNaduDistricts.keys],
                    value: _selectedDistrict,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDistrict = newValue;
                        _cities = tamilNaduDistricts[newValue] ?? [];
                        _cityController
                            .clear(); // Clear city when district changes
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _buildDropdownField(
          label: 'District', // User wants this second, it shows cities
          options: ['Select District', ..._cities],
          value: _cities.contains(_cityController.text)
              ? _cityController.text
              : null,
          onChanged: (newValue) {
            setState(() {
              _cityController.text = newValue ?? '';
            });
          },
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Contact Number (Read Only)',
          hintText: 'Enter your contact number',
          obscureText: false,
          keyboardType: TextInputType.phone,
          controller: _contactController,
          readOnly: true, // Make it read-only
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Email Address',
          hintText: 'Enter your email address',
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                _tabController.animateTo(_tabController.index + 1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                textStyle: AppTextStyles.buttonText.copyWith(fontSize: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text('Next: Education/Career'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEducationCareerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'Highest Education',
          hintText: 'e.g., B.E., M.Sc.',
          obscureText: false,
          keyboardType: TextInputType.text,
          controller: _highestEducationController,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Occupation',
          hintText: 'e.g., Software Engineer, Doctor',
          obscureText: false,
          keyboardType: TextInputType.text,
          controller: _occupationController,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Company Name',
          hintText: 'Enter your company name',
          obscureText: false,
          keyboardType: TextInputType.text,
          controller: _companyNameController,
        ),
        const SizedBox(height: 24),
        _buildDropdownField(
          label: 'Annual Income',
          options: [
            'Select your annual income',
            'Below 1 Lakh',
            '1-2 Lakhs',
            '2-4 Lakhs',
            '4-7 Lakhs',
            '7-10 Lakhs',
            '10-15 Lakhs',
            '15-20 Lakhs',
            '20-30 Lakhs',
            '30-50 Lakhs',
            '50-75 Lakhs',
            '75 Lakhs - 1 Crore',
            'Above 1 Crore',
          ],
          value: _selectedAnnualIncome,
          onChanged: (newValue) {
            setState(() {
              _selectedAnnualIncome = newValue;
            });
          },
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                _tabController.animateTo(_tabController.index - 1);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textColor,
                backgroundColor: AppColors.secondary100,
                textStyle: AppTextStyles.buttonTextSecondary.copyWith(
                  fontSize: 14,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide.none,
              ),
              child: const Text('Previous'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                _tabController.animateTo(_tabController.index + 1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                textStyle: AppTextStyles.buttonText.copyWith(fontSize: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text('Next: Family'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoUploadsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Profile Picture',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              if (_uploadedProfilePictureUrl != null)
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(_uploadedProfilePictureUrl!),
                )
              else
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.secondary200,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isUploading
                    ? null
                    : () async {
                        setState(() => _isUploading = true);
                        final url = await CloudinaryService().pickAndUploadFile(
                          fileType: FileType.image,
                        );
                        setState(() {
                          _isUploading = false;
                          if (url != null) {
                            _uploadedProfilePictureUrl = url;
                          }
                        });
                      },
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload),
                label: Text(_isUploading ? 'Uploading...' : 'Upload Photo'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Upload Horoscope / Dosham (PDF)',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondary200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _uploadedHoroscopeUrl != null
                          ? 'Horoscope Uploaded'
                          : 'No Horoscope Uploaded',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_uploadedHoroscopeUrl != null)
                      Text(
                        'File available',
                        style: AppTextStyles.bodyText.copyWith(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isUploading
                    ? null
                    : () async {
                        setState(() => _isUploading = true);
                        final url = await CloudinaryService().pickAndUploadFile(
                          fileType: FileType.custom,
                          allowedExtensions: ['pdf'], // Only allow PDF
                        );
                        setState(() {
                          _isUploading = false;
                          if (url != null) {
                            _uploadedHoroscopeUrl = url;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Uploaded: $url'),
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        });
                      },
                child: Text(
                  _uploadedHoroscopeUrl != null ? 'Change' : 'Upload',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                _tabController.animateTo(_tabController.index - 1);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textColor,
                backgroundColor: AppColors.secondary100,
                textStyle: AppTextStyles.buttonTextSecondary.copyWith(
                  fontSize: 14,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide.none,
              ),
              child: const Text('Previous'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _isSaving
                  ? null
                  : _saveProfile, // Disable button when saving
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                textStyle: AppTextStyles.buttonText.copyWith(fontSize: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Save Profile'),
            ),
          ],
        ),
      ],
    );
  }

  // Placeholder for other forms - replace with your actual form widgets
  Widget _buildFamilyForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInputField(
        label: "Father's Occupation",
        hintText: "Enter father's occupation",
        obscureText: false,
        keyboardType: TextInputType.text,
        controller: _fathersOccupationController,
      ),
      const SizedBox(height: 24),
      _buildInputField(
        label: "Mother's Occupation",
        hintText: "Enter mother's occupation",
        obscureText: false,
        keyboardType: TextInputType.text,
        controller: _mothersOccupationController,
      ),
      const SizedBox(height: 24),
      _buildInputField(
        label: 'Number of Siblings',
        hintText: 'Enter number of siblings',
        obscureText: false,
        keyboardType: TextInputType.number,
        controller: _numberOfSiblingsController,
      ),
      const SizedBox(height: 24),
      _buildDropdownField(
        label: 'Family Values',
        options: [
          'Select family values',
          'Orthodox',
          'Traditional',
          'Moderate',
          'Liberal',
        ],
        value: _selectedFamilyValues,
        onChanged: (newValue) {
          setState(() {
            _selectedFamilyValues = newValue;
          });
        },
      ),
      const SizedBox(height: 32),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () {
              _tabController.animateTo(_tabController.index - 1);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textColor,
              backgroundColor: AppColors.secondary100,
              textStyle: AppTextStyles.buttonTextSecondary.copyWith(
                fontSize: 14,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide.none,
            ),
            child: const Text('Previous'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              _tabController.animateTo(_tabController.index + 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: Colors.white,
              textStyle: AppTextStyles.buttonText.copyWith(fontSize: 14),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: const Text('Next: Preferences'),
          ),
        ],
      ),
    ],
  );
  Widget _buildPreferencesForm() =>
      const Center(child: Text("Preferences form goes here"));

  Widget _buildInputField({
    required String label,
    required String hintText,
    required bool obscureText,
    required TextInputType keyboardType,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyText.copyWith(
              color: AppColors.secondary600,
            ),
            filled: true,
            fillColor: readOnly
                ? AppColors.secondary200
                : AppColors.secondary50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary500,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> options,
    String? value,
    void Function(String?)? onChanged,
  }) {
    // The first option is the placeholder.
    final String placeholder = options.first;
    // The actual items for the dropdown.
    final List<String> items = options.sublist(1);

    // If the current value is not in the list of valid items, it should be null.
    // This prevents a crash if the value is the placeholder or some other invalid string.
    final String? currentValue = items.contains(value) ? value : null;

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
            hintText: placeholder, // Use the placeholder as a hint.
            filled: true,
            fillColor: AppColors.secondary50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary500,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
          value: currentValue,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String itemValue) {
            return DropdownMenuItem<String>(
              value: itemValue,
              child: Text(
                itemValue,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textColor,
                ),
              ),
            );
          }).toList(),
          iconEnabledColor: AppColors.secondary700,
          dropdownColor: Colors.white,
          style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
        ),
      ],
    );
  }
}
