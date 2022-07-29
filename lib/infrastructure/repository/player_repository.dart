import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/player.dart';

class PlayerRepository {
  final _firestore = FirebaseFirestore.instance;
  Stream<List<Player>> watchMonthlyPlayers() {
    return _firestore
        .collection('users')
        .where("monthlyPayer", isEqualTo: true)
        .orderBy('totalGols', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Player.fromJson(data);
      }).toList();
    });
  }
}
