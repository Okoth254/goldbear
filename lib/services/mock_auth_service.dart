import 'dart:async';

class MockAuthService {
  MockAuthService._();

  static final MockAuthService instance = MockAuthService._();

  bool _isSignedIn = false;
  bool _hasSeenOnboarding = false;
  String? _currentUserEmail;

  bool get isSignedIn => _isSignedIn;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  String? get currentUserEmail => _currentUserEmail;

  void markOnboardingSeen() {
    _hasSeenOnboarding = true;
  }

  Future<void> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address.');
    }
    if (password.trim().length < 4) {
      throw Exception('Password must be at least 4 characters.');
    }

    _isSignedIn = true;
    _currentUserEmail = email.trim();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (name.trim().isEmpty) {
      throw Exception('Please enter your full name.');
    }
    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address.');
    }
    if (password.trim().length < 8) {
      throw Exception('Password must contain at least 8 characters.');
    }

    _isSignedIn = true;
    _currentUserEmail = email.trim();
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 350));
    _isSignedIn = false;
    _currentUserEmail = null;
  }

  bool _isValidEmail(String email) {
    final normalized = email.trim();
    return normalized.contains('@') && normalized.contains('.');
  }
}
