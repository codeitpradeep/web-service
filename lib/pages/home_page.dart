import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_web_project/main.dart';
import 'package:my_web_project/responsive_layout.dart';
import 'package:my_web_project/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _boyNachathram;
  String? _girlNachathram;
  Map<String, dynamic>? _matchResult;
  final Map<String, dynamic> _allMatchData = {};
  bool _isResultShown = false;

  final List<String> _nachathramOptions = [
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
  ];

  @override
  void initState() {
    super.initState();
    _loadAllMatchData();
  }

  Future<void> _loadAllMatchData() async {
    final jsonFiles = [
      'assets/output_1.json',
      'assets/output_2.json',
      'assets/output_3.json',
      'assets/output_4.json',
      'assets/output_5.json',
      'assets/output_6.json',
      'assets/output_7.json',
      'assets/output_9.json',
      'assets/output_10.json',
      'assets/output_11.json',
      'assets/output_12.json',
      'assets/output_13.json',
      'assets/output_14.json',
      'assets/output_15.json',
      'assets/output_16.json',
      'assets/output_17.json',
      'assets/output_18.json',
      'assets/output_19.json',
      'assets/output_20.json',
      'assets/output_21.json',
      'assets/output_22.json',
      'assets/output_23.json',
      'assets/output_24.json',
      'assets/output_25.json',
      'assets/output_26.json',
      'assets/output_27.json',
      'assets/output_28.json',
      'assets/output_29.json',
      'assets/output_30.json',
      'assets/output_31.json',
      'assets/output_32.json',
      'assets/output_33.json',
      'assets/output_34.json',
      'assets/output_35.json',
      'assets/output_36.json',
      'assets/output_37.json',
      'assets/output_38.json',
      'assets/output_39.json',
      'assets/output_40.json',
      'assets/output_41.json',
      'assets/output_42.json',
      'assets/output_43.json',
      'assets/output_44.json',
      'assets/output_45.json',
      'assets/output_46.json',
      'assets/output_47.json',
      'assets/output_48.json',
      'assets/output_49.json',
      'assets/output_50.json',
      'assets/output_51.json',
      'assets/output_52.json',
      'assets/output_53.json',
      'assets/output_54.json',
      'assets/output_55.json',
    ];

    for (var file in jsonFiles) {
      try {
        final String response = await rootBundle.loadString(file);
        final data = await json.decode(response) as List;
        for (var item in data) {
          _allMatchData.addAll(item);
        }
      } catch (e) {
        // Handle potential errors like file not found or invalid JSON
        print('Error loading match data from $file: $e');
      }
    }
  }

  Future<void> _findMatch() async {
    if (_boyNachathram == null || _girlNachathram == null) {
      return;
    }

    final key = '${_boyNachathram}_${_girlNachathram}';
    final poruthamDetailsKey = 'porutham_details_$key';
    final poruthamKey = 'porutham_$key';
    final matchscoreKey = 'matchscore_$key';

    Map<String, dynamic>? newMatchResult;
    if (_allMatchData.containsKey(poruthamDetailsKey) &&
        _allMatchData.containsKey(poruthamKey) &&
        _allMatchData.containsKey(matchscoreKey)) {
      newMatchResult = {
        poruthamDetailsKey: _allMatchData[poruthamDetailsKey],
        poruthamKey: _allMatchData[poruthamKey],
        matchscoreKey: _allMatchData[matchscoreKey],
      };
    }

    setState(() {
      _matchResult = newMatchResult;
      _isResultShown = true;
    });
  }

  void _resetMatch() {
    setState(() {
      _boyNachathram = null;
      _girlNachathram = null;
      _matchResult = null;
      _isResultShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The Scaffold is now provided by MainLayout, so we remove it from here.
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 480), // min-h-[480px]
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                  "assets/avatar/Yellow Background Telugu Script.jpeg",
                ), // Replaced problematic URL
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ), // Linear gradient overlay
              ),
              borderRadius: BorderRadius.circular(16), // rounded-2xl
            ),
            padding: const EdgeInsets.all(32), // p-8
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 40,
            ), // mx-4, my-10/20
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Find Your Perfect Match',
                  style: AppTextStyles.headline1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16), // gap-4
                Text(
                  'Join thousands of happy couples who found their life partners through our trusted platform.',
                  style: AppTextStyles.subhead,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32), // gap-8
                // Partner Matching Section
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 768), // max-w-2xl
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Find Your Perfect Match',
                          style: AppTextStyles.subhead.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (_isResultShown) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _resetMatch,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary500,
                                    foregroundColor: Colors.white,
                                    textStyle: AppTextStyles.buttonText,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(
                                      0,
                                      40,
                                    ), // h-10, width will be handled by parent
                                  ),
                                  child: const Text('Reset'),
                                ),
                              );
                            } else {
                              return Column(
                                children: [
                                  _buildNachathramDropdown(
                                    'பெண் - Girl Nachathram',
                                    _boyNachathram,
                                    (newValue) {
                                      setState(() {
                                        _boyNachathram = newValue;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  _buildNachathramDropdown(
                                    'பையன் - Boy Nachathram',
                                    _girlNachathram,
                                    (newValue) {
                                      setState(() {
                                        _girlNachathram = newValue;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _findMatch,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary500,
                                        foregroundColor: Colors.white,
                                        textStyle: AppTextStyles.buttonText,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        minimumSize: const Size(
                                          0,
                                          40,
                                        ), // h-10, width will be handled by parent
                                      ),
                                      child: const Text('Match'),
                                    ),
                                  ), // self-end h-10
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Match Result Section
          if (_matchResult != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Match Result', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 16),
                  Text(
                    'Score: ${_matchResult!['matchscore_${_boyNachathram}_${_girlNachathram}']}',
                    style: AppTextStyles.headline1.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Other Details', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text(' ')),
                        DataColumn(label: Text('பெண் - Girl')),
                        DataColumn(label: Text('பையன் - Boy')),
                      ],
                      rows:
                          (_matchResult!['porutham_${_boyNachathram}_${_girlNachathram}']
                                  as Map<String, dynamic>)
                              .entries
                              .map(
                                (entry) => DataRow(
                                  cells: [
                                    DataCell(Text(entry.key)),
                                    DataCell(
                                      Text(
                                        entry.value is Map
                                            ? (entry.value as Map)['பெண்']
                                                      ?.toString() ??
                                                  ''
                                            : '',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        entry.value is Map
                                            ? (entry.value as Map)['பையன்']
                                                      ?.toString() ??
                                                  ''
                                            : '',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Porutham')),
                        DataColumn(label: Text('பெண் - Girl')),
                        DataColumn(label: Text('பையன் - Boy')),
                        DataColumn(label: Text('Result')),
                        DataColumn(label: Text('Score')),
                      ],
                      rows:
                          (_matchResult!['porutham_details_${_boyNachathram}_${_girlNachathram}']
                                  as List)
                              .map(
                                (detail) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        detail is Map
                                            ? detail['பொருத்தம்']?.toString() ??
                                                  ''
                                            : '',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        detail is Map
                                            ? detail['பெண்']?.toString() ?? ''
                                            : '',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        detail is Map
                                            ? detail['பையன்']?.toString() ?? ''
                                            : '',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        detail is Map
                                            ? detail['முடிவு']?.toString() ?? ''
                                            : '',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        detail is Map
                                            ? detail['பெற்ற மதிப்பெண்']
                                                      ?.toString() ??
                                                  ''
                                            : '',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),

          // Featured Profiles Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 40,
            ), // px-4 sm:px-6 lg:px-8 py-10
            constraints: const BoxConstraints(maxWidth: 1280), // max-w-7xl
            child: Column(
              children: [
                Text(
                  'Featured Profiles',
                  style: AppTextStyles.sectionTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32), // mb-8
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (ResponsiveLayout.isMobile(context)) {
                      return SizedBox(
                        height: 500, // Adjust height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredProfiles.length,
                          itemBuilder: (context, index) {
                            final profile = featuredProfiles[index];
                            return SizedBox(
                              width: 300, // Adjust width as needed
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ), // rounded-lg
                                          image: DecorationImage(
                                            image: AssetImage(
                                              profile.photos![0],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${profile.name}, ${profile.age}',
                                            style: AppTextStyles.cardTitle,
                                          ),
                                          Text(
                                            '${profile.occupation}, ${profile.city}',
                                            style: AppTextStyles.cardSubtitle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              ResponsiveLayout.isDesktop(
                                context,
                              ) // lg:grid-cols-4
                              ? 4
                              : ResponsiveLayout.isTablet(
                                  context,
                                ) // md:grid-cols-3
                              ? 3
                              : 2, // sm:grid-cols-2
                          crossAxisSpacing: 32, // gap-8
                          mainAxisSpacing: 32, // gap-8
                          childAspectRatio:
                              3 / 5, // Approximate aspect-[3/4] + text height
                        ),
                        itemCount: featuredProfiles.length,
                        itemBuilder: (context, index) {
                          final profile = featuredProfiles[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // rounded-lg
                                    image: DecorationImage(
                                      image: AssetImage(profile.photos![0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16), // gap-4
                              Text(
                                '${profile.name}, ${profile.age}',
                                style: AppTextStyles.cardTitle,
                              ),
                              Text(
                                '${profile.occupation}, ${profile.city}',
                                style: AppTextStyles.cardSubtitle,
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // How it Works Section
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1280), // max-w-7xl
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 80,
            ), // px-4 sm:px-6 lg:px-8 py-20
            margin: const EdgeInsets.only(top: 40), // mt-10
            decoration: BoxDecoration(
              color: AppColors.primary50, // bg-primary-50
              borderRadius: BorderRadius.circular(24), // rounded-t-3xl
            ),
            child: Column(
              children: [
                Text(
                  'Find Your Life Partner in 3 Simple Steps',
                  style: AppTextStyles.sectionTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8), // mt-2
                Text(
                  'Our platform is designed to make your search for a life partner easy, safe, and enjoyable.',
                  style: AppTextStyles.sectionSubtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48), // mb-12
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Flex(
                      direction: ResponsiveLayout.isDesktop(context)
                          ? Axis.horizontal
                          : Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: ResponsiveLayout.isDesktop(context)
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        _buildStep(
                          Icons.person_search,
                          'Create Your Profile',
                          'Register for free & create your detailed profile to be discovered by potential matches.',
                        ),
                        const SizedBox(width: 48, height: 48), // gap-12
                        _buildStep(
                          Icons.favorite,
                          'Search & Connect',
                          'Browse thousands of verified profiles, express interest, and connect with members you like.',
                        ),
                        const SizedBox(width: 48, height: 48),
                        _buildStep(
                          Icons.chat,
                          'Start Your Journey',
                          'Initiate conversations, get to know each other, and take the first step towards a happy marriage.',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          // Footer Section
          Container(
            width: double.infinity,
            color: AppColors.secondary100, // bg-secondary-100
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ), // px-4 sm:px-6 lg:px-8 py-8
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ), // To match spacing after previous section
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Flex(
                      direction: ResponsiveLayout.isDesktop(context)
                          ? Axis.horizontal
                          : Axis.vertical, // md:flex-row
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Footer Navigation Links
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 24, // gap-x-6
                          runSpacing: 8, // gap-y-2
                          children: [
                            _buildFooterLink(context, 'About Us'),
                            _buildFooterLink(context, 'Contact Us'),
                            _buildFooterLink(context, 'Privacy Policy'),
                            _buildFooterLink(context, 'Terms of Service'),
                          ],
                        ),
                        const SizedBox(
                          width: 24,
                          height: 16,
                        ), // gap between links and copyright on large screens, gap-y-2 on small
                        // Copyright Text
                        Text(
                          '© 2025 Tiruppur Kulalar Matrimony. All rights reserved.',
                          style: AppTextStyles.footerText,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNachathramDropdown(
    String label,
    String? currentValue,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0), // pl-3 mb-1
          child: Text(
            label,
            style: AppTextStyles.footerText.copyWith(
              color: Colors.white,
            ), // text-white text-xs font-medium
          ),
        ),
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.8), // bg-white/80
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // rounded-md
              borderSide: BorderSide.none, // border-transparent
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary500,
              ), // focus:border-primary-500
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          value: currentValue,
          onChanged: onChanged,
          items: _nachathramOptions.map<DropdownMenuItem<String>>((
            String value,
          ) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textColor,
                ),
              ),
            );
          }).toList(),
          iconEnabledColor: AppColors.textColor,
          dropdownColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    // Map footer text to routes
    String route = AppRoutes.home; // Default route
    if (text == 'About Us') route = AppRoutes.about;
    if (text == 'Contact Us') route = AppRoutes.contactUs;
    if (text == 'Privacy Policy') route = AppRoutes.privacyPolicy;
    if (text == 'Terms of Service') route = AppRoutes.termsConditions;

    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        style: AppTextStyles.footerText.copyWith(
          color: AppColors.secondary600,
        ), // text-secondary-600
      ),
    );
  }

  Widget _buildStep(IconData icon, String title, String description) {
    final child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16), // p-4
          decoration: BoxDecoration(
            color: AppColors.primary500, // bg-primary-500
            borderRadius: BorderRadius.circular(999), // rounded-full
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ), // text-white text-4xl
        ),
        const SizedBox(height: 16), // gap-4
        Text(
          title,
          style: AppTextStyles.stepTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8), // (implied gap)
        Text(
          description,
          style: AppTextStyles.stepDescription,
          textAlign: TextAlign.center,
        ),
      ],
    );

    if (ResponsiveLayout.isDesktop(context)) {
      return Expanded(child: child);
    } else {
      return child;
    }
  }
}
