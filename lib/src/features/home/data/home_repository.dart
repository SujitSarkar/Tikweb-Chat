import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserStream();
}
