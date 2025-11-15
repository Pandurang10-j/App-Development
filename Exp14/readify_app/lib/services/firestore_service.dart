import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firestore collections on first run
  Future<void> initializeCollections() async {
    try {
      // Check if collections exist, if not create them
      await _createAdminCollection();
      await _createVIPCollection();
      print('✅ Firestore collections initialized');
    } catch (e) {
      print('⚠️ Error initializing collections: $e');
    }
  }
  // Add to FirestoreService class
  Future<void> createDefaultAdmin() async {
   try {
    await _firestore.collection('admins').doc('admin@readify.com').set({
    'email': 'admin@readify.com',
    'createdAt': FieldValue.serverTimestamp(),
    'role': 'admin',
    'name': 'Admin',
  });
    print('✅ Default admin created: admin@readify.com');
    print('   Password: admin123 (set this manually in Firebase Auth)');
  } catch (e) {
    print('⚠️ Error creating default admin: $e');
  }
}

  // Create admin collection with default admin
  Future<void> _createAdminCollection() async {
    try {
      final adminDoc = await _firestore.collection('admins').doc('admin@readify.com').get();
      
      if (!adminDoc.exists) {
        await _firestore.collection('admins').doc('admin@readify.com').set({
          'email': 'admin@readify.com',
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'admin',
        });
        print('✅ Admin collection created with default admin');
      }
    } catch (e) {
      print('⚠️ Error creating admin collection: $e');
    }
  }

  // Create VIP collection with sample VIP user
  Future<void> _createVIPCollection() async {
    try {
      final vipDoc = await _firestore.collection('vip_users').doc('vip@readify.com').get();
      
      if (!vipDoc.exists) {
        await _firestore.collection('vip_users').doc('vip@readify.com').set({
          'email': 'vip@readify.com',
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'vip',
        });
        print('✅ VIP collection created with sample VIP user');
      }
    } catch (e) {
      print('⚠️ Error creating VIP collection: $e');
    }
  }

  // Determine user role based on email
  Future<String> determineUserRole(String email) async {
    try {
      // Check if admin
      final adminDoc = await _firestore.collection('admins').doc(email).get();
      if (adminDoc.exists) {
        print('✅ User is Admin: $email');
        return 'admin';
      }

      // Check if VIP
      final vipDoc = await _firestore.collection('vip_users').doc(email).get();
      if (vipDoc.exists) {
        print('✅ User is VIP: $email');
        return 'vip';
      }

      print('✅ User is regular user: $email');
      return 'user';
    } catch (e) {
      print('⚠️ Error determining role: $e');
      return 'user';
    }
  }

  // Create or update user in Firestore
  Future<void> createOrUpdateUser(User firebaseUser) async {
    try {
      final role = await determineUserRole(firebaseUser.email ?? '');
      
      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoURL: firebaseUser.photoURL,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toMap(), SetOptions(merge: true));
      
      print('✅ User created/updated in Firestore: ${firebaseUser.email}');
    } catch (e) {
      print('⚠️ Firestore Error: $e');
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('⚠️ Get User Error: $e');
      return null;
    }
  }

  // Save reading progress
  Future<void> saveReadingProgress(
    String uid,
    String contentId,
    String contentType,
    int progress,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('reading_progress')
          .doc(contentId)
          .set({
        'contentType': contentType,
        'progress': progress,
        'lastRead': FieldValue.serverTimestamp(),
      });
      print('✅ Reading progress saved');
    } catch (e) {
      print('⚠️ Save Progress Error: $e');
    }
  }

  // Add to bookmarks
  Future<void> addBookmark(String uid, Map<String, dynamic> content) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .add({
        ...content,
        'bookmarkedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Bookmark added');
    } catch (e) {
      print('⚠️ Add Bookmark Error: $e');
    }
  }

  // Get bookmarks
  Future<List<Map<String, dynamic>>> getBookmarks(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .orderBy('bookmarkedAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('⚠️ Get Bookmarks Error: $e');
      return [];
    }
  }

  // Remove bookmark
  Future<void> removeBookmark(String uid, String bookmarkId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .doc(bookmarkId)
          .delete();
      print('✅ Bookmark removed');
    } catch (e) {
      print('⚠️ Remove Bookmark Error: $e');
    }
  }

  // Make user VIP
  Future<void> makeUserVIP(String email) async {
    try {
      await _firestore.collection('vip_users').doc(email).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'vip',
      });
      print('✅ User promoted to VIP: $email');
    } catch (e) {
      print('⚠️ Error promoting to VIP: $e');
    }
  }

  // Make user Admin
  Future<void> makeUserAdmin(String email) async {
    try {
      await _firestore.collection('admins').doc(email).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'admin',
      });
      print('✅ User promoted to Admin: $email');
    } catch (e) {
      print('⚠️ Error promoting to Admin: $e');
    }
  }

  // Get all users (for admin dashboard)
  Stream<QuerySnapshot> getAllUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      print('✅ User deleted: $uid');
    } catch (e) {
      print('⚠️ Error deleting user: $e');
    }
  }
}