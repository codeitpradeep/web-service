import 'package:flutter/material.dart';
import 'package:my_web_project/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // Wait for the widget to be fully built before navigating
    await Future.delayed(Duration.zero);

    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    if (session != null) {
      // If session exists, check if profile is complete
      final profile =
          await Supabase.instance.client
                  .from('profiles')
                  .select()
                  .eq('id', session.user.id)
                  .single()
              as Map<String, dynamic>?;

      if (!mounted) return;

      if (profile != null &&
          profile['full_name'] != null &&
          profile['full_name'].isNotEmpty) {
        // If profile is complete, go to user dashboard
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        // If profile is not complete, go to create/edit profile page
        Navigator.of(
          context,
        ).pushReplacementNamed('/create-edit-profile', arguments: null);
      }
    } else {
      // If no session, go to home page
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
