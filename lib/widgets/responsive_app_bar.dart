import 'package:flutter/material.dart';
import 'package:my_web_project/responsive_layout.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Tamil Matrimony'),
      // Show a hamburger icon on mobile
      leading: ResponsiveLayout.isMobile(context)
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            )
          : null,
      actions: [
        // Show navigation buttons on desktop
        if (ResponsiveLayout.isDesktop(context))
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Home')),
              TextButton(onPressed: () {}, child: const Text('Search')),
              TextButton(onPressed: () {}, child: const Text('Login')),
              TextButton(onPressed: () {}, child: const Text('Register')),
            ],
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
