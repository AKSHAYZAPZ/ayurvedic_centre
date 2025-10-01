import 'package:ayurvedic_centre/core/color_constants.dart';
import 'package:ayurvedic_centre/ui/widgets/app_button.dart';
import 'package:ayurvedic_centre/ui/widgets/app_text_formfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 217, width: double.infinity),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Login or register to book your appointments",
                      style: TextStyle(
                        color: ColorConstants.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstants.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextFormField(
                      controller: _userCtrl,
                      hintText: 'Enter your email',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstants.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextFormField(
                      controller: _passCtrl,
                      hintText: 'Enter password',
                      isPassword: true,
                      obscure: auth.obscure,
                      // from provider
                      suffixIcon: IconButton(
                        icon: Icon(
                          auth.obscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorConstants.black.withValues(alpha: 0.6),
                        ),
                        onPressed: () => auth.toggle(),
                      ),
                    ),
                    const SizedBox(height: 44),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        isLoading: auth.loading,
                        text: 'Login',
                        onTap: auth.loading
                            ? null
                            : () async {
                                try {
                                  await context.read<AuthProvider>().login(
                                    _userCtrl.text.trim(),
                                    _passCtrl.text.trim(),
                                  );

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => HomeScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Login failed: $e')),
                                  );
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  children: [
                    const TextSpan(
                      text:
                          "By creating or logging into an account you are agreeing with our ",
                    ),
                    TextSpan(
                      text: "Terms and Conditions",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy.",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
