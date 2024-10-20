import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/core/utils/utils.dart';
import 'package:sos_app/src/features/auth/screens/sign_up_screen.dart';
import 'package:sos_app/src/features/auth/screens/verify_otp_screen.dart';
import 'package:sos_app/src/ui/atomic/atoms/custom_button.dart';

import '../providers/auth_provider.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Sign In to continue',
                          style: context.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Enter your phone number',
                          style: context.textTheme.titleLarge
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          style: context.textTheme.bodyLarge,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: context.textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.navigator
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ));
                                  },
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: context.theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  title: 'Next',
                  isLoading: authProvider.isLoading,
                  onTap: () async {
                    final phone = _phoneController.text;
                    if (phone.isEmpty) {
                      showSnackBar(context, 'Please enter phone number');
                      return;
                    } else if (phone.length != 10) {
                      showSnackBar(context, 'Please enter valid phone number');
                      return;
                    }

                    FocusScope.of(context).unfocus();
                    final result = await authProvider.signIn(phone);
                    if (result == AuthState.otpSent) {
                      context.pushScreen(VerifyOtpScreen(
                        phoneNumber: phone,
                        isSignIn: true,
                      ));
                    } else if (result == AuthState.userNotFound) {
                      showSnackBar(context, "User Not Found!");
                    } else {
                      showSnackBar(context,
                          authProvider.error ?? "Something went Wrong!");
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
