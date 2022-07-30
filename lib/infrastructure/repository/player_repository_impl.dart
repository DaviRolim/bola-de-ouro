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

  Stream<List<Player>> watchPlayers() {
    return _firestore
        .collection('users')
        .orderBy('monthlyPayer', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Player.fromJson(data);
      }).toList();
    });
  }

  void addUser(String playerName, bool isMonthlyPayer) {
    final jsonNewUser = {
      "name": playerName,
      "monthlyPayer": isMonthlyPayer,
      "totalGols": 0
    };
    _firestore.collection('users').add(jsonNewUser);
  }

  void updateUser(String id, String name, bool isMonthlyPayer, int totalGols,
      DateTime? lastPay) {
    final jsonNewUser = {
      "name": name,
      "monthlyPayer": isMonthlyPayer,
      "totalGols": totalGols,
      "lastPay": lastPay
    };
    _firestore.collection('users').doc(id).set(jsonNewUser);
  }

  // void goalScoredBy(String userId) {
  //   _usersRef.doc(userId).update({"totalGols": FieldValue.increment(1)});
  // }
  // void removeGolFromUser(String userId) {
  //   _usersRef.doc(userId).update({"totalGols": FieldValue.increment(-1)});
  // }
}
