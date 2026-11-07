import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/pages/public_page_template.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicPageTemplate(
      title: 'Terms & Conditions',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Tiruppur Kulalar Matrimony. By accessing or using our website and services, you agree to comply with and be bound by the following terms and conditions of use. Please read these terms carefully before using our platform.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            '1. Acceptance of Terms',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'By using Tiruppur Kulalar Matrimony, you signify your acceptance of these Terms and Conditions. If you do not agree to these terms, please do not use our services.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            '2. Eligibility',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To register on Tiruppur Kulalar Matrimony, you must be at least 18 years of age and legally eligible to marry as per the laws of your country/region. By using our service, you represent and warrant that you meet these eligibility requirements.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            '3. User Account and Security',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildListItem(
            'You are responsible for maintaining the confidentiality of your account information and password.',
          ),
          _buildListItem(
            'You agree to notify us immediately of any unauthorized use of your account.',
          ),
          _buildListItem(
            'We are not liable for any loss or damage arising from your failure to comply with these security obligations.',
          ),
          const SizedBox(height: 24),
          Text(
            '4. Code of Conduct',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildListItem(
            'You agree to use the service in a respectful and lawful manner.',
          ),
          _buildListItem(
            'You must not post any offensive, abusive, or defamatory content.',
          ),
          _buildListItem(
            'Any misuse of the platform may lead to immediate account termination.',
          ),
          const SizedBox(height: 24),
          Text(
            '5. Content and Intellectual Property',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildListItem(
            'You retain ownership of the content you submit to your profile.',
          ),
          _buildListItem(
            'By submitting content, you grant Tiruppur Kulalar Matrimony a license to use, modify, and display it on our platform.',
          ),
          _buildListItem(
            'All other content on the website is the property of Tiruppur Kulalar Matrimony and protected by intellectual property laws.',
          ),
          const SizedBox(height: 24),
          Text(
            '6. Limitation of Liability',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tiruppur Kulalar Matrimony shall not be liable for any direct, indirect, incidental, special, consequential, or exemplary damages arising from your use of the service.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            '7. Governing Law',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'These Terms and Conditions shall be governed by and construed in accordance with the laws of India.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            '8. Changes to Terms',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We reserve the right to modify these Terms and Conditions at any time. Your continued use of the service after such modifications constitutes your agreement to the updated terms.',
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
