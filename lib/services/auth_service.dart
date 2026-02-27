import 'dart:async';
import 'package:dio/dio.dart';
import 'medusa_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();
  final Dio _dio = MedusaService.instance.dio;

  bool _isSignedIn = false;
  bool _hasSeenOnboarding = false;
  String? _currentUserEmail;
  String? _currentUserId;

  bool get isSignedIn => _isSignedIn;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUserId => _currentUserId;

  void markOnboardingSeen() {
    _hasSeenOnboarding = true;
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '/auth/customer/emailpass/login',
        data: {'email': email, 'password': password},
      );

      // In V2, the response structure for auth might differ. 
      // Usually it returns a token or sets a session cookie.
      // We might need to fetch the customer separately if not in response.
      
      await checkSession();
    } catch (e) {
      throw Exception('Login failed: Invalid email or password.');
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final names = name.split(' ');
      final firstName = names.first;
      final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

      // V2 registration endpoint
      await _dio.post(
        '/auth/customer/emailpass/register',
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      // Automatically sign in after registration
      await signIn(email: email, password: password);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        throw Exception('Email already exists or invalid data.');
      }
      throw Exception('Registration failed.');
    }
  }

  Future<void> checkSession() async {
    try {
      final response = await _dio.get('/store/customers/me');
      final customer = response.data['customer'];

      if (customer != null) {
        _isSignedIn = true;
        _currentUserEmail = customer['email'];
        _currentUserId = customer['id'];
      } else {
        _isSignedIn = false;
        _currentUserEmail = null;
        _currentUserId = null;
      }
    } catch (e) {
      _isSignedIn = false;
      _currentUserEmail = null;
      _currentUserId = null;
    }
  }

  Future<void> signOut() async {
    try {
      await _dio.delete('/store/auth');
    } catch (e) {
      // Ignore network errors on signout, clear local state anyway
    } finally {
      _isSignedIn = false;
      _currentUserEmail = null;
      _currentUserId = null;
    }
  }
}
