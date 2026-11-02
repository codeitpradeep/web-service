import 'package:flutter/material.dart';
import 'package:my_web_project/pages/user_dashboard_page.dart';
import 'package:my_web_project/pages/search_results_page.dart';
import 'package:my_web_project/widgets/app_header.dart';

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: UserDashboardPage()));
  }
}
