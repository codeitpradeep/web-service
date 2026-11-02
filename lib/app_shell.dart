import 'package:flutter/material.dart';
import 'package:my_web_project/pages/home_page.dart';
import 'package:my_web_project/pages/login_page.dart';
import 'package:my_web_project/pages/matches_page.dart';
import 'package:my_web_project/pages/register_page.dart';
import 'package:my_web_project/pages/search_results_page.dart';
import 'package:my_web_project/widgets/app_header.dart';
import 'package:my_web_project/widgets/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_web_project/pages/messages_page.dart';
import 'package:my_web_project/responsive_layout.dart';
import 'package:my_web_project/pages/user_dashboard_page.dart';

class AppShell extends StatefulWidget {
  final String initialRoute;
  const AppShell({super.key, this.initialRoute = '/home'});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  String _currentRoute = '/home';

  final Map<String, int> _loggedInRouteMap = {
    '/profile': 0,
    '/dashboard': 0, // Map dashboard to the same index as profile
    '/matches': 1,
    '/search': 2,
    '/messages': 3,
  };

  final Map<String, int> _loggedOutRouteMap = {
    '/home': 0,
    '/login': 1,
    '/register': 2,
    '/search': 3,
  };

  @override
  void initState() {
    super.initState();
    _checkLoginState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      if (mounted) {
        final newIsLoggedIn = session != null;
        if (_isLoggedIn != newIsLoggedIn) {
          // If we just logged in and are on the register page, ignore this update.
          // This prevents the UI from flashing "logged in" state before we sign out.
          if (newIsLoggedIn && _currentRoute == '/register') {
            return;
          }

          setState(() {
            _isLoggedIn = newIsLoggedIn;
            // Only navigate to home if we are NOT on login page.
            // The Login page handles its own navigation to Dashboard/Admin.
            if (_currentRoute != '/login') {
              _currentIndex = 0;
              _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            }
          });
        }
      }
    });
  }

  void _checkLoginState() {
    final session = Supabase.instance.client.auth.currentSession;
    if (mounted) {
      setState(() {
        _isLoggedIn = session != null;
      });
    }
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    final routes = _isLoggedIn
        ? ['/profile', '/matches', '/search', '/messages', '/logout']
        : ['/home', '/login', '/register', '/search'];

    if (index < routes.length) {
      final routeName = routes[index];
      if (routeName == '/logout') {
        Supabase.instance.client.auth.signOut();
      } else {
        _navigatorKey.currentState?.pushReplacementNamed(routeName);
        setState(() {
          _currentIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        isLoggedIn: _isLoggedIn,
        onHomePressed: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/home'),
        onLoginPressed: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/login'),
        onRegisterPressed: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/register'),
        onSearchPressed: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/search'),
        onProfilePressed: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/dashboard'),
        onMatchesPressed: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/matches'),
        onMessagesPressed: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/messages'),
      ),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: widget.initialRoute,
        onGenerateRoute: _onGenerateRoute,
        observers: [
          _RouteObserver(
            onRouteChange: (routeName) {
              if (routeName == null) return;
              _currentRoute = routeName;
              final map = _isLoggedIn ? _loggedInRouteMap : _loggedOutRouteMap;
              if (map.containsKey(routeName)) {
                final newIndex = map[routeName]!;
                if (_currentIndex != newIndex) {
                  setState(() {
                    _currentIndex = newIndex;
                  });
                }
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveLayout.isMobile(context)
          ? BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              isLoggedIn: _isLoggedIn,
            )
          : null,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/home':
        page = const HomePage();
        break;
      case '/login':
        page = const LoginPage();
        break;
      case '/register':
        page = const RegisterPage();
        break;
      case '/search':
        page = const SearchResultsPage();
        break;
      case '/profile':
        page = const UserDashboardPage();
        break;
      case '/matches':
        page = const MatchesPage();
        break;
      case '/messages':
        page = const MessagesPage();
        break;
      case '/dashboard':
        page = const UserDashboardPage();
        break;
      default:
        page = const HomePage();
        break;
    }
    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }
}

class _RouteObserver extends NavigatorObserver {
  final Function(String?) onRouteChange;

  _RouteObserver({required this.onRouteChange});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRouteChange(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      onRouteChange(newRoute.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      onRouteChange(previousRoute.settings.name);
    }
  }
}
