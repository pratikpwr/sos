import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/core/utils/utils.dart';
import 'package:sos_app/src/ui/atomic/atoms/custom_button.dart';
import 'package:sos_app/src/ui/atomic/organism/sos_bttom_bar.dart';

import '../providers/auth_provider.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String phoneNumber;
  final bool isSignIn;

  VerifyOtpScreen({
    required this.phoneNumber,
    required this.isSignIn,
  });

  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();

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
                          'Enter OTP to verify',
                          style: context.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'OTP has been sent to $phoneNumber',
                          style: context.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        OtpPinField(
                          key: _otpPinFieldController,
                          textInputAction: TextInputAction.done,
                          onSubmit: (text) {
                            print('Entered pin is $text');

                            verifyOtp(context, authProvider);
                          },
                          onChange: (text) {
                            print('Enter on change pin is $text');

                            /// return the entered pin
                          },
                          onCodeChanged: (code) {
                            print('onCodeChanged  is $code');
                          },
                          maxLength: 6,
                          mainAxisAlignment: MainAxisAlignment.center,
                          otpPinFieldDecoration:
                              OtpPinFieldDecoration.defaultPinBoxDecoration,
                        ),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  title: 'Verify',
                  isLoading: authProvider.isLoading,
                  onTap: () => verifyOtp(context, authProvider),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void verifyOtp(BuildContext context, AuthProvider authProvider) async {
    final String? pin = _otpPinFieldController.currentState?.pinsInputed.join();
    if (pin != null && pin.length == 6) {
      final result = await authProvider.verifyOtp(
        phone: phoneNumber,
        otp: pin,
        isSignIn: isSignIn,
      );
      if (result) {
        context.navigator.pop();
        context.navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => SOSBottomNavBar(),
        ));
      }
    } else {
      showSnackBar(context, 'Please enter valid OTP');
    }
  }
}
