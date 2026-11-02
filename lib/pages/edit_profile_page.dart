import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/l10n/app_localizations.dart';
import 'package:my_web_project/main.dart'; // For AppRoutes and Profile model
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Import for DateFormat

class EditProfilePage extends StatefulWidget {
  final Profile? userProfile; // Accept Profile object

  const EditProfilePage({super.key, this.userProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emailController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _birthTimeController;
  late String? _selectedGender;
  late String? _selectedAccountType;
  late String? _selectedRasi;
  late String? _selectedNachathram;
  late String? _selectedDosham;
  late String? _selectedMotherTongue;
  late TextEditingController _educationController;
  late TextEditingController _occupationController;
  late TextEditingController _cityController;
  late TextEditingController _aboutMeController;

  late AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data or empty strings
    _nameController = TextEditingController(
      text: widget.userProfile?.name ?? '',
    );
    _mobileNumberController = TextEditingController(
      text: widget.userProfile?.mobileNumber ?? '',
    );
    _emailController = TextEditingController(
      text: widget.userProfile?.email ?? '',
    );
    _dateOfBirthController = TextEditingController(
      text: widget.userProfile?.dateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(widget.userProfile!.dateOfBirth!)
          : '',
    );
    _birthTimeController = TextEditingController(
      text: widget.userProfile?.dateOfBirth != null
          ? DateFormat.jm().format(widget.userProfile!.dateOfBirth!)
          : '',
    );
    _selectedGender = widget.userProfile?.gender;
    _selectedAccountType = widget.userProfile?.accountType;
    _selectedRasi = widget.userProfile?.rasi;
    _selectedNachathram = widget.userProfile?.nachathram;
    _selectedDosham = widget.userProfile?.dosham;
    _selectedMotherTongue = widget.userProfile?.motherTongue;
    _educationController = TextEditingController(
      text: widget.userProfile?.education ?? '',
    );
    _occupationController = TextEditingController(
      text: widget.userProfile?.occupation ?? '',
    );
    _cityController = TextEditingController(
      text: widget.userProfile?.city ?? '',
    );
    _aboutMeController = TextEditingController(
      text: widget.userProfile?.aboutMe ?? '',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appLocalizations = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _birthTimeController.dispose();
    _educationController.dispose();
    _occupationController.dispose();
    _cityController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final String? userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        // Using a generic message as 'loginRequired' is not in the .arb files
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You must be logged in to update your profile."),
          ),
        );
        return;
      }

      // Combine date and time
      final date = _dateOfBirthController.text.trim();
      final time = _birthTimeController.text.trim();
      String? isoDateTime;
      if (date.isNotEmpty && time.isNotEmpty) {
        try {
          final timeFormat = DateFormat.jm(); // e.g., 5:08 PM
          final parsedTime = timeFormat.parse(time);
          final combinedDateTime = DateTime.parse(
            date,
          ).add(Duration(hours: parsedTime.hour, minutes: parsedTime.minute));
          isoDateTime = combinedDateTime.toIso8601String();
        } catch (e) {
          // Handle parsing error if necessary
          print('Error parsing date/time: $e');
        }
      }

      await Supabase.instance.client.from('profiles').upsert({
        'id': userId,
        'full_name': _nameController.text.trim(),
        'mobile_number': _mobileNumberController.text.trim(),
        'email': _emailController.text.trim(),
        'date_of_birth': isoDateTime,
        'gender': _selectedGender,
        'account_type': _selectedAccountType,
        'rasi': _selectedRasi,
        'nachathram': _selectedNachathram,
        'dosham': _selectedDosham,
        'mother_tongue': _selectedMotherTongue,
        'highest_education': _educationController.text.trim(),
        'occupation': _occupationController.text.trim(),
        'city': _cityController.text.trim(),
        'about_me': _aboutMeController.text.trim(),
        // Add other fields as necessary
      });

