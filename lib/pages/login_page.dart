import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/l10n/app_localizations.dart';
import 'package:my_web_project/main.dart'; // For AppRoutes
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:bcrypt/bcrypt.dart'; // Import bcrypt for password hashing

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Add Form Key
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  bool _isLoading = false;

  late AppLocalizations
  appLocalizations; // Declare appLocalizations as a class member

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appLocalizations = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _isPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final AppLocalizations appLocalizations = AppLocalizations.of(context)!; // Remove local declaration
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                // Wrap with Form widget
                key: _formKey, // Assign form key
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appLocalizations.welcomeBack,
                      style: AppTextStyles.headline2.copyWith(
                        color: AppColors.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appLocalizations.loginToFindYourPerfectMatch,
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Mobile Number Field
                    TextFormField(
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: appLocalizations.mobileNumber,
                        prefixIcon: const Icon(
                          Icons.phone_iphone,
                          color: AppColors.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundSecondary,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalizations
                              .pleaseEnterYourMobileNumber; // Added validation
                        }
                        // Basic mobile number validation (e.g., 10 digits)
                        if (value.length < 10) {
                          return appLocalizations
                              .pleaseEnterValidMobileNumber; // Added validation
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    ValueListenableBuilder<bool>(
                      valueListenable: _isPasswordVisible,
                      builder: (context, isPasswordVisible, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: appLocalizations.password,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                _isPasswordVisible.value = !isPasswordVisible;
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.borderColor,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundSecondary,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password logic
                        },
                        child: Text(
                          appLocalizations.forgotYourPassword,
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.primary500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: AppTextStyles.buttonText,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(appLocalizations.login),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: appLocalizations.dontHaveAnAccount,
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: appLocalizations.registerNow,
                              style: AppTextStyles.bodyText.copyWith(
                                color: AppColors.primary500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String mobileNumber = _mobileNumberController.text.trim();
      final String enteredPassword = _passwordController.text.trim();

      try {
        // The secure way to log in: let Supabase handle the check.
        // We construct the dummy email and attempt to sign in directly.
        final String dummyEmail = '$mobileNumber@mobile.com';
        final AuthResponse authResponse = await Supabase.instance.client.auth
            .signInWithPassword(email: dummyEmail, password: enteredPassword);

        if (authResponse.user != null) {
          // Supabase session successfully established
          
          // Check user role from profiles table
          final data = await Supabase.instance.client
              .from('profiles')
              .select('role')
              .eq('id', authResponse.user!.id)
              .single();
              
          final String role = data['role'] ?? 'user';

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(appLocalizations.loginSuccessful)),
            );
            
            // Navigate based on role
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (role == 'admin') {
                 Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppRoutes.adminPanel);
              } else {
                 Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
              }
            });
          }
        } else {
          // This part is usually not reached if signInWithPassword fails,
          // as it throws an exception. But as a fallback:
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(appLocalizations.loginFailed)),
            );
          }
        }
      } on AuthException catch (e) {
        // Handle specific Supabase auth errors (e.g., invalid credentials)
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message), // Show the actual error from Supabase
            ),
          );
        }
      } catch (e) {
        // Handle other unexpected errors
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                appLocalizations.anUnexpectedErrorOccurred(e.toString()),
              ),
            ),
          );
        }
      }
    }
  }
}
