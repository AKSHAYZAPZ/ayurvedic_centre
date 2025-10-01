import 'package:ayurvedic_centre/ui/screens/home_screen.dart';
import 'package:ayurvedic_centre/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/splash_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splash, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!splash.loading) {
            await Future.delayed(const Duration(seconds: 2));
            if (splash.isAuthenticated == true) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) =>  LoginScreen()),
              );
            }
          }
        });

        return Scaffold(
          body: SizedBox.expand(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
