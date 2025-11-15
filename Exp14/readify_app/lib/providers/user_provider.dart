import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? get currentUser => _currentUser;
  bool get isGuest => _currentUser?.role == 'guest';
  bool get isVIP => _currentUser?.role == 'vip';
  bool get isAdmin => _currentUser?.role == 'admin';

  Future<void> loadUser(User firebaseUser) async {
    _currentUser = await _firestoreService.getUserData(firebaseUser.uid);
    notifyListeners();
  }

  void setGuestUser() {
    _currentUser = UserModel(
      uid: 'guest',
      email: 'guest@readify.com',
      role: 'guest',
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}