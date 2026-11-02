import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/pages/public_page_template.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How do I register on Tamil Matrimony?',
      'answer': 'You can register by clicking on the \'Register\' button on the homepage and filling out the required details. You\'ll need to provide your basic information, contact details, and set a password.',
    },
    {
      'question': 'Is it free to create a profile?',
      'answer': 'Yes, creating a profile and browsing through matches is absolutely free. You only pay for premium features like direct messaging or viewing contact details.',
    },
    {
      'question': 'How can I search for profiles?',
      'answer': 'Our advanced search allows you to filter profiles based on age, location, religion, caste, education, and occupation. You can access the search feature from the navigation bar.',
    },
    {
      'question': 'What if I forget my password?',
      'answer': 'You can reset your password by clicking on the \'Forgot Password\' link on the login page. Follow the instructions to create a new password.',
    },
    {
      'question': 'How do you ensure profile authenticity?',
      'answer': 'We have a robust verification process for new profiles. Our moderation team reviews each profile to ensure genuine information and weed out fake accounts.',
    },
    {
      'question': 'Can I update my profile details later?',
      'answer': 'Yes, you can edit your profile at any time from your dashboard. Navigate to the \'My Profile\' section and click on the \'Edit Profile\' button.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PublicPageTemplate(
      title: 'Frequently Asked Questions',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._faqs.map((faq) => _buildFAQItem(faq['question']!, faq['answer']!)),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w600, color: AppColors.textColor), // text-lg font-semibold
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            answer,
            style: AppTextStyles.bodyText.copyWith(color: AppColors.secondary700), // text-gray-600
          ),
        ),
      ],
    );
  }
}


