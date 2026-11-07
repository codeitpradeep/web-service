import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/pages/public_page_template.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicPageTemplate(
      title: 'Privacy Policy',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Privacy Policy describes how Tiruppur Kulalar Matrimony collects, uses, and discloses your personal information when you use our website and services. We are committed to protecting your privacy and handling your data in an open and transparent manner.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            '1. Information We Collect',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We collect various types of information in connection with the services we provide, including:',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          _buildListItem(
            'Personal Identification Information (Name, email address, phone number, date of birth, gender, photos)',
          ),
          _buildListItem(
            'Demographic Information (Religion, caste, mother tongue, marital status, education, occupation, income, family details, partner preferences)',
          ),
          _buildListItem(
            'Usage Data (Information on how the Service is accessed and used, including IP addresses, browser type, etc.)',
          ),
          const SizedBox(height: 24),
          Text(
            '2. How We Use Your Information',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We use the collected data for various purposes:',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          _buildListItem('To provide and maintain our Service'),
          _buildListItem('To notify you about changes to our Service'),
          _buildListItem(
            'To allow you to participate in interactive features of our Service when you choose to do so',
          ),
          _buildListItem('To provide customer support'),
          _buildListItem(
            'To provide personalized services and recommendations',
          ),
          _buildListItem('To monitor the usage of our Service'),
          _buildListItem('To detect, prevent and address technical issues'),
          const SizedBox(height: 24),
          Text(
            '3. Disclosure of Your Information',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We may share your personal information in the following situations:',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          _buildListItem(
            'With Service Providers (e.g., hosting, analytics, customer support)',
          ),
          _buildListItem(
            'For Business Transfers (in connection with a merger or acquisition)',
          ),
          _buildListItem('For Law Enforcement (when required by law)'),
          _buildListItem('With Your Consent'),
          const SizedBox(height: 24),
          Text(
            '4. Security of Your Data',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            '5. Your Data Protection Rights',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Depending on your location, you may have the following data protection rights:',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          _buildListItem(
            'The right to access, update or delete the information we have on you.',
          ),
          _buildListItem('The right of rectification.'),
          _buildListItem('The right to object.'),
          _buildListItem('The right of restriction.'),
          _buildListItem('The right to data portability.'),
          _buildListItem('The right to withdraw consent.'),
          const SizedBox(height: 24),
          Text(
            '6. Changes to This Privacy Policy',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
