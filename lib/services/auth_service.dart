import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signUp({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
    String? parentEmail,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;
      String? parentId;

      if (role == UserRole.child && parentEmail != null) {
        final parentQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: parentEmail.trim())
            .where('role', isEqualTo: 'parent')
            .limit(1)
            .get();

        if (parentQuery.docs.isNotEmpty) {
          parentId = parentQuery.docs.first.id;
          await _firestore.collection('users').doc(parentId).update({
            'childrenIds': FieldValue.arrayUnion([uid]),
          });
        }
      }

      final user = UserModel(
        uid: uid,
        fullName: fullName.trim(),
        email: email.trim(),
        role: role,
        parentId: parentId,
        childrenIds: role == UserRole.parent ? [] : null,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(user.toMap());
      await credential.user!.updateDisplayName(fullName.trim());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return await getUserData(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, uid);
    }
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<List<UserModel>> getChildrenForParent(String parentId) async {
    final query = await _firestore
        .collection('users')
        .where('parentId', isEqualTo: parentId)
        .where('role', isEqualTo: 'child')
        .get();
    return query.docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<UserModel>> getAllUsers() async {
    final query = await _firestore.collection('users').get();
    return query.docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<Map<String, int>> getUserStats() async {
    final all = await getAllUsers();
    return {
      'total': all.length,
      'admins': all.where((u) => u.role == UserRole.admin).length,
      'parents': all.where((u) => u.role == UserRole.parent).length,
      'children': all.where((u) => u.role == UserRole.child).length,
    };
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
  // Update stats after each analysis
// Static method for updating stats (called from home_screen)
static Future<void> updateStats(String decision) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  
  if (auth.currentUser == null) return;
  
  final ref = firestore.collection('users').doc(auth.currentUser!.uid);

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
// Static methods for profile_screen compatibility
static Future<UserProfile?> fetchProfile() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  
  if (auth.currentUser == null) return null;
  
  final doc = await firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .get();
      
  if (!doc.exists) return null;
  return UserProfile.fromMap(doc.data()!);
}

static Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}
}