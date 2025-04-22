import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medship/service/shared_pref.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await _auth.currentUser;
  }

  Future SignOut() async {
    await FirebaseAuth.instance.signOut();
    await SharedPreferenceHelper().clear();
  }

  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    try {
      await SharedPreferenceHelper().clear();

      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      final profileUrl = await SharedPreferenceHelper().getUserProfile();
      if (profileUrl != null && profileUrl.contains('firebase')) {
        final ref = FirebaseStorage.instance.refFromURL(profileUrl);
        await ref.delete();
      }

      await user?.delete();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}