      if (mounted) {
        // Using a generic message as 'profileUpdatedSuccessfully' is not in the .arb files
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        Navigator.of(context).pop(); // Go back to dashboard
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An unexpected error occurred: ${e.toString()}"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.editProfile),
        backgroundColor: AppColors.secondary50,
        foregroundColor: AppColors.textColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations.personalInformation,
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.name,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalizations.enterFullName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mobile Number
                  TextFormField(
                    controller: _mobileNumberController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.mobileNumber,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalizations.enterMobileNumber;
                      }
                      if (value.length < 10) {
                        // Using a generic message as 'pleaseEnterValidMobileNumber' is not in the .arb files
                        return "Please enter a valid 10-digit mobile number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.emailAddress,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // THIS IS THE FIX: Using the correct key
                        return "Please enter a valid email address";
                      }
                      // Basic email validation
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        // THIS IS THE FIX: Using a simple string as the other key is missing
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth
                  TextFormField(
                    controller: _dateOfBirthController,
                    readOnly:
                        true, // Keep read-only, but editable via date picker
                    decoration: InputDecoration(
                      labelText: appLocalizations.dateOfBirth,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dateOfBirthController.text =
                                  '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Using a generic message as 'pleaseSelectDateOfBirth' is not in the .arb files
                        return "Please select your date of birth";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Birth Time
                  TextFormField(
                    controller: _birthTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Time of Birth',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _birthTimeController.text = pickedTime.format(
                                context,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your time of birth';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: appLocalizations.gender,
                      border: const OutlineInputBorder(),
                    ),
                    items: <String>['bride', 'groom'].map((String value) {
                      // FIX: Changed options to match database values
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value == 'bride' ? 'Bride' : 'Groom',
                        ), // Display user-friendly text
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Using a generic message as 'pleaseSelectGender' is not in the .arb files
                        return "Please select your gender";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Account Type
                  DropdownButtonFormField<String>(
                    value: _selectedAccountType,
                    decoration: InputDecoration(
                      labelText: appLocalizations.accountType,
                      border: const OutlineInputBorder(),
                    ),
                    items: <String>['individual', 'family', 'agent'].map((
                      String value,
                    ) {
                      // FIX: Changed options to match database values
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value[0].toUpperCase() + value.substring(1),
                        ), // Corrected syntax
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAccountType = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Using a generic message as 'pleaseSelectAccountType' is not in the .arb files
                        return "Please select an account type";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Rasi
                  DropdownButtonFormField<String>(
                    value: _selectedRasi,
                    decoration: const InputDecoration(
                      labelText: 'Rasi', // appLocalizations.rasi
                      border: OutlineInputBorder(),
                    ),
                    items:
                        <String>[
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
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRasi = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select your Rasi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Nachathram
                  DropdownButtonFormField<String>(
                    value: _selectedNachathram,
                    decoration: const InputDecoration(
                      labelText: 'Nachathram', // appLocalizations.nachathram
                      border: OutlineInputBorder(),
                    ),
                    items:
                        <String>[
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
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedNachathram = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select your Nachathram";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dosham
                  DropdownButtonFormField<String>(
                    value: _selectedDosham,
                    decoration: const InputDecoration(
                      labelText: 'Dosham',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        <String>[
                          'செவ்வாய் தோஷம்',
                          'ராகு கேது தோஷம்',
                          'தோஷம் இல்லை',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDosham = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select your Dosham";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mother Tongue
                  DropdownButtonFormField<String>(
                    value: _selectedMotherTongue,
                    decoration: InputDecoration(
                      labelText: appLocalizations.motherTongue,
                      border: const OutlineInputBorder(),
                    ),
                    items:
                        <String>[
                          'Tamil',
                          'Telugu',
                          'Malayalam',
                          'Kannada',
                          'Hindi',
                          'English',
                          'Other',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMotherTongue = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Using a generic message as 'pleaseSelectMotherTongue' is not in the .arb files
                        return "Please select your mother tongue";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Education
                  TextFormField(
                    controller: _educationController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.highestEducation,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Using a generic message as 'pleaseEnterEducation' is not in the .arb files
                        return "Please enter your highest education";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Occupation
                  TextFormField(
                    controller: _occupationController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.occupation,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Using a generic message as 'pleaseEnterOccupation' is not in the .arb files
                        return "Please enter your occupation";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // City
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      // Using a generic message as 'city' is not in the .arb files
                      labelText: "City",
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Using a generic message as 'pleaseEnterCity' is not in the .arb files
                        return "Please enter your city";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // About Me
                  TextFormField(
                    controller: _aboutMeController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: appLocalizations.aboutMe,
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: AppTextStyles.buttonText,
                      ),
                      // Using a generic message as 'saveChanges' is not in the .arb files
                      child: const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
