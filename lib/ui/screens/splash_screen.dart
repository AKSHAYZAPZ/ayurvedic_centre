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
        if (splash.loading) {
          return Scaffold(
            body:Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (splash.isAuthenticated == true) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            }
          });

          return const Scaffold(body: SizedBox.shrink());
        }
      },
    );
  }
}
