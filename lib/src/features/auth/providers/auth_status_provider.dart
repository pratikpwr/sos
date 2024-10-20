import 'package:flutter/material.dart';
import 'package:sos_app/src/features/auth/models/user_profile_model.dart';
import 'package:sos_app/src/features/auth/repository/auth_repository.dart';

class AuthStatusProvider extends ChangeNotifier {
  final AuthRepository _authService;

  AuthStatusProvider(this._authService);

  UserProfileModel? _user;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;

  Future<bool> isSignIn() async {
    _isLoading = true;
    _user = null;
    notifyListeners();

    final result = await _authService.getCurrentUser();
    result.fold(
      (failure) {
        _isLoading = false;
        notifyListeners();
      },
      (user) {
        _isLoading = false;
        _user = user;
        notifyListeners();
      },
    );
    return _user != null;
  }
}
