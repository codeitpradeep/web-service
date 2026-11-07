import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/pages/public_page_template.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicPageTemplate(
      title: 'About Us',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Tiruppur Kulalar Matrimony, your trusted platform for finding life partners within the Tamil-speaking community worldwide. Our mission is to provide a secure and user-friendly environment where individuals can connect, communicate, and build meaningful relationships leading to successful marriages.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Founded with the vision to preserve and promote Tamil cultural values in matrimony, we understand the importance of tradition and family in the journey of finding a soulmate. Our advanced search features and dedicated support team ensure a seamless experience for all our members.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            'Our Commitment:',
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(
            'Authenticity',
            'We verify profiles to ensure genuine connections.',
          ),
          _buildBulletPoint(
            'Privacy',
            'Your data and communications are protected with advanced security measures.',
          ),
          _buildBulletPoint(
            'Support',
            'Our customer support team is always here to assist you.',
          ),
          const SizedBox(height: 24),
          Text(
            'Thank you for choosing Tiruppur Kulalar Matrimony. We wish you the very best in your search!',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 20,
            color: AppColors.primary500,
          ), // Checkmark icon
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.secondary700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
