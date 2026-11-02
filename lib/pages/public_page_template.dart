import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';

class PublicPageTemplate extends StatelessWidget {
  final String title;
  final Widget content;

  const PublicPageTemplate({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ), // Max width for readability
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.textColor,
                ), // text-3xl font-bold
              ),
              const SizedBox(height: 24),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
