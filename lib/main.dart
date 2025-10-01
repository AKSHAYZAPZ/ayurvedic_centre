import 'package:ayurvedic_centre/core/color_constants.dart';
import 'package:ayurvedic_centre/providers/auth_provider.dart';
import 'package:ayurvedic_centre/providers/home_provider.dart';
import 'package:ayurvedic_centre/providers/patient_provider.dart';
import 'package:ayurvedic_centre/providers/splash_provider.dart';
import 'package:ayurvedic_centre/repositories/home_repository.dart';
import 'package:ayurvedic_centre/repositories/patient_repository.dart';
import 'package:ayurvedic_centre/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/api_service.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final patientRepo = PatientRepository(apiService);
    final homeRepo = HomeRepository(apiService);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(service: apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(repository: homeRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => PatientProvider(repo: patientRepo),
        ),
        ChangeNotifierProvider(create: (_) => SplashProvider()), // <- added
      ],
      child: MaterialApp(
        title: 'Ayurvedic Centre',
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: ColorConstants.white),
          dialogTheme: DialogThemeData(backgroundColor: ColorConstants.white),
          scaffoldBackgroundColor: ColorConstants.white,
          primarySwatch: Colors.teal,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: ColorConstants.white,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
