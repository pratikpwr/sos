// import 'package:flutter/material.dart';
// import 'package:otp_pin_field/otp_pin_field.dart';
// import 'package:provider/provider.dart';
// import 'package:sos_app/src/core/extensions/context_extension.dart';
// import 'package:sos_app/src/core/utils/utils.dart';
//
// import '../providers/auth_provider.dart';
//
// class AuthScreen extends StatelessWidget {
//   final _phoneController = TextEditingController();
//   final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<AuthProvider>(
//         builder: (context, authProvider, child) {
//           return SafeArea(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 24),
//                         if (authProvider.authState == AuthState.signInRequired)
//                           Text(
//                             'Sign In to continue',
//                             style: context.textTheme.headlineSmall,
//                           ),
//                         if (authProvider.authState == AuthState.userNotFound)
//                           Text(
//                             'Sign Up to create account',
//                             style: context.textTheme.headlineSmall,
//                           ),
//                         const SizedBox(height: 24),
//                         if (authProvider.authState ==
//                                 AuthState.signInRequired ||
//                             authProvider.authState == AuthState.userNotFound)
//                           phoneField(context),
//                         if (authProvider.authState == AuthState.otpSent)
//                           otpView(),
//                       ],
//                     ),
//                   ),
//                 ),
//                 submitButton(context, authProvider),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget phoneField(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Enter your phone number',
//           style:
//               context.textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
//         ),
//         SizedBox(height: 16),
//         TextField(
//           controller: _phoneController,
//           decoration: InputDecoration(
//             hintText: 'Phone Number',
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget otpView() {
//     return Column(
//       children: [
//         OtpPinField(
//           key: _otpPinFieldController,
//           textInputAction: TextInputAction.done,
//           onSubmit: (text) {
//             print('Entered pin is $text');
//
//             /// return the entered pin
//           },
//           onChange: (text) {
//             print('Enter on change pin is $text');
//
//             /// return the entered pin
//           },
//           onCodeChanged: (code) {
//             print('onCodeChanged  is $code');
//           },
//           maxLength: 4,
//           mainAxisAlignment: MainAxisAlignment.center,
//         ),
//       ],
//     );
//   }
//
//   Widget submitButton(BuildContext context, AuthProvider provider) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Material(
//         child: InkWell(
//           onTap: () {
//             final phone = _phoneController.text;
//             if (phone.isEmpty) {
//               showSnackBar(context, 'Please enter phone number');
//               return;
//             } else if (phone.length != 10) {
//               showSnackBar(context, 'Please enter valid phone number');
//               return;
//             }
//
//             if (provider.authState == AuthState.signInRequired) {
//               provider.signIn(phone);
//             }
//             if (provider.authState == AuthState.userNotFound) {
//               provider.signUp(phone);
//             } else if (provider.authState == AuthState.otpSent) {
//               final String? pin =
//                   _otpPinFieldController.currentState?.pinsInputed.join();
//               if (pin != null && pin.length == 6) {
//                 provider.verifyOtp(phone, pin);
//               } else {
//                 showSnackBar(context, 'Please enter valid OTP');
//               }
//             }
//           },
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.redAccent,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               provider.authState == AuthState.otpSent ? 'Verify' : 'Next',
//               textAlign: TextAlign.center,
//               style: context.textTheme.bodyLarge
//                   ?.copyWith(color: Colors.white, fontSize: 22),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
