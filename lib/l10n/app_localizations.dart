import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Tiruppur Kulalar Matrimony'**
  String get appTitle;

  /// Text for the hero section headline
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Match'**
  String get findYourPerfectMatch;

  /// Text for the hero section subhead
  ///
  /// In en, this message translates to:
  /// **'Join thousands of happy couples who found their life partners through our trusted platform.'**
  String get joinThousandsOfHappyCouples;

  /// Label for age dropdown
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Section title for location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Label for gender preference dropdown
  ///
  /// In en, this message translates to:
  /// **'I\'m looking for a'**
  String get imLookingForA;

  /// Text for search button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Section title for featured profiles
  ///
  /// In en, this message translates to:
  /// **'Featured Profiles'**
  String get featuredProfiles;

  /// Section title for how it works
  ///
  /// In en, this message translates to:
  /// **'Find Your Life Partner in 3 Simple Steps'**
  String get findYourLifePartnerIn3Steps;

  /// Section subtitle for how it works
  ///
  /// In en, this message translates to:
  /// **'Our platform is designed to make your search for a life partner easy, safe, and enjoyable.'**
  String get ourPlatformIsDesigned;

  /// Step 1 title
  ///
  /// In en, this message translates to:
  /// **'Create Your Profile'**
  String get createYourProfile;

  /// Step 1 description
  ///
  /// In en, this message translates to:
  /// **'Register for free & create your detailed profile to be discovered by potential matches.'**
  String get registerForFree;

  /// Step 2 title
  ///
  /// In en, this message translates to:
  /// **'Search & Connect'**
  String get searchAndConnect;

  /// Step 2 description
  ///
  /// In en, this message translates to:
  /// **'Browse thousands of verified profiles, express interest, and connect with members you like.'**
  String get browseThousandsOfVerifiedProfiles;

  /// Step 3 title
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get startYourJourney;

  /// Step 3 description
  ///
  /// In en, this message translates to:
  /// **'Initiate conversations, get to know each other, and take the first step towards a happy marriage.'**
  String get initiateConversations;

  /// Copyright text in the footer
  ///
  /// In en, this message translates to:
  /// **'© 2025 Tiruppur Kulalar Matrimony. All rights reserved.'**
  String get copyrightText;

  /// Footer link text for About Us
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// Footer link text for Contact Us
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Footer link text for Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Footer link text for Terms of Service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Text for Register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Text for Login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Navigation link text for Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Navigation link text for Matches
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// Navigation link text for Help
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Title for Register page
  ///
  /// In en, this message translates to:
  /// **'Create your Profile'**
  String get createYourProfilePageTitle;

  /// Subtitle for Register page
  ///
  /// In en, this message translates to:
  /// **'Join the largest Tiruppur Kulalar matrimonial service and find your perfect match.'**
  String get joinTheLargestTamilMatrimonial;

  /// Label for profile type selection
  ///
  /// In en, this message translates to:
  /// **'This profile is for a'**
  String get thisProfileIsForA;

  /// Radio button label for Bride
  ///
  /// In en, this message translates to:
  /// **'Bride'**
  String get bride;

  /// Radio button label for Groom
  ///
  /// In en, this message translates to:
  /// **'Groom'**
  String get groom;

  /// Label for account type selection
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// Radio button label for Individual
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// Radio button label for Family
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// Radio button label for Agent
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get agent;

  /// Section title for personal information
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Label for name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Hint text for full name input
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// Label for date of birth input field
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Label for religion input field
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// Label for mother tongue input field
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get motherTongue;

  /// Section title for contact details
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// Label for mobile number input field
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Label for email address input field
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Hint text for mobile number input
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// Section title for set password
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPassword;

  /// Label for create password input field
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPassword;

  /// Hint text for create password input
  ///
  /// In en, this message translates to:
  /// **'Enter a strong password'**
  String get enterStrongPassword;

  /// Label for confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Hint text for confirm password input
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterYourPassword;

  /// Text for Register Now button
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// Part of the terms and privacy policy text
  ///
  /// In en, this message translates to:
  /// **'By proceeding, you agree to our '**
  String get byProceedingYouAgreeToOur;

  /// Terms of Use link text
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// Conjunction in terms and privacy policy text
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// Text for Next button in Personal Info tab
  ///
  /// In en, this message translates to:
  /// **'Next: Education/Career'**
  String get nextEducationCareer;

  /// Text for Next button in Education/Career tab
  ///
  /// In en, this message translates to:
  /// **'Next: Family'**
  String get nextFamily;

  /// Text for Next button in Family tab
  ///
  /// In en, this message translates to:
  /// **'Next: Preferences'**
  String get nextPreferences;

  /// Text for Next button in Preferences tab
  ///
  /// In en, this message translates to:
  /// **'Next: Photo Uploads'**
  String get nextPhotoUploads;

  /// Text for Save Profile button in Photo Uploads tab
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// Text for Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Title for photo uploads section
  ///
  /// In en, this message translates to:
  /// **'Upload Your Photos'**
  String get uploadYourPhotos;

  /// Placeholder text for photo upload area
  ///
  /// In en, this message translates to:
  /// **'Drag and drop your photos here, or click to browse'**
  String get dragAndDropYourPhotos;

  /// Button text for browsing photos
  ///
  /// In en, this message translates to:
  /// **'Browse Photos'**
  String get browsePhotos;

  /// Label for highest education input field
  ///
  /// In en, this message translates to:
  /// **'Highest Education'**
  String get highestEducation;

  /// Label for college/university input field
  ///
  /// In en, this message translates to:
  /// **'College/University'**
  String get collegeUniversity;

  /// Label for occupation input field
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// Label for company name input field
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// Label for annual income input field
  ///
  /// In en, this message translates to:
  /// **'Annual Income'**
  String get annualIncome;

  /// Label for father's occupation input
  ///
  /// In en, this message translates to:
  /// **'Father\'s Occupation'**
  String get fathersOccupation;

  /// Label for mother's occupation input
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Occupation'**
  String get mothersOccupation;

  /// Label for number of siblings dropdown
  ///
  /// In en, this message translates to:
  /// **'Number of Siblings'**
  String get numberOfSiblings;

  /// Label for family values dropdown
  ///
  /// In en, this message translates to:
  /// **'Family Values'**
  String get familyValues;

  /// Label for partner age range (from) dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner Age Range (From)'**
  String get partnerAgeRangeFrom;

  /// Label for partner age range (to) dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner Age Range (To)'**
  String get partnerAgeRangeTo;

  /// Label for partner marital status dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner Marital Status'**
  String get partnerMaritalStatus;

  /// Label for partner religion dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner Religion'**
  String get partnerReligion;

  /// Label for partner mother tongue dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner Mother Tongue'**
  String get partnerMotherTongue;

  /// Label for partner caste/community dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner Caste/Community'**
  String get partnerCasteCommunity;

  /// Label for partner country dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner Country'**
  String get partnerCountry;

  /// Label for partner state dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner State'**
  String get partnerState;

  /// Label for partner city dropdown
  ///
  /// In en, this message translates to:
  /// **'Partner City'**
  String get partnerCity;

  /// Title for search results page
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// Subtitle for search results page
  ///
  /// In en, this message translates to:
  /// **'Showing 1-12 of 1,234 results'**
  String get showingResults;

  /// Title for filter panel
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Label for age range slider
  ///
  /// In en, this message translates to:
  /// **'Age Range'**
  String get ageRange;

  /// Button text for applying filters
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// Button text for sort by
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// Button text for save search
  ///
  /// In en, this message translates to:
  /// **'Save Search'**
  String get saveSearch;

  /// Button text for expressing interest
  ///
  /// In en, this message translates to:
  /// **'Express Interest'**
  String get expressInterest;

  /// Button text for shortlisting a profile
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get shortlist;

  /// Button text for viewing a profile
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// Tab title for Basic Details
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get basicDetails;

  /// Tab title for Education & Career
  ///
  /// In en, this message translates to:
  /// **'Education & Career'**
  String get educationCareer;

  /// Tab title for Family Details
  ///
  /// In en, this message translates to:
  /// **'Family Details'**
  String get familyDetails;

  /// Tab title for Preferences
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Section title for 'About' in profile view
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Label for 'About Me' in profile view
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// Tab title for My Profile
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Title for editing a user profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile:'**
  String get editProfile;

  /// Title for Your Matches section
  ///
  /// In en, this message translates to:
  /// **'Your Matches'**
  String get yourMatches;

  /// Tab title for Interests Sent/Received
  ///
  /// In en, this message translates to:
  /// **'Interests Sent/Received'**
  String get interestsSentReceived;

  /// Tab title for Messages
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Tab title for Privacy Settings
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Hint text for search conversations input
  ///
  /// In en, this message translates to:
  /// **'Search conversations...'**
  String get searchConversations;

  /// Placeholder text for no conversation selected
  ///
  /// In en, this message translates to:
  /// **'No Conversation Selected'**
  String get noConversationSelected;

  /// Instructional text for selecting a conversation
  ///
  /// In en, this message translates to:
  /// **'Select a conversation from the left to start chatting.'**
  String get selectAConversation;

  /// Hint text for message input field
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get typeYourMessage;

  /// Button text for sending a message
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Title for Admin Panel
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// Tab title for New Profiles in Admin Panel
  ///
  /// In en, this message translates to:
  /// **'New Profiles'**
  String get newProfiles;

  /// Tab title for Approved Profiles in Admin Panel
  ///
  /// In en, this message translates to:
  /// **'Approved Profiles'**
  String get approvedProfiles;

  /// Tab title for Rejected Profiles in Admin Panel
  ///
  /// In en, this message translates to:
  /// **'Rejected Profiles'**
  String get rejectedProfiles;

  /// Tab title for Settings in Admin Panel
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Subtitle for New Profiles section in Admin Panel
  ///
  /// In en, this message translates to:
  /// **'Review and moderate new profiles awaiting approval.'**
  String get reviewAndModerateNewProfiles;

  /// Table column header for Profile ID
  ///
  /// In en, this message translates to:
  /// **'Profile ID'**
  String get profileId;

  /// Label for gender dropdown
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Table column header for Action
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// Button text for approving a profile
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Button text for rejecting a profile
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// About Us page mission statement
  ///
  /// In en, this message translates to:
  /// **'Our mission is to help individuals from the Tamil community find their compatible life partners. We are committed to creating a secure, reliable, and user-friendly platform that respects traditional values while embracing modern aspirations. Our goal is to foster meaningful connections and facilitate successful marriages.'**
  String get tamilMatrimonyMission;

  /// About Us page section title for commitment
  ///
  /// In en, this message translates to:
  /// **'Our Commitment'**
  String get ourCommitment;

  /// About Us page details for commitment
  ///
  /// In en, this message translates to:
  /// **'We are dedicated to:\n\n*   **Privacy & Security:** Ensuring the utmost privacy and security of your personal information.\n*   **Authenticity:** Verifying profiles to maintain a genuine and trustworthy community.\n*   **User Experience:** Providing an intuitive and pleasant platform for your partner search.\n*   **Support:** Offering excellent customer support to assist you at every step.'**
  String get commitmentDetails;

  /// FAQ page title
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// FAQ question: How do I register?
  ///
  /// In en, this message translates to:
  /// **'How do I register?'**
  String get howDoIRegister;

  /// FAQ answer: Registration
  ///
  /// In en, this message translates to:
  /// **'You can register for free by clicking on the \'Register\' button on the homepage and following the simple steps.'**
  String get registrationAnswer;

  /// FAQ question: Is my profile information secure?
  ///
  /// In en, this message translates to:
  /// **'Is my profile information secure?'**
  String get isMyProfileSecure;

  /// FAQ answer: Security
  ///
  /// In en, this message translates to:
  /// **'Yes, we use advanced security measures to protect your personal data. Please refer to our Privacy Policy for more details.'**
  String get securityAnswer;

  /// FAQ question: Can I cancel my subscription?
  ///
  /// In en, this message translates to:
  /// **'Can I cancel my subscription?'**
  String get canICancelMySubscription;

  /// FAQ answer: Cancel Subscription
  ///
  /// In en, this message translates to:
  /// **'You can cancel your premium subscription at any time from your dashboard settings. Refunds are subject to our refund policy.'**
  String get cancelSubscriptionAnswer;

  /// FAQ question: How do I contact customer support?
  ///
  /// In en, this message translates to:
  /// **'How do I contact customer support?'**
  String get howDoIContactSupport;

  /// FAQ answer: Contact Support
  ///
  /// In en, this message translates to:
  /// **'You can reach our customer support team via the \'Contact Us\' page, email, or phone during business hours.'**
  String get contactSupportAnswer;

  /// Privacy Policy page title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// Privacy Policy effective date
  ///
  /// In en, this message translates to:
  /// **'Effective Date: September 14, 2024'**
  String get effectiveDate;

  /// Privacy Policy section title: Introduction
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get introduction;

  /// Privacy Policy section content: Introduction
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tiruppur Kulalar Matrimony. We are committed to protecting your privacy and personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our website.'**
  String get introductionContent;

  /// Privacy Policy section title: Information We Collect
  ///
  /// In en, this message translates to:
  /// **'2. Information We Collect'**
  String get informationWeCollect;

  /// Privacy Policy section content: Information We Collect
  ///
  /// In en, this message translates to:
  /// **'We collect various types of information, including:\n\n*   **Personal Data:** Name, email address, phone number, date of birth, gender, religion, caste, education, occupation, photos, and other details provided during registration and profile creation.\n*   **Usage Data:** Information on how you access and use the website, such as IP address, browser type, pages visited, and time spent on pages.\n*   **Communication Data:** Records of communications with other users and our customer support.'**
  String get informationWeCollectContent;

  /// Privacy Policy section title: How We Use Your Information
  ///
  /// In en, this message translates to:
  /// **'3. How We Use Your Information'**
  String get howWeUseYourInformation;

  /// Privacy Policy section content: How We Use Your Information
  ///
  /// In en, this message translates to:
  /// **'We use the collected information for various purposes, including to:\n\n*   Provide and maintain our service.\n*   Create and manage your account and profile.\n*   Facilitate connections and matches with other users.\n*   Improve and personalize your experience on our website.\n*   Communicate with you about services, updates, and promotional offers.\n*   Monitor and analyze usage and trends to improve the website\'s functionality.'**
  String get howWeUseYourInformationContent;

  /// Privacy Policy section title: Disclosure of Your Information
  ///
  /// In en, this message translates to:
  /// **'4. Disclosure of Your Information'**
  String get disclosureOfYourInformation;

  /// Privacy Policy section content: Disclosure of Your Information
  ///
  /// In en, this message translates to:
  /// **'We may disclose your information to:\n\n*   **Other Users:** Certain profile information (excluding sensitive contact details) is visible to other registered users.\n*   **Service Providers:** Third-party vendors who perform services on our behalf, such as payment processing, data analysis, and customer support.\n*   **Legal Requirements:** When required by law or in response to valid requests by public authorities.\n*   **Business Transfers:** In connection with a merger, sale of company assets, or acquisition.'**
  String get disclosureOfYourInformationContent;

  /// Privacy Policy section title: Security of Data
  ///
  /// In en, this message translates to:
  /// **'5. Security of Data'**
  String get securityOfData;

  /// Privacy Policy section content: Security of Data
  ///
  /// In en, this message translates to:
  /// **'We implement a variety of security measures to maintain the safety of your personal information. However, no method of transmission over the Internet or method of electronic storage is 100% secure.'**
  String get securityOfDataContent;

  /// Privacy Policy section title: Your Rights
  ///
  /// In en, this message translates to:
  /// **'6. Your Rights'**
  String get yourRights;

  /// Privacy Policy section content: Your Rights
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, update, or delete your personal information at any time. You can also object to the processing of your data, request data portability, and withdraw your consent.'**
  String get yourRightsContent;

  /// Privacy Policy section title: Changes to This Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'7. Changes to This Privacy Policy'**
  String get changesToThisPrivacyPolicy;

  /// Privacy Policy section content: Changes to This Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.'**
  String get changesToThisPrivacyPolicyContent;

  /// Privacy Policy section title: Contact Us
  ///
  /// In en, this message translates to:
  /// **'8. Contact Us'**
  String get contactUsPrivacy;

  /// Privacy Policy section content: Contact Us
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at support@tamilmatrimony.com.'**
  String get contactUsPrivacyContent;

  /// Terms & Conditions page title
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// Terms & Conditions section title: Acceptance of Terms
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance of Terms'**
  String get acceptanceOfTerms;

  /// Terms & Conditions section content: Acceptance of Terms
  ///
  /// In en, this message translates to:
  /// **'By accessing and using Tiruppur Kulalar Matrimony, you agree to be bound by these Terms and Conditions and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this site.'**
  String get acceptanceOfTermsContent;

  /// Terms & Conditions section title: Eligibility
  ///
  /// In en, this message translates to:
  /// **'2. Eligibility'**
  String get eligibility;

  /// Terms & Conditions section content: Eligibility
  ///
  /// In en, this message translates to:
  /// **'You must be at least 18 years old and legally able to enter into contracts to use our services. By using the site, you represent and warrant that you meet these eligibility requirements.'**
  String get eligibilityContent;

  /// Terms & Conditions section title: User Account
  ///
  /// In en, this message translates to:
  /// **'3. User Account'**
  String get userAccount;

  /// Terms & Conditions section content: User Account
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.'**
  String get userAccountContent;

  /// Terms & Conditions section title: Code of Conduct
  ///
  /// In en, this message translates to:
  /// **'4. Code of Conduct'**
  String get codeOfConduct;

  /// Terms & Conditions section content: Code of Conduct
  ///
  /// In en, this message translates to:
  /// **'You agree not to use the website for any unlawful or prohibited purpose, including but not limited to harassment, fraud, or spamming. You must respect other users and maintain a courteous demeanor.'**
  String get codeOfConductContent;

  /// Terms & Conditions section title: Content and Intellectual Property
  ///
  /// In en, this message translates to:
  /// **'5. Content and Intellectual Property'**
  String get contentAndIntellectualProperty;

  /// Terms & Conditions section content: Content and Intellectual Property
  ///
  /// In en, this message translates to:
  /// **'You retain ownership of the content you submit to the website, but you grant us a license to use, reproduce, and distribute your content in connection with the service. All other content on the site is our property.'**
  String get contentAndIntellectualPropertyContent;

  /// Terms & Conditions section title: Limitation of Liability
  ///
  /// In en, this message translates to:
  /// **'6. Limitation of Liability'**
  String get limitationOfLiability;

  /// Terms & Conditions section content: Limitation of Liability
  ///
  /// In en, this message translates to:
  /// **'We will not be liable for any damages arising out of your use or inability to use the website. This includes direct, indirect, incidental, punitive, and consequential damages.'**
  String get limitationOfLiabilityContent;

  /// Terms & Conditions section title: Governing Law
  ///
  /// In en, this message translates to:
  /// **'7. Governing Law'**
  String get governingLaw;

  /// Terms & Conditions section content: Governing Law
  ///
  /// In en, this message translates to:
  /// **'These Terms and Conditions are governed by and construed in accordance with the laws of Tamil Nadu, India, without regard to its conflict of law provisions.'**
  String get governingLawContent;

  /// Terms & Conditions section title: Changes to Terms
  ///
  /// In en, this message translates to:
  /// **'8. Changes to Terms'**
  String get changesToTerms;

  /// Terms & Conditions section content: Changes to Terms
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to revise these Terms and Conditions at any time without prior notice. By using this website, you are agreeing to be bound by the current version of these Terms and Conditions.'**
  String get changesToTermsContent;

  /// Tab title for FAQs in Public pages
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// Tab title for Dashboard in Admin Panel
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Hint text for name input field
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get nameHint;

  /// Hint text for date of birth input field
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get dobHint;

  /// Label for marital status dropdown
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// Label for caste/community input field
  ///
  /// In en, this message translates to:
  /// **'Caste / Community'**
  String get casteCommunity;

  /// Label for sub-caste input field
  ///
  /// In en, this message translates to:
  /// **'Sub-Caste (Optional)'**
  String get subCasteOptional;

  /// Label for country living in dropdown
  ///
  /// In en, this message translates to:
  /// **'Country Living In'**
  String get countryLivingIn;

  /// Label for state living in dropdown
  ///
  /// In en, this message translates to:
  /// **'State Living In'**
  String get stateLivingIn;

  /// Label for city living in dropdown
  ///
  /// In en, this message translates to:
  /// **'City Living In'**
  String get cityLivingIn;

  /// Label for contact number input field
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// Headline for the login page
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Subtitle for the login page
  ///
  /// In en, this message translates to:
  /// **'Login to find your perfect match.'**
  String get loginToFindYourPerfectMatch;

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Link text for forgot password
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotYourPassword;

  /// Text for don't have an account prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// Tab title for Manage User Profiles in Admin Panel
  ///
  /// In en, this message translates to:
  /// **'Manage User Profiles'**
  String get manageUserProfiles;

  /// Message for successful login
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Message for failed login
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// Message for an unexpected error during login
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: {error}'**
  String anUnexpectedErrorOccurred(Object error);

  /// Validation message for empty mobile number
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number'**
  String get pleaseEnterYourMobileNumber;

  /// Validation message for invalid mobile number
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number'**
  String get pleaseEnterValidMobileNumber;

  /// Button text for creating a new profile
  ///
  /// In en, this message translates to:
  /// **'Create New Profile'**
  String get createNewProfile;

  /// Section title for basic information in profile edit form
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// Label for full name input field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Section title for religious and social background
  ///
  /// In en, this message translates to:
  /// **'Religious & Social Background'**
  String get religiousSocialBackground;

  /// Label for sub-caste input field
  ///
  /// In en, this message translates to:
  /// **'Sub-caste'**
  String get subCaste;

  /// Label for gothram input field
  ///
  /// In en, this message translates to:
  /// **'Gothram'**
  String get gothram;

  /// Label for country input field
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Label for state input field
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// Label for city input field
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Section title for professional and educational background
  ///
  /// In en, this message translates to:
  /// **'Professional & Educational Background'**
  String get professionalEducationalBackground;

  /// Section title for About Me in admin panel
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMeAdmin;

  /// Label for about me textarea
  ///
  /// In en, this message translates to:
  /// **'Write a few words about yourself'**
  String get writeAboutYourself;

  /// Button text for cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text for saving changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Button text for deleting a profile
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// Error message when user is not logged in
  ///
  /// In en, this message translates to:
  /// **'Login required to update profile.'**
  String get loginRequired;

  /// Success message after profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// Validation message for empty full name
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// Validation message for empty date of birth
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get pleaseSelectDateOfBirth;

  /// Validation message for empty gender selection
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get pleaseSelectGender;

  /// Validation message for empty account type selection
  ///
  /// In en, this message translates to:
  /// **'Please select your account type'**
  String get pleaseSelectAccountType;

  /// Validation message for empty religion selection
  ///
  /// In en, this message translates to:
  /// **'Please select your religion'**
  String get pleaseSelectReligion;

  /// Validation message for empty mother tongue selection
  ///
  /// In en, this message translates to:
  /// **'Please select your mother tongue'**
  String get pleaseSelectMotherTongue;

  /// Validation message for empty education
  ///
  /// In en, this message translates to:
  /// **'Please enter your highest education'**
  String get pleaseEnterEducation;

  /// Validation message for empty occupation
  ///
  /// In en, this message translates to:
  /// **'Please enter your occupation'**
  String get pleaseEnterOccupation;

  /// Validation message for empty city
  ///
  /// In en, this message translates to:
  /// **'Please enter your city'**
  String get pleaseEnterCity;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
