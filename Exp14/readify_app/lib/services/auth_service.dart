import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final FirestoreService _firestoreService = FirestoreService();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign In - Returns Map with success, user, and message
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Google Sign In cancelled by user');
        return {
          'success': false,
          'user': null,
          'message': 'Google Sign In cancelled',
        };
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _firestoreService.createOrUpdateUser(userCredential.user!);
      }
      
      print('✅ Google Sign In successful: ${userCredential.user?.email}');
      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Google Sign In successful',
      };
      
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      return {
        'success': false,
        'user': null,
        'message': e.message ?? 'Firebase Auth Error',
      };
    } catch (e) {
      print('❌ Google Sign In Error: $e');
      return {
        'success': false,
        'user': null,
        'message': 'Google Sign In failed: $e',
      };
    }
  }

  // Email & Password Sign Up - Returns Map with success, user, and message
  Future<Map<String, dynamic>> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = 
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        await _firestoreService.createOrUpdateUser(userCredential.user!);
      }
      
      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Account created successfully',
      };
    } on FirebaseAuthException catch (e) {
      print('❌ Sign Up Error: ${e.code} - ${e.message}');
      return {
        'success': false,
        'user': null,
        'message': e.message ?? 'Sign up failed',
      };
    } catch (e) {
      print('❌ Sign Up Error: $e');
      return {
        'success': false,
        'user': null,
        'message': 'Sign up failed: $e',
      };
    }
  }

  // Email & Password Sign In - Returns Map with success, user, and message
  Future<Map<String, dynamic>> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = 
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Sign in successful',
      };
    } on FirebaseAuthException catch (e) {
      print('❌ Sign In Error: ${e.code} - ${e.message}');
      return {
        'success': false,
        'user': null,
        'message': e.message ?? 'Sign in failed',
      };
    } catch (e) {
      print('❌ Sign In Error: $e');
      return {
        'success': false,
        'user': null,
        'message': 'Sign in failed: $e',
      };
    }
  }

  // Guest/Anonymous Sign In - Returns Map with success, user, and message
  Future<Map<String, dynamic>> signInAsGuest() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      print('✅ Guest sign in successful');
      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Guest sign in successful',
      };
    } on FirebaseAuthException catch (e) {
      print('❌ Guest Sign In Error: ${e.code} - ${e.message}');
      return {
        'success': false,
        'user': null,
        'message': e.message ?? 'Guest sign in failed',
      };
    } catch (e) {
      print('❌ Guest Sign In Error: $e');
      return {
        'success': false,
        'user': null,
        'message': 'Guest sign in failed: $e',
      };
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      print('✅ User signed out successfully');
    } catch (e) {
      print('❌ Sign Out Error: $e');
    }
  }

  // Send Password Reset Email - Returns Map with success and message
  Future<Map<String, dynamic>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent successfully',
      };
    } on FirebaseAuthException catch (e) {
      print('❌ Password Reset Error: ${e.code} - ${e.message}');
      return {
        'success': false,
        'message': e.message ?? 'Password reset failed',
      };
    } catch (e) {
      print('❌ Password Reset Error: $e');
      return {
        'success': false,
        'message': 'Password reset failed: $e',
      };
    }
  }
}