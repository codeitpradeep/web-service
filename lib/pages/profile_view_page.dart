import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_web_project/main.dart'; // For Profile model
import 'package:my_web_project/responsive_layout.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/widgets/app_header.dart';

class ProfileViewPage extends StatefulWidget {
  final Profile profile; // Assume a profile is passed to this page

  const ProfileViewPage({super.key, required this.profile});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = const [
    'Basic Details',
    'Education & Career',
    'Family Details',
    'Preferences',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        isLoggedIn: true,
        navLinks: ResponsiveLayout.isMobile(context)
            ? []
            : const ['My Profile'],
        onProfilePressed: () =>
            Navigator.pushNamed(context, AppRoutes.dashboard),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1280), // max-w-6xl
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ), // px-4 sm:px-6 lg:px-8 py-8 md:py-12
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = ResponsiveLayout.isMobile(context);
                return Flex(
                  direction: constraints.maxWidth > 992 && !isMobile
                      ? Axis.horizontal
                      : Axis.vertical, // lg:grid-cols-3
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Left Column: Profile Photos & Actions
                    Container(
                      width: constraints.maxWidth > 992 && !isMobile
                          ? 384
                          : double
                                .infinity, // lg:col-span-1 (approx w-96 to match proportion)
                      margin: constraints.maxWidth > 992 && !isMobile
                          ? const EdgeInsets.only(right: 32)
                          : const EdgeInsets.only(bottom: 32), // gap-8
                      child: Column(
                        children: [
                          if (isMobile)
                            SizedBox(
                              height: 400,
                              width: double.infinity,
                              child: Image.network(
                                widget.profile.photos![0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (!isMobile)
                            Card(
                              elevation: 4, // shadow-md
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ), // rounded-lg
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: const EdgeInsets.all(24), // p-6
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Main Profile Image Gallery
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio: 0.75,
                                          ),
                                      itemCount:
                                          (widget.profile.photos?.length ?? 0)
                                              .clamp(0, 3),
                                      itemBuilder: (context, index) {
                                        final photos = widget.profile.photos;
                                        if (photos == null || photos.isEmpty) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary100,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              size: 64,
                                              color: AppColors.secondary400,
                                            ),
                                          );
                                        }
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                photos[index],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    // Profile Summary
                                    Text(
                                      '${widget.profile.name}, ${widget.profile.age ?? 'N/A'}',
                                      style: AppTextStyles.cardTitle.copyWith(
                                        color: AppColors.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${widget.profile.occupation ?? 'N/A'}, ${widget.profile.city ?? 'N/A'}',
                                      style: AppTextStyles.cardSubtitle
                                          .copyWith(
                                            color: AppColors.secondary700,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Right Column: Profile Details
                    Flexible(
                      flex: 2, // lg:col-span-2
                      child: Card(
                        elevation: 4, // shadow-md
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ), // rounded-lg
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            // Tab Navigation for Details
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.secondary200,
                                  ),
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                labelColor: AppColors.primary500,
                                unselectedLabelColor: AppColors.secondary700,
                                indicatorColor: AppColors.primary500,
                                indicatorWeight: 2.0,
                                labelStyle: AppTextStyles.navLink.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ), // font-bold
                                tabs: _tabs
                                    .map((tab) => Tab(text: tab))
                                    .toList(),
                                onTap: (index) {
                                  _tabController.animateTo(index);
                                },
                              ),
                            ),
                            SizedBox(
                              height:
                                  600, // Constrain the height of the TabBarView
                              child: TabBarView(
                                controller: _tabController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: _tabs.map((tab) {
                                  if (tab == 'Basic Details') {
                                    return _buildBasicDetails();
                                  } else if (tab == 'Education & Career') {
                                    return _buildEducationCareerDetails();
                                  } else if (tab == 'Family Details') {
                                    return _buildFamilyDetails();
                                  } else if (tab == 'Preferences') {
                                    return _buildPreferencesDetails();
                                  } else {
                                    return const Center(
                                      child: Text('Unknown Details Tab'),
                                    );
                                  }
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
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

  // Helper Widgets for Profile Details
  Widget _buildDetailSection({required String title, required Widget content}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32), // p-6 md:p-8
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ), // text-lg font-bold mb-4
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.footerText.copyWith(
            color: AppColors.secondary700,
          ),
        ), // text-sm font-medium text-gray-500
        const SizedBox(height: 4), // mt-1
        Text(
          value,
          style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
        ), // text-sm text-gray-900
      ],
    );
  }

  Widget _buildBasicDetails() {
    return _buildDetailSection(
      title: 'About ${widget.profile.name}',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.profile.aboutMe ??
                'No details provided.', // Use dynamic data
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.secondary700,
            ), // text-gray-600 leading-relaxed
          ),
          const SizedBox(height: 32),
          if (widget.profile.horoscopeUrl != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final user = Supabase.instance.client.auth.currentUser;
                  if (user == null) return;

                  final sevenDaysAgo = DateTime.now()
                      .subtract(const Duration(days: 7))
                      .toIso8601String();

                  try {
                    // Check weekly download limit
                    final downloads = await Supabase.instance.client
                        .from('profile_downloads')
                        .select('id')
                        .eq('user_id', user.id)
                        .gte('created_at', sevenDaysAgo);

                    if (downloads.length >= 5) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Download Limit Reached'),
                            content: const Text(
                                'You have reached your weekly limit of 5 downloads.'),
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

                    final url = widget.profile.horoscopeUrl!;
                    final response = await http.get(Uri.parse(url));
                    if (response.statusCode == 200) {
                      final blob = html.Blob([
                        response.bodyBytes,
                      ], 'application/pdf');
                      final blobUrl = html.Url.createObjectUrlFromBlob(blob);
                      final anchor = html.AnchorElement(href: blobUrl)
                        ..setAttribute("download", "horoscope.pdf")
                        ..click();
                      html.Url.revokeObjectUrl(blobUrl);

                      // Log the download
                      await Supabase.instance.client
                          .from('profile_downloads')
                          .insert({
                        'user_id': user.id,
                        'profile_id': widget.profile.id,
                        'download_type': 'horoscope',
                      });
                    } else {
                      throw Exception(
                        'Failed to download file: ${response.statusCode}',
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Download failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Horoscope'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
          Text(
            'Basic Information',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, // sm:grid-cols-2
            childAspectRatio: 3, // Adjust as needed for row-like appearance
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24, // gap-y-6
            crossAxisSpacing: 16, // gap-x-4
            children: [
              _buildDetailRow(
                'Date of Birth',
                widget.profile.dateOfBirth != null
                    ? DateFormat(
                        'dd-MM-yyyy, hh:mm a',
                      ).format(widget.profile.dateOfBirth!)
                    : 'N/A',
              ),
              _buildDetailRow('Height', '5\' 6"'), // Static for now
              _buildDetailRow('Rasi', widget.profile.rasi ?? 'N/A'),
              _buildDetailRow('Nachathram', widget.profile.nachathram ?? 'N/A'),
              _buildDetailRow('Dosham', widget.profile.dosham ?? 'N/A'),
              _buildDetailRow(
                'Mother Tongue',
                widget.profile.motherTongue ?? 'N/A',
              ),
              _buildDetailRow(
                'Marital Status',
                widget.profile.maritalStatus ?? 'N/A',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCareerDetails() {
    return _buildDetailSection(
      title: 'Education & Career',
      content: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 24,
        crossAxisSpacing: 16,
        children: [
          _buildDetailRow(
            'Highest Qualification',
            widget.profile.highestEducation ?? 'N/A',
          ),
          _buildDetailRow('Company Name', widget.profile.companyName ?? 'N/A'),
          _buildDetailRow('Occupation', widget.profile.occupation ?? 'N/A'),
          _buildDetailRow(
            'Annual Income',
            widget.profile.annualIncome ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyDetails() {
    return _buildDetailSection(
      title: 'Family Details',
      content: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 24,
        crossAxisSpacing: 16,
        children: [
          _buildDetailRow(
            'Father\'s Occupation',
            widget.profile.fathersOccupation ?? 'N/A',
          ),
          _buildDetailRow(
            'Mother\'s Occupation',
            widget.profile.mothersOccupation ?? 'N/A',
          ),
          _buildDetailRow(
            'Siblings',
            widget.profile.numberOfSiblings?.toString() ?? 'N/A',
          ),
          _buildDetailRow(
            'Family Values',
            widget.profile.familyValues ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesDetails() {
    return _buildDetailSection(
      title: 'Preferences',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Partner Preferences (Coming Soon)',
            style: AppTextStyles.bodyText,
          ),
        ],
      ),
    );
  }
}
