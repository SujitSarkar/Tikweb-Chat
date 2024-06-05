import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/db_collection.dart';
import '../data/home_repository.dart';

class HomeService implements HomeRepository {
  final _auth = FirebaseAuth.instance;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserStream() {
    return FirebaseFirestore.instance
        .collection(DBCollection.user)
        .where('id', isNotEqualTo: _auth.currentUser?.uid)
        .snapshots();
  }
}
