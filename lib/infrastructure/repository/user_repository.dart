import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/user.dart';

class UserState extends ChangeNotifier {
  List<QueryDocumentSnapshot<User>>? _users;
  List<QueryDocumentSnapshot<User>> get users => _users ?? [];

  final _firestore = FirebaseFirestore.instance;

  CollectionReference<User> get _usersRef =>
      _firestore.collection('users').withConverter<User>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              data?['id'] = snapshot.id;
              return User.fromJson(data);
            },
            toFirestore: (User user, _) => user.toJson(),
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

  Future<QuerySnapshot> _getMonthlyPayers() {
    return _usersRef.where('monthlyPayer', isEqualTo: true).get();
  }

  void goalScoredBy(String userId) {
    _usersRef.doc(userId).update({"totalGols": FieldValue.increment(1)});
  }

  void removeGolFromUser(String userId) {
    _usersRef.doc(userId).update({"totalGols": FieldValue.increment(-1)});
  }

  // void removePlayerFromNotPlayingList(String id) {
  //   _usersNotPlaying?.removeWhere((user) => user.data().id == id);
  //   notifyListeners();
  // }

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
