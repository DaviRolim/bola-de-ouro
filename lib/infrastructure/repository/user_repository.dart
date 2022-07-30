import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/player.dart';

class UserState extends ChangeNotifier {
  List<QueryDocumentSnapshot<Player>>? _users;
  List<QueryDocumentSnapshot<Player>> get users => _users ?? [];

  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Player> get _usersRef =>
      _firestore.collection('users').withConverter<Player>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              data?['id'] = snapshot.id;
              return Player.fromJson(data);
            },
            toFirestore: (Player player, _) => player.toJson(),
          );
  UserState() {
    _usersRef
        .orderBy('monthlyPayer', descending: true)
        .snapshots()
        .listen((event) {
      _users = event.docs;
      notifyListeners();
    });
  }

  
  void goalScoredBy(String userId) {
    _usersRef.doc(userId).update({"totalGols": FieldValue.increment(1)});
  }

  void editUser(String id, String name, bool isMonthlyPayer, int totalGols,
      DateTime? lastPay) {
    final jsonNewUser = {
      "name": name,
      "monthlyPayer": isMonthlyPayer,
      "totalGols": totalGols,
      "lastPay": lastPay
    };
    _firestore.collection('users').doc(id).set(jsonNewUser);
    notifyListeners();
  }

  void removeGolFromUser(String userId) {
    _usersRef.doc(userId).update({"totalGols": FieldValue.increment(-1)});
  }

  void addUser(String playerName, bool isMonthlyPayer) {
    final jsonNewUser = {
      "name": playerName,
      "monthlyPayer": isMonthlyPayer,
      "totalGols": 0
    };
    _firestore.collection('users').add(jsonNewUser);
    notifyListeners();
  }
}
