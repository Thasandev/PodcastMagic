import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthRepository {
  final FirebaseAuth _auth;
  String? _verificationId;

  AuthRepository(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  /// Starts the Phone Number Verification process.
  /// 
  /// [phoneNumber] should be in E.164 format (e.g., '+919999999999').
  Future<void> sendOTP({
    required String phoneNumber,
    required Function() onCodeSent,
    required Function(String code) onAutoVerify,
    required Function(String errorMessage) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval completed or instant validation logic
        if (credential.smsCode != null) {
          onAutoVerify(credential.smsCode!);
        }
        await _signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        String message = 'Verification failed. Please try again.';
        if (e.code == 'invalid-phone-number') {
          message = 'The provided phone number is not valid.';
        }
        onError(message);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  /// Verifies the OTP entered by the user.
  Future<UserCredential> verifyOTP(String otp) async {
    if (_verificationId == null) {
      throw Exception('Verification ID is null. Please request OTP first.');
    }

    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    return await _signInWithCredential(credential);
  }

  Future<UserCredential> _signInWithCredential(AuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
