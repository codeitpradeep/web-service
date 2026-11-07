import 'package:flutter/material.dart';
import 'package:my_web_project/responsive_layout.dart';
import 'package:my_web_project/theme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final bool isLoggedIn;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onMatchesPressed;
  final VoidCallback? onMessagesPressed;
  final VoidCallback? onHomePressed;
  final List<String>? navLinks;

  const AppHeader({
    super.key,
    this.titleText = 'TiruppurKulalarMatrimony',
    required this.isLoggedIn,
    this.onLoginPressed,
    this.onRegisterPressed,
    this.onSearchPressed,
    this.onProfilePressed,
    this.onMatchesPressed,
    this.onMessagesPressed,
    this.onHomePressed,
    this.navLinks,
  });

  @override
  Widget build(BuildContext context) {
    final bool showAuthButtons = !isLoggedIn;
    final bool showProfileAvatar = isLoggedIn;
    final List<String> finalNavLinks =
        navLinks ??
        (isLoggedIn
            ? ['My Profile', 'Matches', 'Search', 'Messages']
            : ['Home', 'Search', 'Help']);

    return AppBar(
      automaticallyImplyLeading: false, // Prevent duplicate menu button
      backgroundColor: AppColors.secondary50,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            if (ResponsiveLayout.isMobile(context) &&
                Scaffold.of(context).hasDrawer)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            // Logo SVG (Placeholder for now)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(4),
              ),
              margin: const EdgeInsets.only(right: 16),
              child: const Center(
                child: Icon(Icons.favorite, color: Colors.white, size: 24),
              ),
            ),
            Expanded(
              child: Text(
                titleText,
                style: AppTextStyles.navLink.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            if (ResponsiveLayout.isDesktop(context)) ...[
              Row(
                children: finalNavLinks.map((link) {
                  VoidCallback? onPressed;
                  switch (link) {
                    case 'Home':
                      onPressed = onHomePressed;
                      break;
                    case 'Search':
                      onPressed = onSearchPressed;
                      break;
                    case 'My Profile':
                      onPressed = onProfilePressed;
                      break;
                    case 'Matches':
                      onPressed = onMatchesPressed;
                      break;
                    case 'Messages':
                      onPressed = onMessagesPressed;
                      break;
                  }

                  return TextButton(
                    onPressed: onPressed,
                    child: Text(
                      link,
                      style: AppTextStyles.navLink.copyWith(
                        color: link == 'Home' ? AppColors.primary500 : null,
                      ),
                    ), // Active for Home
                  );
                }).toList(),
              ),
              const SizedBox(width: 32),
              if (showAuthButtons || showProfileAvatar)
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.language, size: 20),
                      label: Text(
                        'English',
                        style: AppTextStyles.buttonTextSecondary.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textColor,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        backgroundColor: AppColors.secondary100,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (showAuthButtons) ...[
                      ElevatedButton(
                        onPressed: onRegisterPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.secondary50,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          textStyle: AppTextStyles.buttonText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(84, 40),
                        ),
                        child: const Text('Register'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: onLoginPressed,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.secondary100,
                          foregroundColor: AppColors.textColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          textStyle: AppTextStyles.buttonTextSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(84, 40),
                        ),
                        child: const Text('Login'),
                      ),
                    ] else if (showProfileAvatar) ...[
                      GestureDetector(
                        onTap: onProfilePressed,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            "https://picsum.photos/150",
                          ), // Placeholder avatar
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
