import '../data/account_repository.dart';
import '../../../../core/constants/db_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/user.dart';

class AccountService implements AccountRepository {
  AccountService._privateConstructor();
  static final AccountService instance = AccountService._privateConstructor();

  factory AccountService() => instance;

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final String currentUserId = _firebaseAuth.currentUser!.uid;
      DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore
          .instance
          .collection(DBCollection.user)
          .doc(currentUserId);
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();

      final Map<String, dynamic> userData = userSnapshot.data()!;

      final user = UserModel(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          fcmToken: userData['fcmToken']);

      return user;
    } catch (e) {
      return null;
    }
  }
}
