import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';
import 'package:my_web_project/pages/public_page_template.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicPageTemplate(
      title: 'Contact Us',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We\'re here to help! If you have any questions, feedback, or need assistance, please don\'t hesitate to reach out to us using the contact information below or by filling out the form.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          Text(
            'General Inquiries',
            style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildContactInfoRow(Icons.email, 'Email', 'support@tamilmatrimony.com'),
          _buildContactInfoRow(Icons.phone, 'Phone', '+91 98765 43210'),
          _buildContactInfoRow(Icons.location_on, 'Address', '123 Matrimony Road, Chennai, Tamil Nadu, India'),
          const SizedBox(height: 24),
          Text(
            'Send Us a Message',
            style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Your Name',
            hintText: 'Enter your name',
            obscureText: false,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Your Email',
            hintText: 'Enter your email address',
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Subject',
            hintText: 'Enter the subject of your message',
            obscureText: false,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          Text(
            'Your Message',
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Type your message here...',
              hintStyle: AppTextStyles.bodyText.copyWith(color: AppColors.secondary600),
              filled: true,
              fillColor: AppColors.secondary50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.secondary200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary500, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            keyboardType: TextInputType.multiline,
            style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement send message logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16), // py-3 px-6
                textStyle: AppTextStyles.buttonText.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
              ),
              child: const Text('Send Message'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.primary500),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600, color: AppColors.secondary700)),
              Text(value, style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required bool obscureText,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyText.copyWith(color: AppColors.secondary600),
            filled: true,
            fillColor: AppColors.secondary50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary500, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyText.copyWith(color: AppColors.textColor),
        ),
      ],
    );
  }
}





