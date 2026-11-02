import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_web_project/app_shell.dart';
import 'package:my_web_project/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_web_project/l10n/app_localizations.dart';
import 'package:my_web_project/pages/create_edit_profile_page.dart';
import 'package:my_web_project/pages/profile_view_page.dart';
import 'package:my_web_project/pages/admin_panel_page.dart';
import 'package:my_web_project/pages/about_page.dart';
import 'package:my_web_project/pages/faq_page.dart';
import 'package:my_web_project/pages/privacy_policy_page.dart';
import 'package:my_web_project/pages/terms_conditions_page.dart';
import 'package:my_web_project/pages/contact_us_page.dart';
import 'package:my_web_project/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zzwtsqryboodufsbzkpl.supabase.co',
    anonKey: 'sb_publishable_Li7nsxfnWE6cVOjn5WyT0A_Euph4W3s',
  );
  runApp(const MyApp());
}

// Define route names as constants
class AppRoutes {
  static const String splash = '/';
  static const String app = '/app';
  static const String home = '/home';
  static const String register = '/register';
  static const String createEditProfile = '/create-edit-profile';
  static const String searchResults = '/search-results';
  static const String profileView = '/profile-view';
  static const String dashboard = '/dashboard';
  static const String messages = '/messages';
  static const String matches = '/matches';
  static const String adminPanel = '/admin-panel';
  static const String about = '/about';
  static const String faq = '/faq';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String contactUs = '/contact-us';
  static const String login = '/login';
}

class Profile {
  final String? id;
  final String? userid;
  final String? role;
  final String name;
  final int? age;
  final String? city;
  final String? education;
  final String? occupation;
  final String? rasi;
  final String? nachathram;
  final String? dosham;
  final String? caste;
  final List<String>? photos;
  final DateTime? dateOfBirth;
  final String? profilePicture;
  final String? mobileNumber;
  final String? email;
  final String? gender;
  final String? accountType;
  final String? motherTongue;
  final String? aboutMe;
  final String? highestEducation;
  final String? maritalStatus;
  final String? country;
  final String? state;
  final String? companyName;
  final String? annualIncome;
  final String? fathersOccupation;
  final String? mothersOccupation;
  final int? numberOfSiblings;
  final String? familyValues;
  final String? horoscopeUrl;
  final String? approvalStatus;

  Profile({
    this.id,
    this.userid,
    this.role,
    required this.name,
    this.age,
    this.city,
    this.education,
    this.occupation,
    this.rasi,
    this.nachathram,
    this.dosham,
    this.caste,
    List<String>? photos,
    this.dateOfBirth,
    String? profilePicture,
    this.mobileNumber,
    this.email,
    this.gender,
    this.accountType,
    this.motherTongue,
    this.aboutMe,
    this.highestEducation,
    this.maritalStatus,
    this.country,
    this.state,
    this.companyName,
    this.annualIncome,
    this.fathersOccupation,
    this.mothersOccupation,
    this.numberOfSiblings,
    this.familyValues,
    this.horoscopeUrl,
    this.approvalStatus,
  }) : photos = photos ?? ['https://picsum.photos/150'],
       profilePicture = profilePicture ?? 'https://picsum.photos/150';
}

final List<Profile> featuredProfiles = [
  Profile(
    name: "Priya",
    age: 28,
    city: "Chennai",
    education: "B.E. Computer Science",
    occupation: "Software Engineer",
    rasi: "Simha",
    nachathram: "மகம்",
    dosham: "தோஷம் இல்லை",
    caste: "Mudaliar",
    photos: ["assets/avatar/girl_image_1.png"],
  ),
  Profile(
    name: "Arun",
    age: 32,
    city: "Coimbatore",
    education: "M.B.B.S.",
    occupation: "Doctor",
    rasi: "Kumbha",
    nachathram: "சதயம்",
    dosham: "செவ்வாய் தோஷம்",
    caste: "Chettiar",
    photos: ["assets/avatar/boy_image_1.png"],
  ),
  Profile(
    name: "Meena",
    age: 25,
    city: "Madurai",
    education: "B.Ed.",
    occupation: "Teacher",
    rasi: "Tula",
    nachathram: "சித்திரை - 3ம் பாதம்",
    dosham: "தோஷம் இல்லை",
    caste: "Vanniyar",
    photos: ["assets/avatar/girl_image_2.png"],
  ),
  Profile(
    name: "Vijay",
    age: 30,
    city: "Salem",
    education: "B.B.A.",
    occupation: "Business Owner",
    rasi: "Dhanu",
    nachathram: "மூலம்",
    dosham: "ராகு கேது தோஷம்",
    caste: "Naidu",
    photos: ["assets/avatar/boy_image_2.png"],
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Tamil Matrimony',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ta', ''), // Tamil
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.secondary50,
        textTheme: GoogleFonts.manropeTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: AppColors.textColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.secondary50,
          foregroundColor: AppColors.textColor,
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => const SplashPage());
          case AppRoutes.app:
            return MaterialPageRoute(builder: (_) => const AppShell());
          case AppRoutes.createEditProfile:
            final profile = settings.arguments as Profile?;
            page = CreateEditProfilePage(userProfile: profile);
            break;
          case AppRoutes.profileView:
            if (settings.arguments is Profile) {
              final profile = settings.arguments as Profile;
              page = ProfileViewPage(profile: profile);
            } else {
              page = const AppShell();
            }
            break;
          case AppRoutes.dashboard:
            page = const AppShell(initialRoute: '/dashboard');
            break;
          case AppRoutes.adminPanel:
            page = const AdminPanelPage();
            break;
          case AppRoutes.about:
            page = const AboutPage();
            break;
          case AppRoutes.faq:
            page = const FAQPage();
            break;
          case AppRoutes.privacyPolicy:
            page = const PrivacyPolicyPage();
            break;
          case AppRoutes.termsConditions:
            page = const TermsConditionsPage();
            break;
          case AppRoutes.contactUs:
            page = const ContactUsPage();
            break;
          default:
            return MaterialPageRoute(builder: (_) => const AppShell());
        }
        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}
