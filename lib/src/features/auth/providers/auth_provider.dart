import 'package:flutter/material.dart';
import 'package:sos_app/src/core/error/failure_types.dart';
import 'package:sos_app/src/core/utils/utils.dart';
import 'package:sos_app/src/features/auth/repository/auth_repository.dart';

enum AuthState {
  initial,
  signInRequired, // show sign in screen
  otpSent,
  authenticated, // otp verified
  userNotFound, // show sign up screen
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authService;

  AuthProvider(this._authService);

  bool _isLoading = false;
  String? _error;

  AuthState authState = AuthState.initial;

  bool get isLoading => _isLoading;

  String get error => _error ?? "Something went Wrong!";

  Future<AuthState> signIn(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.signIn(phone: phone);

    result.fold(
      (failure) {
        _isLoading = false;
        _error = failure.message;
        if (FailureType.notFound == FailureType.fromFailure(failure)) {
          authState = AuthState.userNotFound;
        } else {
          authState = AuthState.error;
        }
        notifyListeners();
      },
      (result) {
        _isLoading = false;
        authState = AuthState.otpSent;
        notifyListeners();
      },
    );
    return authState;
  }

  Future<AuthState> signUp(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.signUp(phone: phone);

    result.fold(
      (failure) {
        _isLoading = false;
        _error = failure.message;
        authState = AuthState.error;
        notifyListeners();
      },
      (result) {
        _isLoading = false;
        authState = AuthState.otpSent;
        notifyListeners();
      },
    );

    return authState;
  }

  Future<bool> verifyOtp({
    required String phone,
    required String otp,
    required bool isSignIn,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.verifyOtp(
      phone: phone,
      otp: otp,
      isSignIn: isSignIn,
    );

    result.fold(
      (failure) {
        _isLoading = false;
        _error = failure.message;
        authState = AuthState.error;
        notifyListeners();
      },
      (user) {
        _isLoading = false;
        authState = AuthState.authenticated;
        notifyListeners();
      },
    );

    return authState == AuthState.authenticated;
  }
}
