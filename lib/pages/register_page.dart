import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:my_web_project/data/locations.dart';
import 'package:my_web_project/theme.dart';
import 'package:flutter/gestures.dart'; // Import TapGestureRecognizer
import 'package:my_web_project/widgets/loading_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:bcrypt/bcrypt.dart'; // Import bcrypt

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _birthTimeController = TextEditingController();
  final _cityController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier<bool>(true);
  bool _isLoading = false;

  String _selectedGender =
      ''; // Changed to non-nullable with default empty string
  String _selectedAccountType =
      ''; // Changed to non-nullable with default empty string
  String? _selectedRasi;
  String? _selectedNachathram;
  String? _selectedDosham;
  String? _selectedMotherTongue; // Added for dropdown state
  String? _selectedDistrict;
  List<String> _cities = [];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _dateOfBirthController.dispose();
    _birthTimeController.dispose();
    _cityController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 768), // max-w-3xl
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Page Title and Subtitle
                    Text(
                      'Create your Profile',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.textColor,
                      ), // text-3xl font-bold tracking-tight sm:text-4xl
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join the largest Tiruppur Kulalar matrimonial service and find your perfect match.',
                      style: AppTextStyles.sectionSubtitle.copyWith(
                        color: AppColors.secondary700,
                      ), // mt-2 text-sm text-[var(--text-secondary)]
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Registration Form Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16), // rounded-2xl
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 5), // shadow-lg
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.secondary200,
                        ), // border border-[var(--border-color)]
                      ),
                      padding: const EdgeInsets.all(32), // p-8
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This profile is for a',
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w500,
                            ), // block text-sm font-medium text-[var(--text-primary)] mb-2
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                child: _buildRadioTile(
                                  context,
                                  value: 'bride',
                                  groupValue:
                                      _selectedGender, // Use state variable
                                  label: 'Bride',
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedGender = newValue!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16), // gap-4
                              Flexible(
                                child: _buildRadioTile(
                                  context,
                                  value: 'groom',
                                  groupValue:
                                      _selectedGender, // Use state variable
                                  label: 'Groom',
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedGender = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Text(
                            'Account Type',
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: constraints.maxWidth > 600
                                    ? Axis.horizontal
                                    : Axis.vertical, // sm:grid-cols-3
                                mainAxisSize: MainAxisSize
                                    .min, // Added to allow shrink-wrapping
                                children: [
                                  Flexible(
                                    child: _buildRadioTile(
                                      context,
                                      value: 'individual',
                                      groupValue:
                                          _selectedAccountType, // Use state variable
                                      label: 'Individual',
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedAccountType = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16, height: 16),
                                  Flexible(
                                    child: _buildRadioTile(
                                      context,
                                      value: 'family',
                                      groupValue:
                                          _selectedAccountType, // Use state variable
                                      label: 'Family',
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedAccountType = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16, height: 16),
                                  Flexible(
                                    child: _buildRadioTile(
                                      context,
                                      value: 'agent',
                                      groupValue:
                                          _selectedAccountType, // Use state variable
                                      label: 'Agent',
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedAccountType = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 32),
                          const Divider(
                            color: AppColors.secondary200,
                          ), // border-t border-[var(--border-color)] my-6
                          const SizedBox(height: 32),

                          Text(
                            'Personal Information',
                            style: AppTextStyles.cardTitle.copyWith(
                              fontWeight: FontWeight.w600,
                            ), // text-lg font-semibold
                          ),
                          const SizedBox(height: 24), // gap-6
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: constraints.maxWidth > 768
                                    ? Axis.horizontal
                                    : Axis.vertical, // md:grid-cols-2
                                mainAxisSize: MainAxisSize
                                    .min, // Added to allow shrink-wrapping
                                children: [
                                  Flexible(
                                    child: _buildInputField(
                                      label: 'Name',
                                      hintText: 'Enter full name',
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      controller: _nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field cannot be empty';
                                        }
                                        return null;
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
                                      controller: _dateOfBirthController,
                                      onTap: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (date != null) {
                                          _dateOfBirthController.text = date
                                              .toIso8601String()
                                              .split('T')
                                              .first;
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field cannot be empty';
                                        }
                                        return null;
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
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        if (time != null) {
                                          // ignore: use_build_context_synchronously
                                          _birthTimeController.text = time
                                              .format(context);
                                        }
                                      },
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24), // gap-6
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: constraints.maxWidth > 768
                                    ? Axis.horizontal
                                    : Axis.vertical, // md:grid-cols-2
                                mainAxisSize: MainAxisSize
                                    .min, // Added to allow shrink-wrapping
                                children: [
                                  Flexible(
                                    child: _buildDropdownField(
                                      label: 'Mother Tongue',
                                      options: [
                                        'Select Mother Tongue',
                                        'Tamil',
                                        'Telugu',
                                        'Malayalam',
                                        'Kannada',
                                        'Hindi',
                                        'English',
                                      ],
                                      value: _selectedMotherTongue,
                                      onChanged: (String? newValue) {
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
                                      onChanged: (String? newValue) {
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
                          const SizedBox(height: 24), // gap-6
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
                            onChanged: (String? newValue) {
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
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDosham = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildDropdownField(
                            label: 'City',
                            options: [
                              'Select City',
                              ...tamilNaduDistricts.keys,
                            ],
                            value: _selectedDistrict,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDistrict = newValue;
                                _cities = tamilNaduDistricts[newValue] ?? [];
                                _cityController.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildDropdownField(
                            label: 'District',
                            options: ['Select District', ..._cities],
                            value: _cityController.text.isEmpty
                                ? null
                                : _cities.contains(_cityController.text)
                                ? _cityController.text
                                : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                _cityController.text = newValue ?? '';
                              });
                            },
                          ),
                          const SizedBox(height: 32),
                          const Divider(color: AppColors.secondary200),
                          const SizedBox(height: 32),

                          Text(
                            'Contact Details',
                            style: AppTextStyles.cardTitle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: constraints.maxWidth > 768
                                    ? Axis.horizontal
                                    : Axis.vertical,
                                mainAxisSize: MainAxisSize
                                    .min, // Added to allow shrink-wrapping
                                children: [
                                  Flexible(
                                    child: _buildInputField(
                                      label: 'Email Address',
                                      hintText: 'Enter email address',
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value == null ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 24, height: 24),
                                  Flexible(
                                    child: _buildPhoneInputField(
                                      label: 'Mobile Number',
                                      hintText: 'Enter mobile number',
                                      controller: _mobileController,
                                      validator: (value) {
                                        if (value == null ||
                                            value.length < 10) {
                                          return 'Please enter a valid 10-digit mobile number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 32),
                          const Divider(color: AppColors.secondary200),
                          const SizedBox(height: 32),

                          Text(
                            'Set Password',
                            style: AppTextStyles.cardTitle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: constraints.maxWidth > 768
                                    ? Axis.horizontal
                                    : Axis.vertical,
                                mainAxisSize: MainAxisSize
                                    .min, // Added to allow shrink-wrapping
                                children: [
                                  Flexible(
                                    child: _buildPasswordInputField(
                                      label: 'Create Password',
                                      hintText: 'Enter a strong password',
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a password';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters long';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 24, height: 24),
                                  Flexible(
                                    child: _buildPasswordInputField(
                                      label: 'Confirm Password',
                                      hintText: 'Re-enter your password',
                                      controller: _confirmPasswordController,
                                      obscureText: _obscureConfirmPassword,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a password';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters long';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Register Now Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary500,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ), // py-3
                                textStyle: AppTextStyles.buttonText.copyWith(
                                  fontSize: 16,
                                ), // text-base font-bold
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ), // rounded-lg
                                elevation: 2, // shadow-sm
                              ),
                              child: const Text('Register Now'),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Terms and Privacy Policy
                          Text.rich(
                            TextSpan(
                              text: 'By proceeding, you agree to our ',
                              style: AppTextStyles.footerText.copyWith(
                                fontSize: 12,
                                color: AppColors.secondary700,
                              ), // mt-6 text-center text-xs text-[var(--text-secondary)]
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Terms of Use',
                                  style: AppTextStyles.buttonText.copyWith(
                                    color: AppColors.primary500,
                                    decoration: TextDecoration.underline,
                                  ), // font-medium text-[var(--primary-color)] hover:underline
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // TODO: Navigate to Terms of Use
                                    },
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTextStyles.buttonText.copyWith(
                                    color: AppColors.primary500,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // TODO: Navigate to Privacy Policy
                                    },
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                            textAlign: TextAlign.center,
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
        if (_isLoading) const LoadingScreen(),
      ],
    );
  }

  Widget _buildRadioTile(
    BuildContext context, {
    required String value,
    required String groupValue,
    required String label,
    required ValueChanged<String?> onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        onChanged(value); // Update the state when tapped
      },
      child: Container(
        padding: const EdgeInsets.all(16), // p-4
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // rounded-lg
          border: Border.all(
            color: AppColors.secondary200,
          ), // border border-[var(--border-color)]
          color: value == groupValue
              ? AppColors.secondary50
              : Colors.white, // hover:bg-[var(--secondary-color)]
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged, // Use the provided onChanged callback
              activeColor: AppColors
                  .primary500, // text-[var(--primary-color)] focus:ring-[var(--primary-color)]
            ),
            const SizedBox(width: 12), // ml-3
            Text(
              label,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ), // text-sm font-medium text-[var(--text-primary)]
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required bool obscureText,
    required TextInputType keyboardType,
    TextEditingController? controller,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.w500,
          ), // block text-sm font-medium
        ),
        const SizedBox(height: 8), // mb-2
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyText.copyWith(
            color: AppColors.textColor,
          ), // text-base text-[var(--text-primary)]
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyText.copyWith(
              color: AppColors.secondary600,
            ), // placeholder:text-[var(--text-secondary)]
            filled: true,
            fillColor: AppColors.secondary50, // bg-[var(--secondary-color)]
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.secondary200,
              ), // Corrected: BorderSide.all removed
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary500,
                width: 2,
              ), // focus:outline-none focus:ring-2 focus:ring-[var(--primary-color)] focus:border-[var(--primary-color)]
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ), // py-3 px-4
            suffixIcon: label == 'Date of Birth'
                ? const Icon(
                    Icons.calendar_today,
                    color: AppColors.secondary700,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInputField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyText.copyWith(
              color: AppColors.secondary600,
            ),
            filled: true,
            fillColor: AppColors.secondary50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.secondary200,
              ), // Corrected: BorderSide.all removed
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
            ).copyWith(left: 60), // pl-12
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12), // pl-3
              alignment: Alignment.centerLeft,
              width: 60,
              child: Text(
                '+91',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.secondary700,
                ),
              ), // text-sm text-[var(--text-secondary)]
            ),
          ),
          keyboardType: TextInputType.phone,
          style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> options,
    String? value,
    required ValueChanged<String?> onChanged,
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
              borderSide: const BorderSide(
                color: AppColors.secondary200,
              ), // Corrected: BorderSide.all removed
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
          value: value,
          onChanged: onChanged, // Use the provided onChanged callback
          items: options.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textColor,
                ),
              ),
            );
          }).toList(),
          iconEnabledColor: AppColors.textColor,
          dropdownColor: Colors.white,
          style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          validator: (value) {
            if (value == null || value.isEmpty || value == options.first) {
              return 'Please select a $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordInputField({
    required String label,
    required String hintText,
    required ValueNotifier<bool> obscureText,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: obscureText,
          builder: (context, obscureTextValue, child) {
            return TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.bodyText.copyWith(
                  color: AppColors.secondary600,
                ),
                filled: true,
                fillColor: AppColors.secondary50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.secondary200,
                  ), // Corrected: BorderSide.all removed
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
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureTextValue ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.secondary700,
                  ), // text-[var(--text-secondary)]
                  onPressed: () {
                    obscureText.value = !obscureTextValue;
                  },
                ),
              ),
              obscureText: obscureTextValue,
              keyboardType: TextInputType.visiblePassword,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textColor,
              ),
              validator: validator,
            );
          },
        ),
      ],
    );
  }

  String _generateUserId() {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    return 'KULTM$code';
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool registrationSuccessful = false;
      try {
        // Hash the password before sending to Supabase or storing
        final String hashedPassword = BCrypt.hashpw(
          _passwordController.text.trim(),
          BCrypt.gensalt(),
        );

        final String userId = _generateUserId();

        // Construct a dummy email using the mobile number for Supabase auth.users table
        final String dummyEmail = '${_mobileController.text.trim()}@mobile.com';

        final city = _cityController.text;
        final district = _selectedDistrict;
        final cityWithDistrict = (city.isNotEmpty && district != null)
            ? '$city, $district'
            : city;

        final AuthResponse
        response = await Supabase.instance.client.auth.signUp(
          // Use mobile number as email for Supabase auth.users table if that's how you've set it up.
          // The actual user-facing email field for the profile will be stored in 'profiles' table.
          email:
              dummyEmail, // Using a constructed dummy email for Supabase auth.users
          password: _passwordController.text.trim(),
          data: {
            'full_name': _nameController.text.trim(),
            'mobile_number': _mobileController.text.trim(),
            'email': _emailController.text.trim(), // Actual email for profile
            'gender': _selectedGender,
            'account_type': _selectedAccountType,
            'date_of_birth': _dateOfBirthController.text.trim(),
            'rasi': _selectedRasi,
            'nachathram': _selectedNachathram,
            'dosham': _selectedDosham,
            'mother_tongue': _selectedMotherTongue,
            'password_hash': hashedPassword, // Store the hashed password
            'city': cityWithDistrict,
          },
        );

        if (response.user != null) {
          // User successfully registered, now ensure profile data including hashed password is in the 'profiles' table.
          // Note: The `data` argument in `signUp` automatically inserts into the `profiles` table if RLS allows and table exists.
          // We are explicitly updating/inserting here to ensure `password_hash` is present.

          DateTime? dateOfBirth;
          if (_dateOfBirthController.text.isNotEmpty &&
              _birthTimeController.text.isNotEmpty) {
            try {
              final date = DateTime.parse(_dateOfBirthController.text);
              final time = DateFormat.jm().parse(_birthTimeController.text);
              dateOfBirth = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid date or time format: $e')),
                );
              }
              setState(() {
                _isLoading = false;
              });
              return; // Stop registration if format is wrong
            }
          }

          await Supabase.instance.client.from('profiles').upsert({
            'id': response.user!.id,
            'userid': userId,
            'full_name': _nameController.text.trim(),
            'mobile_number': _mobileController.text.trim(),
            'email': _emailController.text.trim(),
            'gender': _selectedGender,
            'account_type': _selectedAccountType,
            'date_of_birth': dateOfBirth?.toIso8601String(),
            'rasi': _selectedRasi,
            'nachathram': _selectedNachathram,
            'dosham': _selectedDosham,
            'mother_tongue': _selectedMotherTongue,
            'password_hash':
                hashedPassword, // Ensure the hashed password is saved to profiles
            'city': cityWithDistrict,
            // Add other profile fields as needed.
          });

          // If registration automatically logged the user in, sign them out
          // so they are forced to log in with their new credentials.
          if (Supabase.instance.client.auth.currentSession != null) {
            await Supabase.instance.client.auth.signOut();
          }

          // Navigate to a success page or login page
          if (mounted) {
            registrationSuccessful = true;
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Registration successful! Please login with your credentials.',
                ),
              ),
            );
            // Navigate to login page after successful registration
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          }
        } else if (response.session == null && response.user == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration failed. Please try again.'),
              ),
            );
          }
        }
      } on AuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred: $e')),
          );
        }
      } finally {
        if (mounted && !registrationSuccessful) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
