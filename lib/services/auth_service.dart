import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login
  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _db.collection('users').doc(cred.user!.uid).get();
      return doc.data();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Signup
  static Future<void> signup({
    required String email,
    required String password,
    required String name,
    String role = 'parent',
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _db.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'fullName': name,
        'role': role,
        'parentId': null,
        'childrenIds': [],
        'isActive': true,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'profileImageUrl': null,
        'stats': {
          'analyzedPrompts': 0,
          'blockedThreats': 0,
          'allowedPrompts': 0,
          'hesitateCases': 0,
        },
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Logout
  static Future<void> logout() async => await _auth.signOut();

  // Fetch profile for ProfileScreen
  static Future<UserProfile?> fetchProfile() async {
    if (currentUser == null) return null;
    final doc = await _db.collection('users').doc(currentUser!.uid).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return UserProfile.fromMap(data);
  }

  // Update stats after each analysis
  static Future<void> updateStats(String decision) async {
    if (currentUser == null) return;
    final ref = _db.collection('users').doc(currentUser!.uid);

    final Map<String, dynamic> updates = {
      'stats.analyzedPrompts': FieldValue.increment(1),
    };

    if (decision == 'BLOCK') {
      updates['stats.blockedThreats'] = FieldValue.increment(1);
    } else if (decision == 'ALLOW') {
      updates['stats.allowedPrompts'] = FieldValue.increment(1);
    } else if (decision == 'HESITATE') {
      updates['stats.hesitateCases'] = FieldValue.increment(1);
    }

    await ref.update(updates);
  }
}
