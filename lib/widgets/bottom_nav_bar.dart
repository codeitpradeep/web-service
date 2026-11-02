import 'package:flutter/material.dart';
import 'package:my_web_project/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isLoggedIn;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    final List<_BottomNavItem> items = isLoggedIn
        ? const [
            _BottomNavItem(icon: Icons.person_outline, title: 'My Profile'),
            _BottomNavItem(icon: Icons.favorite_border, title: 'Matches'),
            _BottomNavItem(icon: Icons.search, title: 'Search'),
            _BottomNavItem(icon: Icons.message_outlined, title: 'Messages'),
          ]
        : const [
            _BottomNavItem(icon: Icons.home_outlined, title: 'Home'),
            _BottomNavItem(icon: Icons.login, title: 'Login'),
            _BottomNavItem(icon: Icons.app_registration, title: 'Register'),
            _BottomNavItem(icon: Icons.search, title: 'Search'),
          ];

    return Container(
      margin: const EdgeInsets.all(16).copyWith(top: 0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary100 : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected
                        ? AppColors.primary500
                        : AppColors.secondary400,
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: isSelected
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: AppColors.primary500,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomNavItem {
  final IconData icon;
  final String title;

  const _BottomNavItem({required this.icon, required this.title});
}
